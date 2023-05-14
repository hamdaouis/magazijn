package be.vdab.magazijn.dto;

import java.util.List;

public record RetourBestelling(long bestelId,String voornaam, String familienaam, List<RetourArtikel> artikels) {
}
