package be.vdab.magazijn.controllers;

import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit4.AbstractTransactionalJUnit4SpringContextTests;
import org.springframework.test.web.servlet.MockMvc;

import java.nio.file.Path;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

@SpringBootTest
@Sql({"/bestellingen.sql", "/artikelen.sql", "/bestellijnen.sql", "/magazijnplaatsen.sql", "/leveranciers.sql","/uitgaandeleveringen.sql"})
@AutoConfigureMockMvc
@TestPropertySource("/application.properties")
class LeveringControllerTest extends AbstractTransactionalJUnit4SpringContextTests {
    private final static String BESTELLINGEN = "Bestellingen";
    private final static String ARTIKELEN = "Artikelen";
    private final static String BESTELLIJNEN = "Bestellijnen";
    private final static String UITGAANDELEVERINGEN = "uitgaandeLeveringen";
    private final static String MAGAZIJNPLAATSEN = "magazijnPlaatsen";
    private final static String INKOMENDELEVERINGEN = "inkomendeleveringen";
    private final static String INKOMENDELEVERINGSLIJNEN = "inkomendeleveringslijnen";
    private final static Path TEST_RESOURCES = Path.of("src/test/resources");
    private final MockMvc mockMvc;

    LeveringControllerTest(MockMvc mockMvc) {
        this.mockMvc = mockMvc;
    }

    private long idVanTestLeveranciers() {
        return jdbcTemplate.queryForObject("select leveranciersId from leveranciers where naam = 'testLeverancier'", long.class);
    }

    private long idVanTestArtikel1() {
        return jdbcTemplate.queryForObject("select artikelId from artikelen where naam = 'test'", long.class);
    }

    private long idVanTestArtikel2() {
        return jdbcTemplate.queryForObject("select artikelId from artikelen where naam = 'test2'", long.class);
    }


    private long idVanTestBestelling() {
        return jdbcTemplate.queryForObject("select bestelId from bestellingen where besteldatum = '2000-01-01 12:00:00' and bedrijfsnaam = 'test'", long.class);
    }
/*
    @Test
    void create() throws Exception {
        var jsonData = Files.readString(TEST_RESOURCES.resolve("inkomendeLevering.json"));
        jsonData = jsonData.replaceAll("99999", String.valueOf(idVanTestLeveranciers()));
        var responseBody = mockMvc.perform(post("/leveringen")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonData)).andExpect(status().isOk()).andReturn().getResponse().getContentAsString();
        assertThat(countRowsInTableWhere(INKOMENDELEVERINGEN, "inkomendeLeveringsId = " + responseBody)).isOne();

    }

    @Test
    void nieuweLeveringsLijnen() throws Exception {
        var jsonData2 = Files.readString(TEST_RESOURCES.resolve("inkomendeLevering.json"));
        jsonData2 = jsonData2.replaceAll("99999", String.valueOf(idVanTestLeveranciers()));
        var inkomendeLeveringsId = mockMvc.perform(post("/leveringen")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonData2)).andExpect(status().isOk()).andReturn().getResponse().getContentAsString();

        var idLeverancier = idVanTestLeveranciers();
        var jsonData = Files.readString(TEST_RESOURCES.resolve("inkomendeLeveringsLijnen.json"));
        jsonData = jsonData.replaceAll("111111", String.valueOf(idVanTestArtikel1()));
        jsonData = jsonData.replaceAll("222222", String.valueOf(idVanTestArtikel2()));
        var responseBody = mockMvc.perform(post("/leveringen/" + inkomendeLeveringsId + "/leveringslijnen")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonData)).andExpect(status().isOk());
        assertThat(countRowsInTableWhere(INKOMENDELEVERINGSLIJNEN, "inkomendeLeveringsId = " + inkomendeLeveringsId)).isEqualTo(2);
        assertThat(countRowsInTableWhere(MAGAZIJNPLAATSEN, "rij = 'Z' and rek = 99999 and aantal = 12")).isOne();
        assertThat(countRowsInTableWhere(MAGAZIJNPLAATSEN, "rij = 'Z' and rek = 99998 and aantal = 12")).isOne();
        assertThat(countRowsInTableWhere(ARTIKELEN, "naam = 'test' and voorraad = 52")).isOne();
        assertThat(countRowsInTableWhere(ARTIKELEN, "naam = 'test2' and voorraad = 52")).isOne();
    }

    @Test
    void deleteMethod() throws Exception {
        var jsonData2 = Files.readString(TEST_RESOURCES.resolve("inkomendeLevering.json"));
        jsonData2 = jsonData2.replaceAll("99999", String.valueOf(idVanTestLeveranciers()));
        var inkomendeLeveringsId = mockMvc.perform(post("/leveringen")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonData2)).andExpect(status().isOk()).andReturn().getResponse().getContentAsString();
        assertThat(countRowsInTableWhere(INKOMENDELEVERINGEN, "inkomendeLeveringsId = " + inkomendeLeveringsId)).isOne();

        mockMvc.perform(delete("/leveringen/" + inkomendeLeveringsId)).andExpect(status().isOk());
        assertThat(countRowsInTableWhere(INKOMENDELEVERINGEN, "inkomendeLeveringsId = " + inkomendeLeveringsId)).isZero();

    }

 */

/*    @Test
    void changeLeveringStatus() throws Exception {
        var jsonData = Files.readString(TEST_RESOURCES.resolve("uitgaandeLeveringStatus.json"));
        var responseBody = mockMvc.perform(patch("/leveringen/uitgaandeleveringen/" + idVanTestBestelling())
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonData)).andExpect(status().isOk());
        assertThat(countRowsInTableWhere(UITGAANDELEVERINGEN, "bestelId = " + idVanTestBestelling() + " and uitgaandeLeveringsStatus = 4")).isOne();
    }*/
}