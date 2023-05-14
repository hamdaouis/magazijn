package be.vdab.magazijn.controllers;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit4.AbstractTransactionalJUnit4SpringContextTests;
import org.springframework.test.web.servlet.MockMvc;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@Sql({"/bestellingen.sql", "/artikelen.sql", "/bestellijnen.sql"})
@AutoConfigureMockMvc
@TestPropertySource("/application.properties")
class TvControllerTest extends AbstractTransactionalJUnit4SpringContextTests {
    private final static String BESTELLINGEN = "Bestellingen";
    private final MockMvc mockMvc;

    public TvControllerTest(MockMvc mockMvc) {
        this.mockMvc = mockMvc;
    }

    private long getTestArtikelId() {
        return jdbcTemplate.queryForObject("select artikelId from Artikelen where naam = 'test'", long.class);
    }

    private long getTestBestelId() {
        return jdbcTemplate.queryForObject("select bestelId from Bestellingen where besteldatum = '2000-01-01 12:00:00'", long.class);
    }

    private long getEersteBestelId() {
        return jdbcTemplate.queryForObject("select bestelId from bestellingen where bestellingsStatusId = 2 order by besteldatum,bestelId limit 1", long.class);
    }

    private long getAantalBestellingen() {
        return jdbcTemplate.queryForObject("select count(bestelId) from bestellingen where bestellingsStatusId = 2 ", long.class);
    }

    @Test
    void findAantalOpenBestellingen() throws Exception {
        var aantalBestellingen = getAantalBestellingen();

        mockMvc.perform(get("/TV/aantal"))
                .andExpectAll(status().isOk(),
                        jsonPath("$").value(aantalBestellingen));
    }

    @Test
    void volgende5Bestellingen() throws Exception {
        var eersteBestellingId = getEersteBestelId();
        mockMvc.perform(get("/TV")).andExpectAll(
                status().isOk(),
                jsonPath("length()").value(5),
                jsonPath("[0].bestelId").value(eersteBestellingId));
    }
}