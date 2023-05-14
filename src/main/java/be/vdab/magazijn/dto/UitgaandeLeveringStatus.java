package be.vdab.magazijn.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;

public record UitgaandeLeveringStatus(@PositiveOrZero @NotNull int statusId) {
}
