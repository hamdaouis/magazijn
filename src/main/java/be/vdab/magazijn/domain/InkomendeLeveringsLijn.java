package be.vdab.magazijn.domain;

public class InkomendeLeveringsLijn {
    private final long inkomendeLeveringsId;
    private final long artikelId;
    private final int aantalGoedgekeurd;
    private final int aantalTeruggestuurd;
    private final long magazijnPlaatsId;

    public InkomendeLeveringsLijn(long inkomendeLeveringsId, long artikelId, int aantalGoedgekeurd,
                                  int aantalTeruggestuurd, long magazijnPlaatsId) {
        this.inkomendeLeveringsId = inkomendeLeveringsId;
        this.artikelId = artikelId;
        this.aantalGoedgekeurd = aantalGoedgekeurd;
        this.aantalTeruggestuurd = aantalTeruggestuurd;
        this.magazijnPlaatsId = magazijnPlaatsId;
    }

    public long getInkomendeLeveringsId() {
        return inkomendeLeveringsId;
    }

    public long getArtikelId() {
        return artikelId;
    }

    public int getAantalGoedgekeurd() {
        return aantalGoedgekeurd;
    }

    public int getAantalTeruggestuurd() {
        return aantalTeruggestuurd;
    }

    public long getMagazijnPlaatsId() {
        return magazijnPlaatsId;
    }

}
