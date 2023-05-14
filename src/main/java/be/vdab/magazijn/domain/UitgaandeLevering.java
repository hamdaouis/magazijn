package be.vdab.magazijn.domain;

import java.time.LocalDate;

public class UitgaandeLevering {
    private final long uitgaandeLeveringsId;
    private final long bestelId;
    private final LocalDate vertrekDatum;
    private final LocalDate aankomstDatum;
    private final String trackingCode;
    private final long klantId;
    private final long uitgaandeLeveringsStatusId;

    public UitgaandeLevering(long uitgaandeLeveringsId, long bestelId, LocalDate vertrekDatum,
                             LocalDate aankomstDatum, String trackingCode, long klantId,
                             long uitgaandeLeveringsStatusId) {
        this.uitgaandeLeveringsId = uitgaandeLeveringsId;
        this.bestelId = bestelId;
        this.vertrekDatum = vertrekDatum;
        this.aankomstDatum = aankomstDatum;
        this.trackingCode = trackingCode;
        this.klantId = klantId;
        this.uitgaandeLeveringsStatusId = uitgaandeLeveringsStatusId;
    }

    public long getUitgaandeLeveringsId() {
        return uitgaandeLeveringsId;
    }

    public long getBestelId() {
        return bestelId;
    }

    public LocalDate getVertrekDatum() {
        return vertrekDatum;
    }

    public LocalDate getAankomstDatum() {
        return aankomstDatum;
    }

    public String getTrackingCode() {
        return trackingCode;
    }

    public long getKlantId() {
        return klantId;
    }

    public long getUitgaandeLeveringsStatusId() {
        return uitgaandeLeveringsStatusId;
    }
}
