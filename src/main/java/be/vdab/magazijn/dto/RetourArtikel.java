package be.vdab.magazijn.dto;

public record RetourArtikel(long artikelId, String ean, String beschrijving, int aantal) {
}
