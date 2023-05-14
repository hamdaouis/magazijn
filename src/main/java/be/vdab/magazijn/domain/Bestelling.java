package be.vdab.magazijn.domain;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Bestelling {
    private final long bestelId;
    private final LocalDateTime besteldatum;
    private final long klantId;
    private final boolean betaald;
    private final String betalingscode;
    private final long betaalwijzeId;
    private final boolean annulatie;
    private final LocalDate annulatiedatum;
    private final String terugbetalingscode;
    private final long bestellingsStatusId;
    private final boolean actiecodeGebruikt;
    private final String bedrijfsnaam;
    private final String btwNummer;
    private final String voornaam;
    private final String familienaam;
    private final long facturatieAdresId;
    private final long leveringsAdresId;

    public Bestelling(long bestelId, LocalDateTime besteldatum, long klantId, boolean betaald, String betalingscode,
                      long betaalwijzeId, boolean annulatie, LocalDate annulatiedatum, String terugbetalingscode,
                      long bestellingsStatusId, boolean actiecodeGebruikt, String bedrijfsnaam, String btwNummer,
                      String voornaam, String familienaam, long facturatieAdresId, long leveringsAdresId) {
        this.bestelId = bestelId;
        this.besteldatum = besteldatum;
        this.klantId = klantId;
        this.betaald = betaald;
        this.betalingscode = betalingscode;
        this.betaalwijzeId = betaalwijzeId;
        this.annulatie = annulatie;
        this.annulatiedatum = annulatiedatum;
        this.terugbetalingscode = terugbetalingscode;
        this.bestellingsStatusId = bestellingsStatusId;
        this.actiecodeGebruikt = actiecodeGebruikt;
        this.bedrijfsnaam = bedrijfsnaam;
        this.btwNummer = btwNummer;
        this.voornaam = voornaam;
        this.familienaam = familienaam;
        this.facturatieAdresId = facturatieAdresId;
        this.leveringsAdresId = leveringsAdresId;
    }

    public long getBestelId() {
        return bestelId;
    }

    public LocalDateTime getBesteldatum() {
        return besteldatum;
    }

    public long getKlantId() {
        return klantId;
    }

    public boolean isBetaald() {
        return betaald;
    }

    public String getBetalingscode() {
        return betalingscode;
    }

    public long getBetaalwijzeId() {
        return betaalwijzeId;
    }

    public boolean isAnnulatie() {
        return annulatie;
    }

    public LocalDate getAnnulatiedatum() {
        return annulatiedatum;
    }

    public String getTerugbetalingscode() {
        return terugbetalingscode;
    }

    public long getBestellingsStatusId() {
        return bestellingsStatusId;
    }

    public boolean isActiecodeGebruikt() {
        return actiecodeGebruikt;
    }

    public String getBedrijfsnaam() {
        return bedrijfsnaam;
    }

    public String getBtwNummer() {
        return btwNummer;
    }

    public String getVoornaam() {
        return voornaam;
    }

    public String getFamilienaam() {
        return familienaam;
    }

    public long getFacturatieAdresId() {
        return facturatieAdresId;
    }

    public long getLeveringsAdresId() {
        return leveringsAdresId;
    }
}
