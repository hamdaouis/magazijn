package be.vdab.magazijn.domain;

public class Bestellijn {
    private final long bestellijnId;
    private final long bestelId;
    private final long artikelId;
    private final int aantalBesteld;
    private final int aantalGeannuleerd;

    public Bestellijn(long bestellijnId, long bestelId, long artikelId, int aantalBesteld, int aantalGeannuleerd) {
        this.bestellijnId = bestellijnId;
        this.bestelId = bestelId;
        this.artikelId = artikelId;
        this.aantalBesteld = aantalBesteld;
        this.aantalGeannuleerd = aantalGeannuleerd;
    }

    public long getBestellijnId() {
        return bestellijnId;
    }

    public long getBestelId() {
        return bestelId;
    }

    public long getArtikelId() {
        return artikelId;
    }

    public int getAantalBesteld() {
        return aantalBesteld;
    }

    public int getAantalGeannuleerd() {
        return aantalGeannuleerd;
    }
}
