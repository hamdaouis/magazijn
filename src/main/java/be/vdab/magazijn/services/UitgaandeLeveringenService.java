package be.vdab.magazijn.services;

import be.vdab.magazijn.dto.UitgaandeLeveringBestelIdKlantdId;
import be.vdab.magazijn.repositories.UitgaandeLeveringRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class UitgaandeLeveringenService {
    private final UitgaandeLeveringRepository uitgaandeLeveringenRepository;

    public UitgaandeLeveringenService(UitgaandeLeveringRepository uitgaandeLeveringenRepository) {
        this.uitgaandeLeveringenRepository = uitgaandeLeveringenRepository;
    }

    @Transactional
    public long create(UitgaandeLeveringBestelIdKlantdId uitgaandeLeveringBestelIdKlantdId) {
        return uitgaandeLeveringenRepository.create(uitgaandeLeveringBestelIdKlantdId);
    }

    @Transactional
    public void changeLeveringStatus(long bestelId, int statusId) {
        uitgaandeLeveringenRepository.changeLeveringStatus(bestelId, statusId);
    }
}
