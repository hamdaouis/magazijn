package be.vdab.magazijn.controllers;

import be.vdab.magazijn.dto.TvBestelling;
import be.vdab.magazijn.services.BestellingService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.stream.Stream;

@RestController
@RequestMapping("TV")
public class TvController {
    private final BestellingService bestellingService;

    public TvController(BestellingService bestellingService) {
        this.bestellingService = bestellingService;
    }
    @GetMapping("aantal")
    int aantalBestellingen() {
        return bestellingService.aantalBestellingen();
    }
    @GetMapping
    Stream<TvBestelling> volgendeVijfBestellingen() {
        return bestellingService.vijfEerstvolgendeBestellingen();
    }
}
