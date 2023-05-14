package be.vdab.magazijn.repositories;

import be.vdab.magazijn.dto.LeverancierBeknopt;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class LeverancierRepository {
    private final JdbcTemplate template;

    public LeverancierRepository(JdbcTemplate template) {
        this.template = template;
    }

    public List<LeverancierBeknopt> findNamenByNaamBevat(String woord) {
        var sql = """
                select leveranciersId, naam
                from Leveranciers
                where naam like ?
                order by naam
                """;
        return template.query(sql, (result, rowNum) -> new LeverancierBeknopt(result.getLong("leveranciersId"), result.getString("naam")), "%" + woord + "%");
    }
}
