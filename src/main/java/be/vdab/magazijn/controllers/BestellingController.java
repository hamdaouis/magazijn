package be.vdab.magazijn.controllers;

import be.vdab.magazijn.domain.Bestelling;
import be.vdab.magazijn.dto.BestellijnArtikel;
import be.vdab.magazijn.dto.UitgaandeLeveringBestelIdKlantdId;
import be.vdab.magazijn.exceptions.BestellingNietGevondenException;
import be.vdab.magazijn.services.ArtikelService;
import be.vdab.magazijn.services.BestellijnService;
import be.vdab.magazijn.services.BestellingService;
import be.vdab.magazijn.services.UitgaandeLeveringenService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.stream.Stream;

@RestController
@RequestMapping("bestelling")
public class BestellingController {
    private final BestellingService bestellingService;
    private final BestellijnService bestellijnService;
    private final ArtikelService artikelService;
    private final UitgaandeLeveringenService uitgaandeLeveringenService;

    public BestellingController(BestellingService bestellingService, BestellijnService bestellijnService, ArtikelService artikelService, UitgaandeLeveringenService uitgaandeLeveringenService) {
        this.bestellingService = bestellingService;
        this.bestellijnService = bestellijnService;
        this.artikelService = artikelService;
        this.uitgaandeLeveringenService = uitgaandeLeveringenService;
    }

    @GetMapping("{id}")
    Bestelling findById(@PathVariable long id) {
        return bestellingService.findById(id).orElseThrow(BestellingNietGevondenException::new);
    }

    @GetMapping("{id}/bestellijn")
    Stream<BestellijnArtikel> findBestellijnArtikelenByBestelId(@PathVariable long id) {
        return bestellingService.findBestellijnArtikelenByBestelId(id);
    }

    @GetMapping
    long findEerstvolgendeBestelId() {
        return bestellingService.findEerstvolgendeBestelId();
    }

    @PostMapping("uitgaand")
    long create(@RequestBody @Valid UitgaandeLeveringBestelIdKlantdId uitgaandeLeveringBestelIdKlantdId) {
        return uitgaandeLeveringenService.create(uitgaandeLeveringBestelIdKlantdId);
    }

    @PostMapping("verwerk/{bestelId}")
    void verwerkBestelling(@PathVariable long bestelId) {
        bestellingService.verwerkBestelling(bestelId);
    }


}
