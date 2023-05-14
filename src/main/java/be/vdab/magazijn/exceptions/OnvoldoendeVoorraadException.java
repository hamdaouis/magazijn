package be.vdab.magazijn.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

import java.io.Serial;
import java.util.List;
import java.util.stream.Collectors;

@ResponseStatus(HttpStatus.CONFLICT)
public class OnvoldoendeVoorraadException extends RuntimeException{
    @Serial
    private static final long serialVersionUID = 1L;

    public OnvoldoendeVoorraadException(long id) {
        super("Onvoldoende voorraad. ArtikelId: " + id);
    }

    public OnvoldoendeVoorraadException(List<Long> artikelIds) {
        super("Onvoldoende voorraad. ArtikelId:  " + artikelIds.stream().map(aLong -> aLong.toString()).collect(Collectors.joining(", ")));
    }
}
