package be.vdab.magazijn.services;

import be.vdab.magazijn.domain.Bestellijn;
import be.vdab.magazijn.repositories.BestellijnRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(readOnly = true)
public class BestellijnService {
    private final BestellijnRepository bestellijnRepository;

    public BestellijnService(BestellijnRepository bestellijnRepository) {
        this.bestellijnRepository = bestellijnRepository;
    }

    public List<Bestellijn> findByBestelId(long bestelId){
        return bestellijnRepository.findBestellijnenByBestelId(bestelId);
    }
}
