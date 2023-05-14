package be.vdab.magazijn.controllers;

import be.vdab.magazijn.domain.InkomendeLeveringsLijn;
import be.vdab.magazijn.dto.Leveringslijn;
import be.vdab.magazijn.dto.NieuwInkomendeLevering;
import be.vdab.magazijn.dto.UitgaandeLeveringStatus;
import be.vdab.magazijn.services.LeveringService;
import be.vdab.magazijn.services.UitgaandeLeveringenService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("leveringen")
public class LeveringController {
    private final LeveringService leveringService;
    private final UitgaandeLeveringenService uitgaandeLeveringenService;

    public LeveringController(LeveringService leveringService, UitgaandeLeveringenService uitgaandeLeveringenService) {
        this.leveringService = leveringService;
        this.uitgaandeLeveringenService = uitgaandeLeveringenService;
    }
    @PostMapping
    long create(@RequestBody @Valid NieuwInkomendeLevering nieuwInkomendeLevering) {
        return leveringService.create(nieuwInkomendeLevering);
    }
    @PostMapping("/{inkomendeLeveringsId}/leveringslijnen")
    List<Leveringslijn> nieuweLeveringsLijnen(@PathVariable long inkomendeLeveringsId, @RequestBody List<InkomendeLeveringsLijn> inkomendeLeveringsLijnen) {
        return leveringService.createLeveringslijnenEnVulMagazijnPlaatsen(inkomendeLeveringsId, inkomendeLeveringsLijnen);
    }
    @DeleteMapping("/{inkomendeLeveringsId}")
    void delete(@PathVariable long inkomendeLeveringsId){
        leveringService.delete(inkomendeLeveringsId);
    }

    @PatchMapping({"uitgaandeLeveringen/{id}"})
    void changeLeveringStatus(@PathVariable long id, @RequestBody @Valid UitgaandeLeveringStatus statusId) {
        uitgaandeLeveringenService.changeLeveringStatus(id, statusId.statusId());
    }
}
