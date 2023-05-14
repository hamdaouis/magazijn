package be.vdab.magazijn.dto;

import java.util.List;

public record BestellijnArtikel(long artikelId, String naam, int aantal, List<MagazijnPlaatsMetAantalOpTeHalen> magazijnplaatsen) {
    public BestellijnArtikel(BestellijnArtikelBeknopt bestellijnArtikelBeknopt, List<MagazijnPlaatsMetAantalOpTeHalen> magazijnplaatsen) {
        this(bestellijnArtikelBeknopt.artikelId(), bestellijnArtikelBeknopt.naam(), bestellijnArtikelBeknopt.aantal(), magazijnplaatsen);
    }
}
