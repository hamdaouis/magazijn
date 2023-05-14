package be.vdab.magazijn.domain;

import java.util.Objects;

public class MagazijnPlaats {
    private final long magazijnPlaatsId;
    private final long artikelId;
    private final char rij;
    private final int rek;
    private final int aantal;

    public MagazijnPlaats(long magazijnPlaatsId, long artikelId, char rij, int rek, int aantal) {
        this.magazijnPlaatsId = magazijnPlaatsId;
        this.artikelId = artikelId;
        this.rij = rij;
        this.rek = rek;
        this.aantal = aantal;
    }

    public long getMagazijnPlaatsId() {
        return magazijnPlaatsId;
    }

    public long getArtikelId() {
        return artikelId;
    }

    public char getRij() {
        return rij;
    }

    public int getRek() {
        return rek;
    }

    public int getAantal() {
        return aantal;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof MagazijnPlaats that)) return false;
        return rij == that.rij && rek == that.rek;
    }

    @Override
    public int hashCode() {
        return Objects.hash(rij, rek);
    }
}
