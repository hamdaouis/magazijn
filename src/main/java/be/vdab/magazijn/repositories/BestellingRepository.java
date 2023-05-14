package be.vdab.magazijn.repositories;

import be.vdab.magazijn.domain.Bestelling;
import org.springframework.dao.IncorrectResultSizeDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public class BestellingRepository {
    private final JdbcTemplate template;

    public BestellingRepository(JdbcTemplate template) {
        this.template = template;
    }

    private final RowMapper<Bestelling> bestellingMapper = (result, rownum) ->
            new Bestelling(result.getLong("bestelId"), result.getObject("besteldatum", LocalDateTime.class),
                    result.getLong("klantId"), result.getBoolean("betaald"), result.getString("betalingscode"),
                    result.getLong("betaalwijzeId"), result.getBoolean("annulatie"), result.getObject("annulatiedatum", LocalDate.class),
                    result.getString("terugbetalingscode"), result.getLong("bestellingsStatusId"),
                    result.getBoolean("actiecodeGebruikt"), result.getString("bedrijfsnaam"),
                    result.getString("btwNummer"), result.getString("voornaam"), result.getString("familienaam"),
                    result.getLong("facturatieAdresId"), result.getLong("leveringsAdresId"));

    public List<Bestelling> findAll() {
        var sql = """
                select bestelId,besteldatum,klantId,
                betaald,betalingscode,betaalwijzeId,annulatie,annulatiedatum,terugbetalingscode,bestellingsStatusId,actiecodeGebruikt,bedrijfsnaam,btwNummer,
                voornaam,familienaam,facturatieAdresId,leveringsAdresId
                from bestellingen
                where bestellingsStatusId = 2
                order by besteldatum
                """;
        return template.query(sql, bestellingMapper);
    }

    public Optional<Bestelling> findById(long id) {
        try {
            var sql = """
                    select bestelId,besteldatum,klantId,
                    betaald,betalingscode,betaalwijzeId,annulatie,annulatiedatum,terugbetalingscode,bestellingsStatusId,actiecodeGebruikt,bedrijfsnaam,btwNummer,
                    voornaam,familienaam,facturatieAdresId,leveringsAdresId
                    from bestellingen
                    where bestelId = ?
                    """;
            return Optional.of(template.queryForObject(sql, bestellingMapper, id));
        } catch (IncorrectResultSizeDataAccessException ex) {
            return Optional.empty();
        }

    }

    public Optional<Bestelling> findByIdRetourBestelling(long id) {
        try {
            var sql = """
                    select bestelId,besteldatum,klantId,
                    betaald,betalingscode,betaalwijzeId,annulatie,annulatiedatum,terugbetalingscode,bestellingsStatusId,actiecodeGebruikt,bedrijfsnaam,btwNummer,
                    voornaam,familienaam,facturatieAdresId,leveringsAdresId
                    from bestellingen
                    where bestelId = ?
                    """;
            return Optional.of(template.queryForObject(sql, bestellingMapper, id));
        } catch (IncorrectResultSizeDataAccessException ex) {
            return Optional.empty();
        }

    }

    //Het is voor tv-scherm
    public List<Bestelling> findVolgendeVijfBestellingen() {
        var sql = """
                select bestelId,besteldatum,klantId,
                betaald,betalingscode,betaalwijzeId,annulatie,annulatiedatum,terugbetalingscode,bestellingsStatusId,actiecodeGebruikt,bedrijfsnaam,btwNummer,
                voornaam,familienaam,facturatieAdresId,leveringsAdresId
                from Bestellingen
                where bestellingsStatusId = 2
                order by besteldatum,bestelId
                limit 5;
                """;
        return template.query(sql, bestellingMapper);
    }

    public int findAantalBestellingen() {
        var sql = """
                select count(*)
                from Bestellingen
                where Bestellingen.bestellingsStatusId = 2
                """;
        return template.queryForObject(sql, Integer.class);
    }

    public Optional<Long> findEerstvolgendeBestelId() {
        try {
            var sql = """
                    select bestelId
                    from Bestellingen
                    where bestellingsStatusId = 2
                    order by besteldatum, bestelId
                    limit 1
                    """;
            return Optional.of(template.queryForObject(sql, Long.class));
        } catch (IncorrectResultSizeDataAccessException ex) {
            return Optional.empty();
        }
    }

    public long getKlantIdByBestelId(long bestelId) {
        var sql = """
                select klantId
                from Bestellingen
                where bestelId = ?
                """;
        return template.queryForObject(sql, long.class, bestelId);
    }
}