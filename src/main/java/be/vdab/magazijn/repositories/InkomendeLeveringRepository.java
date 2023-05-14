package be.vdab.magazijn.repositories;

import be.vdab.magazijn.dto.NieuwInkomendeLevering;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.time.LocalDate;


@Repository
public class InkomendeLeveringRepository {
    private final JdbcTemplate template;

    public InkomendeLeveringRepository(JdbcTemplate template) {
        this.template = template;
    }
    public long create(NieuwInkomendeLevering nieuwInkomendeLevering) {
        var sql = """
                  insert into InkomendeLeveringen (leveranciersId, leveringsbonNummer, leveringsbondatum, leverDatum, ontvangerPersoneelslidId)
                  values (?, ?, ?, ?, ?);
                """;
        var keyHolder = new GeneratedKeyHolder();
        template.update(connection -> {
            var statement = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            statement.setLong(1, nieuwInkomendeLevering.leveranciersId());
            statement.setString(2, nieuwInkomendeLevering.bonNummer());
            statement.setObject(3, nieuwInkomendeLevering.datum());
            statement.setObject(4, LocalDate.now());
            statement.setLong(5, 4);
            return statement;
        }, keyHolder);
        return keyHolder.getKey().longValue();
    }
    public void delete(long inkomendeLeveringsId) {
        var sql = """
                delete from InkomendeLeveringen
                where inkomendeLeveringsId = ?
                """;
        template.update(sql, inkomendeLeveringsId);
    }

}
