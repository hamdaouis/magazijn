package be.vdab.magazijn.services;

import be.vdab.magazijn.domain.Artikel;
import be.vdab.magazijn.dto.ArtikelBeknopt;
import be.vdab.magazijn.repositories.ArtikelRepository;
import be.vdab.magazijn.repositories.BestellijnRepository;
import be.vdab.magazijn.repositories.MagazijnPlaatsRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional(readOnly = true)
public class ArtikelService {
    private final ArtikelRepository artikelRepository;
    private final MagazijnPlaatsRepository magazijnPlaatsRepository;
    private final BestellijnRepository bestellijnRepository;

    public ArtikelService(ArtikelRepository artikelRepository, MagazijnPlaatsRepository magazijnPlaatsRepository, BestellijnRepository bestellijnRepository) {
        this.artikelRepository = artikelRepository;
        this.magazijnPlaatsRepository = magazijnPlaatsRepository;
        this.bestellijnRepository = bestellijnRepository;
    }

    public Optional<Artikel> findById(long id) {
        return artikelRepository.findById(id);
    }
    public List<ArtikelBeknopt> findByEANBevat(String ean){
        return artikelRepository.findByEANBevat(ean);
    }
}
