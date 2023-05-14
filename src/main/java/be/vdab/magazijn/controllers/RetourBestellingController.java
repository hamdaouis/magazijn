package be.vdab.magazijn.controllers;

import be.vdab.magazijn.dto.Leveringslijn;
import be.vdab.magazijn.dto.RetourArtikelMetMagazijnPlaatsen;
import be.vdab.magazijn.dto.RetourBestelling;
import be.vdab.magazijn.services.BestellingService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("retours")
public class RetourBestellingController {
    private final BestellingService bestellingService;


    public RetourBestellingController(BestellingService bestellingService) {
        this.bestellingService = bestellingService;

    }

    @GetMapping("{bestelId}")
    RetourBestelling findRetourBestellingById(@PathVariable long bestelId) {
        return bestellingService.findRetourBestellingById(bestelId);
    }

    @PatchMapping("{id}/artikellijst")
    List<Leveringslijn> plaatsenGetourneerdeArtikelen(@PathVariable long id, @RequestBody @Valid RetourBestelling retourBestelling) {
        return bestellingService.vulMagazijnPlaatsen(id, retourBestelling.artikels());
    }
}
