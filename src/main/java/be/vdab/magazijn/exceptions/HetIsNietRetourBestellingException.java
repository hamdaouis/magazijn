package be.vdab.magazijn.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.CONFLICT)
public class HetIsNietRetourBestellingException extends RuntimeException{
}
