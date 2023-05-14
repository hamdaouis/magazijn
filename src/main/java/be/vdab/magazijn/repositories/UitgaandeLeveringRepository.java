package be.vdab.magazijn.repositories;

import be.vdab.magazijn.dto.UitgaandeLeveringBestelIdKlantdId;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.time.LocalDate;

@Repository
public class UitgaandeLeveringRepository {
    private final JdbcTemplate template;

    public UitgaandeLeveringRepository(JdbcTemplate template) {
        this.template = template;
    }

    public long create(UitgaandeLeveringBestelIdKlantdId uitgaandeLeveringBestelIdKlantdId) {
        var sql = """
                insert into uitgaandeleveringen(bestelId, vertrekDatum, klantId, uitgaandeLeveringsStatusId)
                values(?,?,?,?);
                """;
        var keyHolder = new GeneratedKeyHolder();
        template.update(connection -> {
            var statement = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            statement.setLong(1, uitgaandeLeveringBestelIdKlantdId.bestelId());
            statement.setObject(2, LocalDate.now());
            statement.setLong(3, uitgaandeLeveringBestelIdKlantdId.klantId());
            statement.setLong(4, 1);
            return statement;
        }, keyHolder);
        return keyHolder.getKey().longValue();
    }

    public void changeLeveringStatus(long bestelId, int statusId) {
        var sql = """
                update uitgaandeleveringen
                set uitgaandeLeveringsStatusId = ?
                where bestelId = ?
                """;
        template.update(sql, statusId, bestelId);
    }
}
