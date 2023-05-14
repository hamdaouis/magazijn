package be.vdab.magazijn.domain;

import java.math.BigDecimal;

public class Artikel {
    private final long artikelId;
    private final String ean;
    private final String naam;
    private final String beschrijving;
    private final BigDecimal prijs;
    private final int gewichtInGram;
    private final int bestelpeil;
    private final int voorraad;
    private final int minimumVoorraad;
    private final int maximumVoorraad;
    private final int levertijd;
    private final int aantalBesteldLeverancier;
    private final int maxAantalInMagazijnPlaats;
    private final long leveranciersId;

    public Artikel(long artikelId, String ean, String naam, String beschrijving, BigDecimal prijs,
                   int gewichtInGram, int bestelpeil, int voorraad, int minimumVoorraad,
                   int maximumVoorraad, int levertijd, int aantalBesteldLeverancier,
                   int maxAantalInMagazijnPlaats, long leveranciersId) {
        this.artikelId = artikelId;
        this.ean = ean;
        this.naam = naam;
        this.beschrijving = beschrijving;
        this.prijs = prijs;
        this.gewichtInGram = gewichtInGram;
        this.bestelpeil = bestelpeil;
        this.voorraad = voorraad;
        this.minimumVoorraad = minimumVoorraad;
        this.maximumVoorraad = maximumVoorraad;
        this.levertijd = levertijd;
        this.aantalBesteldLeverancier = aantalBesteldLeverancier;
        this.maxAantalInMagazijnPlaats = maxAantalInMagazijnPlaats;
        this.leveranciersId = leveranciersId;
    }

    public long getArtikelId() {
        return artikelId;
    }

    public String getEan() {
        return ean;
    }

    public String getNaam() {
        return naam;
    }

    public String getBeschrijving() {
        return beschrijving;
    }

    public BigDecimal getPrijs() {
        return prijs;
    }

    public int getGewichtInGram() {
        return gewichtInGram;
    }

    public int getBestelpeil() {
        return bestelpeil;
    }

    public int getVoorraad() {
        return voorraad;
    }

    public int getMinimumVoorraad() {
        return minimumVoorraad;
    }

    public int getMaximumVoorraad() {
        return maximumVoorraad;
    }

    public int getLevertijd() {
        return levertijd;
    }

    public int getAantalBesteldLeverancier() {
        return aantalBesteldLeverancier;
    }

    public int getMaxAantalInMagazijnPlaats() {
        return maxAantalInMagazijnPlaats;
    }

    public long getLeveranciersId() {
        return leveranciersId;
    }
}
