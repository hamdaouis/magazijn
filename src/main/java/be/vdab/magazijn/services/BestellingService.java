package be.vdab.magazijn.services;

import be.vdab.magazijn.domain.*;
import be.vdab.magazijn.dto.*;
import be.vdab.magazijn.exceptions.*;
import be.vdab.magazijn.repositories.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Stream;

@Service
@Transactional(readOnly = true)
public class BestellingService {
    private final ArtikelRepository artikelRepository;
    private final BestellingRepository bestellingRepository;
    private final BestellijnRepository bestellijnRepository;
    private final MagazijnPlaatsRepository magazijnPlaatsRepository;
    private final UitgaandeLeveringRepository uitgaandeLeveringRepository;

    public BestellingService(ArtikelRepository artikelRepository, BestellingRepository bestellingRepository,
                             BestellijnRepository bestellijnRepository,
                             MagazijnPlaatsRepository magazijnPlaatsRepository, UitgaandeLeveringRepository uitgaandeLeveringRepository) {
        this.artikelRepository = artikelRepository;
        this.bestellingRepository = bestellingRepository;
        this.bestellijnRepository = bestellijnRepository;
        this.magazijnPlaatsRepository = magazijnPlaatsRepository;
        this.uitgaandeLeveringRepository = uitgaandeLeveringRepository;
    }

    public List<Bestelling> findAll() {
        return bestellingRepository.findAll();
    }

    public Optional<Bestelling> findById(long id) {
        return bestellingRepository.findById(id);
    }

    public Stream<TvBestelling> vijfEerstvolgendeBestellingen() {
        if (bestellingRepository.findVolgendeVijfBestellingen().isEmpty()) {
            throw new BestellingNietGevondenException();
        } else {
            return bestellingRepository.findVolgendeVijfBestellingen().stream()
                    .map(bestelling -> {
                        var bestelId = bestelling.getBestelId();
                        var bestellijnen = bestellijnRepository.findBestellijnenByBestelId(bestelId);
                        var totaleGewicht = 0;
                        for (var bestellijn : bestellijnen) {
                            var gram = artikelRepository.findById(bestellijn.getArtikelId()).get().getGewichtInGram();
                            totaleGewicht = totaleGewicht + gram;
                        }
                        return new TvBestelling(bestelId, bestellijnen.size(), totaleGewicht);
                    });
        }
    }

    public int aantalBestellingen() {
        return bestellingRepository.findAantalBestellingen();
    }

    public Long findEerstvolgendeBestelId() {
        return bestellingRepository.findEerstvolgendeBestelId()
                .orElseThrow(GeenVolgendeBestellingException::new);
    }

    public Stream<BestellijnArtikel> findBestellijnArtikelenByBestelId(long bestelId) {
        var artikels = artikelRepository.findBestellijnArtikelBeknoptByBestelId(bestelId);
        List<BestellijnArtikel> result = new ArrayList<>();
        List<Long> failedArtikelIds = new ArrayList<>();
        for (var artikel : artikels) {
            var artikelAantal = artikel.aantal();
            var magazijnplaatsen = magazijnPlaatsRepository.findMagazijnPlaatsenByArtikelId(artikel.artikelId());
            magazijnplaatsen.removeIf(magazijnPlaats -> magazijnPlaats.getAantal() <= 0);
            List<MagazijnPlaatsMetAantalOpTeHalen> updatedMagazijnPlaatsen = new ArrayList<>();
            for (var magazijnplaats : magazijnplaatsen) {
                if (magazijnplaats.getAantal() >= artikelAantal) {
                    updatedMagazijnPlaatsen.add(new MagazijnPlaatsMetAantalOpTeHalen(magazijnplaats, artikelAantal));
                    break;
                } else {
                    if (magazijnplaatsen.indexOf(magazijnplaats) == magazijnplaatsen.size() - 1) {
                        failedArtikelIds.add(artikel.artikelId());
                    }
                    updatedMagazijnPlaatsen.add(new MagazijnPlaatsMetAantalOpTeHalen(magazijnplaats, magazijnplaats.getAantal()));
                    artikelAantal -= magazijnplaats.getAantal();
                }
                if (magazijnplaatsen.isEmpty()) {
                    failedArtikelIds.add(artikel.artikelId());
                }
            }
            result.add(new BestellijnArtikel(artikel, updatedMagazijnPlaatsen));
        }
        if (!failedArtikelIds.isEmpty()) {
            throw new OnvoldoendeVoorraadException(failedArtikelIds);
        }
        return result.stream();
    }

