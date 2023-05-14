package be.vdab.magazijn.domain;

import java.time.LocalDateTime;

public class InkomendeLevering {
    private final long inkomendeLeveringsId;
    private final long leveranciersId;
    private final String LeveringsbonNummer;
    private final LocalDateTime Leveringsbondatum;
    private final LocalDateTime leverdatum;
    private final long ontvangerPersoneelslidId;

    public InkomendeLevering(long inkomendeLeveringsId, long leveranciersId, String leveringsbonNummer,
                             LocalDateTime leveringsbondatum, LocalDateTime leverdatum,
                             long ontvangerPersoneelslidId) {
        this.inkomendeLeveringsId = inkomendeLeveringsId;
        this.leveranciersId = leveranciersId;
        LeveringsbonNummer = leveringsbonNummer;
        Leveringsbondatum = leveringsbondatum;
        this.leverdatum = leverdatum;
        this.ontvangerPersoneelslidId = ontvangerPersoneelslidId;
    }

    public long getInkomendeLeveringsId() {
        return inkomendeLeveringsId;
    }

    public long getLeveranciersId() {
        return leveranciersId;
    }

    public String getLeveringsbonNummer() {
        return LeveringsbonNummer;
    }

    public LocalDateTime getLeveringsbondatum() {
        return Leveringsbondatum;
    }

    public LocalDateTime getLeverdatum() {
        return leverdatum;
    }

    public long getOntvangerPersoneelslidId() {
        return ontvangerPersoneelslidId;
    }
}
