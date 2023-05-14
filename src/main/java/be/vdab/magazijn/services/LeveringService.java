package be.vdab.magazijn.services;

import be.vdab.magazijn.domain.InkomendeLeveringsLijn;
import be.vdab.magazijn.dto.LeverancierBeknopt;
import be.vdab.magazijn.dto.Leveringslijn;
import be.vdab.magazijn.dto.NieuwInkomendeLevering;
import be.vdab.magazijn.exceptions.GeenLegeMagazijnPlaatsException;
import be.vdab.magazijn.repositories.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

@Service
@Transactional(readOnly = true)
public class LeveringService {
    private final InkomendeLeveringRepository inkomendeLeveringRepository;
    private final MagazijnPlaatsRepository magazijnPlaatsRepository;
    private final InkomendeLeveringsLijnRepository inkomendeLeveringsLijnRepository;
    private final ArtikelRepository artikelRepository;
    private final LeverancierRepository leverancierRepository;

    public LeveringService(InkomendeLeveringRepository inkomendeLeveringRepository, MagazijnPlaatsRepository magazijnPlaatsRepository,
                           InkomendeLeveringsLijnRepository inkomendeLeveringsLijnRepository, ArtikelRepository artikelRepository, LeverancierRepository leverancierRepository) {
        this.inkomendeLeveringRepository = inkomendeLeveringRepository;
        this.magazijnPlaatsRepository = magazijnPlaatsRepository;
        this.inkomendeLeveringsLijnRepository = inkomendeLeveringsLijnRepository;
        this.artikelRepository = artikelRepository;
        this.leverancierRepository = leverancierRepository;
    }

    public List<LeverancierBeknopt> findNaamByNaamBevat(String woord) {
        return leverancierRepository.findNamenByNaamBevat(woord);
    }

    @Transactional
    public long create(NieuwInkomendeLevering nieuwInkomendeLevering) {
        return inkomendeLeveringRepository.create(nieuwInkomendeLevering);
    }

    @Transactional
    public List<Leveringslijn> createLeveringslijnenEnVulMagazijnPlaatsen(long inkomendeLeveringsId, List<InkomendeLeveringsLijn> inkomendeLeveringsLijnen) {
        List<InkomendeLeveringsLijn> leveringsLijnen = new ArrayList<>();
        List<Leveringslijn> artikelOverzicht = new ArrayList<>();
        for (var inkomendeLeveringsLijn : inkomendeLeveringsLijnen) {
            var leveringslijnArtikel = artikelRepository.findLeveringslijnGegevensById(inkomendeLeveringsLijn.getArtikelId());
            var artikelNaam = leveringslijnArtikel.naam();
            var artikelBeschrijving = leveringslijnArtikel.beschrijving();
            var maxMagazijnPlaatsen = leveringslijnArtikel.maxAantalInMagazijnPlaats();
            var magazijnplaatsen = magazijnPlaatsRepository.findMagazijnPlaatsenByArtikelId(inkomendeLeveringsLijn.getArtikelId());
            var aantal = inkomendeLeveringsLijn.getAantalGoedgekeurd();
            artikelRepository.verhoogVoorraadMetAantal(inkomendeLeveringsLijn.getArtikelId(), aantal);
            var index = 0;
            while (aantal != 0) {
                var aantalVrijePlaatsen = maxMagazijnPlaatsen - magazijnplaatsen.get(index).getAantal();
                if (aantalVrijePlaatsen >= aantal) {
                    magazijnPlaatsRepository.verhoogAantalAndSetArtikelId(magazijnplaatsen.get(index).getMagazijnPlaatsId(), aantal, inkomendeLeveringsLijn.getArtikelId());
                    leveringsLijnen.add(new InkomendeLeveringsLijn(inkomendeLeveringsId, inkomendeLeveringsLijn.getArtikelId(), aantal,
                            inkomendeLeveringsLijn.getAantalTeruggestuurd(), magazijnplaatsen.get(index).getMagazijnPlaatsId()));
                    artikelOverzicht.add(new Leveringslijn(artikelNaam, artikelBeschrijving, aantal, magazijnplaatsen.get(index).getRij(),
                            magazijnplaatsen.get(index).getRek()));
                    break;
                } else {
                    if (aantalVrijePlaatsen != 0) {
                        magazijnPlaatsRepository.verhoogAantalAndSetArtikelId(magazijnplaatsen.get(index).getMagazijnPlaatsId(), aantalVrijePlaatsen, inkomendeLeveringsLijn.getArtikelId());
                        leveringsLijnen.add(new InkomendeLeveringsLijn(inkomendeLeveringsId, inkomendeLeveringsLijn.getArtikelId(), aantalVrijePlaatsen,
                                0, magazijnplaatsen.get(index).getMagazijnPlaatsId()));
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
        leveringsLijnen.forEach(inkomendeLeveringsLijnRepository::create);
        artikelOverzicht.sort(Comparator.comparing(Leveringslijn::rij));
        return artikelOverzicht;
    }

    @Transactional
    public void delete(long inkomendeLeveringsId) {
        var lijst = inkomendeLeveringsLijnRepository.findAantalAndMagazijnPlaatsIdById(inkomendeLeveringsId);
        for (Map<Integer, Long> map : lijst) {
            int aantal = map.keySet().iterator().next();
            long magazijnPlaatsId = map.get(aantal);
            magazijnPlaatsRepository.deleteMagazijnplaatsenByInkomendeLeveranciersId(magazijnPlaatsId, aantal);
        }
        inkomendeLeveringsLijnRepository.delete(inkomendeLeveringsId);
        inkomendeLeveringRepository.delete(inkomendeLeveringsId);
    }
}