    @Transactional
    public void verwerkBestelling(long bestelId) {

        var bestellijnArtikels = artikelRepository.findBestellijnArtikelBeknoptByBestelId(bestelId);
        List<Long> failedArtikelIds = new ArrayList<>();
        for (var bestellijnArtikel : bestellijnArtikels) {
            var artikel = artikelRepository.findAndLockById(bestellijnArtikel.artikelId()).orElseThrow(() -> new ArtikelNietGevondenException(bestellijnArtikel.artikelId()));
            var bestellijn = bestellijnRepository.findBestellijnByArtikelIdAndBestelId(artikel.getArtikelId(), bestelId);
            if (bestellijn.getAantalBesteld() > artikel.getVoorraad()) {
                failedArtikelIds.add(artikel.getArtikelId());
            } else {
                artikelRepository.verminderVoorraadMetAantal(artikel.getArtikelId(), bestellijn.getAantalBesteld());
            }
            var magazijnPlaatsen = magazijnPlaatsRepository.findAndLockMagazijnPlaatsenByArtikelId(artikel.getArtikelId());
            int aantal = bestellijn.getAantalBesteld() - bestellijn.getAantalGeannuleerd();
            for (var magazijnPlaats : magazijnPlaatsen) {
                var magazijnPlaatsAantal = magazijnPlaats.getAantal();
                if (magazijnPlaatsAantal < aantal) {
                    aantal -= magazijnPlaatsAantal;
                    magazijnPlaatsRepository.verlaagAantal(magazijnPlaats.getMagazijnPlaatsId(), magazijnPlaatsAantal);
                } else {
                    magazijnPlaatsAantal = aantal;
                    magazijnPlaatsRepository.verlaagAantal(magazijnPlaats.getMagazijnPlaatsId(), magazijnPlaatsAantal);
                    break;
                }

            }
        }
        if (!failedArtikelIds.isEmpty()) {
            throw new OnvoldoendeVoorraadException(failedArtikelIds);
        }
        var klantId = bestellingRepository.getKlantIdByBestelId(bestelId);
        uitgaandeLeveringRepository.create(new UitgaandeLeveringBestelIdKlantdId(bestelId, klantId));
    }

    @Transactional
    public RetourBestelling findRetourBestellingById(long id) {
        var bestelling = bestellingRepository.findById(id).orElseThrow(BestellingNietGevondenException::new);
        if (bestelling.getBestellingsStatusId() != 9) {
            throw new HetIsNietRetourBestellingException();
        }
        var bestellijnen = bestellijnRepository.findBestellijnenByBestelId(id);
        ArrayList<RetourArtikel> retourArtikels = new ArrayList<>();
        for (var bestellijn : bestellijnen) {
            var artiekel = artikelRepository.findById(bestellijn.getArtikelId()).orElseThrow(() -> new ArtikelNietGevondenException(bestellijn.getArtikelId()));
            retourArtikels.add(new RetourArtikel(bestellijn.getArtikelId(), artiekel.getEan(), artiekel.getBeschrijving(),
                    (bestellijn.getAantalBesteld() - bestellijn.getAantalGeannuleerd())));
        }
        return new RetourBestelling(bestelling.getBestelId(), bestelling.getVoornaam(), bestelling.getFamilienaam(), retourArtikels);
    }

    @Transactional
    public List<Leveringslijn> vulMagazijnPlaatsen(long retourId, List<RetourArtikel> retourArtikelsLijnen) {
        List<Leveringslijn> artikelOverzicht = new ArrayList<>();
        for (var artikel : retourArtikelsLijnen) {
            var retourArtikel = artikelRepository.findAndLockById(artikel.artikelId()).orElseThrow();
            var artikelNaam = retourArtikel.getNaam();
            var artikelBeschrijving = retourArtikel.getBeschrijving();
            var maxMagazijnPlaatsen = retourArtikel.getMaxAantalInMagazijnPlaats();
            var magazijnplaatsen = magazijnPlaatsRepository.findMagazijnPlaatsenByArtikelId(artikel.artikelId());
            var aantal = artikel.aantal();
            artikelRepository.verhoogVoorraadMetAantal(artikel.artikelId(), aantal);
            var index = 0;
            while (aantal != 0) {
                var aantalVrijePlaatsen = maxMagazijnPlaatsen - magazijnplaatsen.get(index).getAantal();
                if (aantalVrijePlaatsen >= aantal) {
                    magazijnPlaatsRepository.verhoogAantalAndSetArtikelId(magazijnplaatsen.get(index).getMagazijnPlaatsId(), aantal, artikel.artikelId());
                    artikelOverzicht.add(new Leveringslijn(artikelNaam, artikelBeschrijving, aantal, magazijnplaatsen.get(index).getRij(),
                            magazijnplaatsen.get(index).getRek()));
                    break;
                } else {
                    if (aantalVrijePlaatsen != 0) {
                        magazijnPlaatsRepository.verhoogAantalAndSetArtikelId(magazijnplaatsen.get(index).getMagazijnPlaatsId(), aantalVrijePlaatsen, artikel.artikelId());
                        artikelOverzicht.add(new Leveringslijn(artikelNaam, artikelBeschrijving, aantalVrijePlaatsen, magazijnplaatsen.get(index).getRij(),
                                magazijnplaatsen.get(index).getRek()));
                        aantal -= aantalVrijePlaatsen;

                    }
                }
                index++;
                if (index > magazijnplaatsen.size() - 1) {
                    var legePlaats = magazijnPlaatsRepository.findLegeMagazijnPlaats().orElseThrow(GeenLegeMagazijnPlaatsException::new);
                    magazijnplaatsen.add(legePlaats);
                }
            }
        }
        artikelOverzicht.sort(Comparator.comparing(Leveringslijn::rij));
        return artikelOverzicht;
    }

}
