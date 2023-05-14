package be.vdab.magazijn.controllers;

import be.vdab.magazijn.domain.Artikel;
import be.vdab.magazijn.dto.ArtikelBeknopt;
import be.vdab.magazijn.exceptions.ArtikelNietGevondenException;
import be.vdab.magazijn.services.ArtikelService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("artikels")
public class ArtikelController {
    private final ArtikelService artikelService;

    public ArtikelController(ArtikelService artikelService) {
        this.artikelService = artikelService;
    }

    @GetMapping("{id}")
    Artikel findById(@PathVariable long id) {
        return artikelService.findById(id).orElseThrow(() -> new ArtikelNietGevondenException(id));
    }
    @GetMapping(params = "eanBevat")
    List<ArtikelBeknopt> findByEANBevat(String eanBevat){
        return artikelService.findByEANBevat(eanBevat);
    }

}
