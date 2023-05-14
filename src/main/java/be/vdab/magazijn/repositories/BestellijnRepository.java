package be.vdab.magazijn.repositories;

import be.vdab.magazijn.domain.Bestellijn;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class BestellijnRepository {
    private final JdbcTemplate template;

    public BestellijnRepository(JdbcTemplate template) {
        this.template = template;
    }

    private final RowMapper<Bestellijn> bestellijnMapper = (result, rownum) ->
            new Bestellijn(result.getLong("bestellijnId"), result.getLong("bestelId"), result.getLong("artikelId"),
                    result.getInt("aantalBesteld"), result.getInt("aantalGeannuleerd"));


    public List<Bestellijn> findBestellijnenByBestelId(long bestelId) {
        var sql = """
                select bestellijnId,bestelId,artikelId,aantalBesteld,aantalGeannuleerd
                from bestellijnen
                where bestelId = ?
                order by bestellijnId
                """;
        return template.query(sql, bestellijnMapper, bestelId);
    }
    public Bestellijn findBestellijnByArtikelIdAndBestelId(long artikelId, long bestelId){
        var sql = """
                SELECT bestellijnId, bestelId, artikelId, aantalBesteld, aantalGeannuleerd
                from Bestellijnen
                where artikelId = ? and bestelId = ?
                for update
                """;
        return template.queryForObject(sql, bestellijnMapper, artikelId, bestelId);
    }
}
