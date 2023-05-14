package be.vdab.magazijn.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.NOT_FOUND)
public class ArtikelNietGevondenException extends RuntimeException {
    public ArtikelNietGevondenException(long id) {
        super("Artikel niet gevonden. ID: " + id);
    }
}
