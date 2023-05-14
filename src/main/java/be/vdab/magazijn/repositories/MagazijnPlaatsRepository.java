package be.vdab.magazijn.repositories;

import be.vdab.magazijn.domain.MagazijnPlaats;
import org.springframework.dao.IncorrectResultSizeDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class MagazijnPlaatsRepository {
    private final JdbcTemplate template;

    public MagazijnPlaatsRepository(JdbcTemplate template) {
        this.template = template;
    }

    private final RowMapper<MagazijnPlaats> magazijnPlaatsMapper = (result, rownum) ->
            new MagazijnPlaats(result.getLong("magazijnPlaatsId"), result.getLong("artikelId"), result.getString("rij").charAt(0), result.getInt("rek"), result.getInt("aantal"));

    public List<MagazijnPlaats> findMagazijnPlaatsenByArtikelId(long id) {
        var sql = """
                select magazijnPlaatsId,artikelId,rij,rek,aantal
                from magazijnplaatsen
                where artikelId = ?
                order by rek,rij
                """;
        return template.query(sql, magazijnPlaatsMapper, id);
    }

    public List<MagazijnPlaats> findAndLockMagazijnPlaatsenByArtikelId(long id) {
        var sql = """
                select magazijnPlaatsId,artikelId,rij,rek,aantal
                from magazijnplaatsen
                where artikelId = ?
                order by rek,rij
                for update
                """;
        return template.query(sql, magazijnPlaatsMapper, id);
    }

    public void verlaagAantal(long magazijnPlaatsId, int aantal) {
        var sql = """
                update MagazijnPlaatsen
                set aantal = aantal - ?
                where magazijnPlaatsId = ?
                """;
        template.update(sql, aantal, magazijnPlaatsId);
    }

    //Vindt de eerstvolgende magazijnplaats waar het artikelId null is
    public Optional<MagazijnPlaats> findLegeMagazijnPlaats() {
        try {
        var sql = """
                SELECT magazijnPlaatsId, artikelId, rij, rek, aantal 
                from Magazijnplaatsen
                where artikelId is null
                order by magazijnPlaatsId
                limit 1
                """;
        return Optional.ofNullable(template.queryForObject(sql, magazijnPlaatsMapper));
        } catch (IncorrectResultSizeDataAccessException ex) {
            return Optional.empty();
        }
    }
    public void wijzigArtikelId(long magazijnPlaatsId, long artikelId) {
        var sql = """
                update magazijnplaatsen
                set artikelId = ?
                where magazijnPlaatsId = ?
                """;
        template.update(sql, artikelId, magazijnPlaatsId);
    }

    public void verhoogAantal(long magazijnPlaatsId, int aantal) {
        var sql = """
                update MagazijnPlaatsen
                set aantal = aantal + ?
                where magazijnPlaatsId = ?
                """;
        template.update(sql, aantal, magazijnPlaatsId);
    }

    public void verhoogAantalAndSetArtikelId(long magazijnPlaatsId, int aantal, long artikelId) {
        var sql = """
                update MagazijnPlaatsen
                set aantal = aantal + ?, artikelId = ?
                where magazijnPlaatsId = ?
                """;
        template.update(sql, aantal, artikelId, magazijnPlaatsId);
    }
    public void deleteMagazijnplaatsenByInkomendeLeveranciersId(long magazijnPlaatsId, int aantal){
        var sql = """
                UPDATE magazijnplaatsen
                SET aantal = aantal - ?,
                    artikelId = IF(aantal = 0, NULL, artikelId)
                WHERE magazijnPlaatsId = ?;
                """;
        template.update(sql, aantal, magazijnPlaatsId);
    }
}
