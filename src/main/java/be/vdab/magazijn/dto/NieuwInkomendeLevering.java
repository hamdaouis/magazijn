package be.vdab.magazijn.dto;

import java.time.LocalDate;

public record NieuwInkomendeLevering(long leveranciersId, String bonNummer, LocalDate datum) {
}
