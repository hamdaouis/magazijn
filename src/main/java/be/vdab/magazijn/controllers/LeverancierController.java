package be.vdab.magazijn.controllers;

import be.vdab.magazijn.dto.LeverancierBeknopt;
import be.vdab.magazijn.services.LeveringService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("leveranciers")
public class LeverancierController {
    private final LeveringService leveringService;

    public LeverancierController(LeveringService leveringService) {
        this.leveringService = leveringService;
    }

    @GetMapping(params = "naamBevat")
    List<LeverancierBeknopt> findNamenByNaamBevat(String naamBevat){
        return leveringService.findNaamByNaamBevat(naamBevat);
    }
}
