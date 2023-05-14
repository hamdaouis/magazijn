package be.vdab.magazijn.controllers;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit4.AbstractTransactionalJUnit4SpringContextTests;
import org.springframework.test.web.servlet.MockMvc;

import java.nio.file.Path;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@Sql({"/bestellingen.sql", "/artikelen.sql", "/bestellijnen.sql", "/magazijnplaatsen.sql", "/leveranciers.sql"})
@AutoConfigureMockMvc
@TestPropertySource("/application.properties")
class RetourBestellingControllerTest extends AbstractTransactionalJUnit4SpringContextTests {
    private final MockMvc mockMvc;

    RetourBestellingControllerTest(MockMvc mockMvc) {
        this.mockMvc = mockMvc;
    }

    private final static String BESTELLINGEN = "Bestellingen";
    private final static String ARTIKELEN = "Artikelen";
    private final static String BESTELLIJNEN = "Bestellijnen";
    private final static String UITGAANDELEVERINGEN = "UitgaandeLeveringen";
    private final static String MAGAZIJNPLAATSEN = "magazijnPlaatsen";
    private final static Path TEST_RESOURCES = Path.of("src/test/resources");

    private long getTestBestelId() {
        return jdbcTemplate.queryForObject("select bestelId from Bestellingen where besteldatum = '2000-01-01 12:00:00'", long.class);
    }

    private long getTestBestelId2() {
        return jdbcTemplate.queryForObject("select bestelId from Bestellingen where besteldatum = '2000-01-01 13:00:00'", long.class);
    }

    private long getEersteBestelling() {
        return jdbcTemplate.queryForObject("select bestelId from bestellingen where bestellingsStatusId = 2 order by bestelDatum,bestelId limit 1", long.class);
    }

    private long getTestArtikelId() {
        return jdbcTemplate.queryForObject("select artikelId from artikelen where naam = 'test'", long.class);
    }

    @Test
    void findRetourBestellingById() throws Exception {
        var bestelId = getTestBestelId();
        mockMvc.perform(get("/retours/" + bestelId)).andExpect(status().isOk());

    }

    @Test
    void findRetourBestellingByIdZonderRetourBestellingStatusGeeftConflictTerug() throws Exception {
        var bestelId = getTestBestelId2();
        mockMvc.perform(get("/retours/" + bestelId)).andExpect(status().isConflict());

    }

    @Test
    void plaatsenGetourneerdeArtikelen() throws Exception {
        var bestelId = getTestBestelId();
        var retourBestelling = mockMvc.perform(get("/retours/" + bestelId)).andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();
        mockMvc.perform(patch("/retours/artikellijst")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(retourBestelling))
                .andExpect(status().isOk());
        assertThat(countRowsInTableWhere(MAGAZIJNPLAATSEN, "rij = 'Z' and rek = 99999 and aantal = 15")).isOne();
        assertThat(countRowsInTableWhere(ARTIKELEN, "naam = 'test' and voorraad = 55")).isOne();


    }
}