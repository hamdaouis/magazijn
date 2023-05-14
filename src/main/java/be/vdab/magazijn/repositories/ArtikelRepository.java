package be.vdab.magazijn.repositories;

import be.vdab.magazijn.domain.Artikel;
import be.vdab.magazijn.dto.ArtikelBeknopt;
import be.vdab.magazijn.dto.BestellijnArtikelBeknopt;
import be.vdab.magazijn.dto.LeveringslijnArtikel;
import org.springframework.dao.IncorrectResultSizeDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class ArtikelRepository {
    private final JdbcTemplate template;

    public ArtikelRepository(JdbcTemplate template) {
        this.template = template;
    }

    private final RowMapper<Artikel> artikelMapper = (result, rowNum) ->
            new Artikel(result.getLong("artikelId"), result.getString("ean"),
                    result.getString("naam"), result.getString("beschrijving"),
                    result.getBigDecimal("prijs"), result.getInt("gewichtInGram"),
                    result.getInt("bestelpeil"), result.getInt("voorraad"),
                    result.getInt("minimumVoorraad"), result.getInt("maximumVoorraad"),
                    result.getInt("levertijd"), result.getInt("aantalBesteldLeverancier"),
                    result.getInt("maxAantalInMagazijnPLaats"), result.getLong("leveranciersId"));

    private final RowMapper<LeveringslijnArtikel> leverlijnArtikelMapper = (result, rowNum) ->
            new LeveringslijnArtikel(result.getString("naam"), result.getString("beschrijving"), result.getInt("maxAantalInMagazijnPlaats"));

    public Optional<Artikel> findById(long id) {
        try {
            var sql = """
                    select artikelId,ean,naam,beschrijving,prijs,gewichtInGram,bestelpeil,voorraad,minimumVoorraad,maximumVoorraad,levertijd,
                    aantalBesteldLeverancier,maxAantalInMagazijnPLaats,leveranciersId
                    from artikelen
                    where artikelId = ?
                    """;
            return Optional.of(template.queryForObject(sql, artikelMapper, id));
        } catch (IncorrectResultSizeDataAccessException ex) {
            return Optional.empty();
        }
    }

    public Optional<Artikel> findAndLockById(long id) {
        try {
            var sql = """
                    select artikelId,ean,naam,beschrijving,prijs,gewichtInGram,bestelpeil,voorraad,minimumVoorraad,maximumVoorraad,levertijd,
                    aantalBesteldLeverancier,maxAantalInMagazijnPLaats,leveranciersId
                    from artikelen
                    where artikelId = ?
                    for update
                    """;
            return Optional.of(template.queryForObject(sql, artikelMapper, id));
        } catch (IncorrectResultSizeDataAccessException ex) {
            return Optional.empty();
        }
    }

    public List<BestellijnArtikelBeknopt> findBestellijnArtikelBeknoptByBestelId(long bestelId) {
        var sql = """
                SELECT a.artikelId, a.naam, (aantalBesteld - aantalGeannuleerd) as aantal
                from Bestellijnen
                inner join Artikelen a on Bestellijnen.artikelId = a.artikelId
                where bestelId = ?
                """;
        return template.query(sql, (result, rowNum) -> new BestellijnArtikelBeknopt(result.getLong("artikelId"), result.getString("naam"), result.getInt("aantal"))
                , bestelId);
    }

    public void verminderVoorraadMetAantal(long artikelId, int aantal) {
        var sql = """
                update artikelen
                set voorraad = voorraad - ?
                where artikelId = ?
                """;
        template.update(sql, aantal, artikelId);
    }

    public void verhoogVoorraadMetAantal(long artikelId, int aantal) {
        var sql = """
                update artikelen
                set voorraad = voorraad + ?
                where artikelId = ?
                """;
        template.update(sql, aantal, artikelId);
    }

    public List<ArtikelBeknopt> findByEANBevat(String ean) {
        var sql = """
                select artikelId, ean
                from Artikelen
                where ean like ?
                order by artikelId
                """;
        return template.query(sql, (result, rowNum) ->
                new ArtikelBeknopt(result.getLong("artikelId"), result.getString("ean")), "%" + ean + "%");
    }

    public LeveringslijnArtikel findLeveringslijnGegevensById(long artikelId) {
        var sql = """
                select naam, beschrijving, maxAantalInMagazijnPLaats
                from Artikelen
                where artikelId = ?
                """;
        return template.queryForObject(sql, leverlijnArtikelMapper, artikelId);
    }
}
