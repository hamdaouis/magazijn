package be.vdab.magazijn.dto;

import be.vdab.magazijn.domain.MagazijnPlaats;

public record RetourArtikelMetMagazijnPlaatsen(String beschrijving, MagazijnPlaats magazijnPlaats,int aantalOmTePlaatsen) {
}
