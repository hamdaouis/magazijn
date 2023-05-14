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
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

@SpringBootTest
@Sql({"/bestellingen.sql", "/artikelen.sql", "/bestellijnen.sql", "/magazijnplaatsen.sql", "/leveranciers.sql"})
@AutoConfigureMockMvc
@TestPropertySource("/application.properties")
class BestellingControllerTest extends AbstractTransactionalJUnit4SpringContextTests {
    private final static String BESTELLINGEN = "Bestellingen";
    private final static String ARTIKELEN = "Artikelen";
    private final static String BESTELLIJNEN = "Bestellijnen";
    private final static String UITGAANDELEVERINGEN = "UitgaandeLeveringen";
    private final static String MAGAZIJNPLAATSEN = "magazijnPlaatsen";
    private final static Path TEST_RESOURCES = Path.of("src/test/resources");
    private final MockMvc mockMvc;

    public BestellingControllerTest(MockMvc mockMvc) {
        this.mockMvc = mockMvc;
    }

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
    void create() throws Exception {
        var bestelId = getTestBestelId();
        var responseBody = mockMvc.perform(post("/bestelling/uitgaand")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{ \"bestelId\": \"" + bestelId + "\", \"klantId\": \"2\" }"))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();
        assertThat(countRowsInTableWhere(UITGAANDELEVERINGEN,
                "uitgaandeLeveringsId =" + responseBody + " and bestelId =" + bestelId)).isOne();
    }

    @Test
    void findById() throws Exception {
        var bestelId = getTestBestelId();
        mockMvc.perform(get("/bestelling/" + bestelId)).andExpectAll(
                status().isOk(),
                jsonPath("besteldatum").value("2000-01-01T12:00:00"),
                jsonPath("klantId").value(1),
                jsonPath("btwNummer").value("0887010362")
        );
    }

    @Test
    void findByIdMetOnbestaandeBestellingGeeft404() throws Exception {
        mockMvc.perform(get("/bestelling/" + Long.MAX_VALUE)).andExpectAll(
                status().isNotFound()
        );
    }

    @Test
    void findBestellijnArtikelenByBestelId() throws Exception {
        var bestelId = getTestBestelId();
        mockMvc.perform(get("/bestelling/" + bestelId + "/bestellijn")).andExpectAll(
                status().isOk(),
                jsonPath("length()").value(1),
                jsonPath("[0].naam").value("test")
        );
    }

    @Test
    void findEerstvolgendeBestelId() throws Exception {
        var bestelId = getEersteBestelling();
        mockMvc.perform(get("/bestelling")).andExpectAll(
                status().isOk(),
                jsonPath("$").value(bestelId));
    }

    @Test
    void verwerkBestelling() throws Exception {
        var bestelId = getTestBestelId();
        var artikelId = getTestArtikelId();
        mockMvc.perform(post("/bestelling/verwerk/" + getTestBestelId())).andExpect(
                status().isOk());
        assertThat(countRowsInTableWhere(ARTIKELEN, "naam = 'test' and voorraad = 45")).isOne();
        assertThat(countRowsInTableWhere(MAGAZIJNPLAATSEN, "artikelId =" + artikelId + " and aantal = 5")).isOne();
        assertThat(countRowsInTableWhere(UITGAANDELEVERINGEN, "bestelId =" + bestelId)).isOne();
    }

    @Test
    void verwerkBestellingMetOnvoldoendeVooorraadGeeftConflict() throws Exception {
        var bestelId = getTestBestelId2();
        mockMvc.perform(post("/bestelling/verwerk/" + getTestBestelId2())).andExpect(
                status().isConflict());
    }




}