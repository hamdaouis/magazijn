package be.vdab.magazijn.repositories;

import be.vdab.magazijn.domain.InkomendeLeveringsLijn;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class InkomendeLeveringsLijnRepository {
    private final JdbcTemplate template;

    public InkomendeLeveringsLijnRepository(JdbcTemplate template) {
        this.template = template;
    }

    public void create(InkomendeLeveringsLijn inkomendeLeveringsLijn) {
        var sql = """
                insert into InkomendeLeveringslijnen(inkomendeLeveringsId, artikelId, aantalGoedgekeurd, aantalTeruggestuurd, magazijnPlaatsId)
                values(?, ?, ?, ?, ?)
                """;
        template.update(sql, inkomendeLeveringsLijn.getInkomendeLeveringsId(), inkomendeLeveringsLijn.getArtikelId(), inkomendeLeveringsLijn.getAantalGoedgekeurd(),
                inkomendeLeveringsLijn.getAantalTeruggestuurd(), inkomendeLeveringsLijn.getMagazijnPlaatsId());
    }

    public void delete(long inkomendeLeveringsId) {
        var sql = """
                delete from InkomendeLeveringsLijnen
                where inkomendeLeveringsId = ?
                """;
        template.update(sql, inkomendeLeveringsId);
    }
    public List<Map<Integer, Long>> findAantalAndMagazijnPlaatsIdById(long inkomendeLeveringsId){
        System.out.println("inkomendeLeveringsId: " + inkomendeLeveringsId);
        var sql = """
            select aantalGoedgekeurd, magazijnPlaatsId
            from InkomendeLeveringsLijnen
            where inkomendeLeveringsId = ?
            """;
        return new ArrayList<>(template.query(sql, (result, rowNum) -> {
            Map<Integer, Long> map = new HashMap<>();
            map.put(result.getInt("aantalGoedgekeurd"), result.getLong("magazijnPlaatsId"));
            return map;
        }, inkomendeLeveringsId));
    }
}
