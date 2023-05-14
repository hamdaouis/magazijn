package be.vdab.magazijn.dto;

import be.vdab.magazijn.domain.MagazijnPlaats;

public record MagazijnPlaatsMetAantalOpTeHalen(char rij, int rek, int aantal, int aantalOpTeHalen) {
    public MagazijnPlaatsMetAantalOpTeHalen(MagazijnPlaats magazijnPlaats, int aantalOpTeHalen) {
        this(magazijnPlaats.getRij(), magazijnPlaats.getRek(), magazijnPlaats.getAantal(), aantalOpTeHalen);
    }
}
