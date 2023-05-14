package be.vdab.magazijn.controllers;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit4.AbstractTransactionalJUnit4SpringContextTests;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.nio.file.Path;

@SpringBootTest
@Sql({"/bestellingen.sql", "/artikelen.sql", "/bestellijnen.sql"})
@AutoConfigureMockMvc
@TestPropertySource("/application.properties")
class ArtikelControllerTest extends AbstractTransactionalJUnit4SpringContextTests {
    private final static String BESTELLINGEN = "Bestellingen";
    private final static String BESTELLIJNEN = "Bestellijnen";
    private final static String UITGAANDELEVERINGEN = "UitgaandeLeveringen";
    private final static Path TEST_RESOURCES = Path.of("src/test/resources");
    private final MockMvc mockMvc;

    ArtikelControllerTest(MockMvc mockMvc) {
        this.mockMvc = mockMvc;
    }

    private long idVanTestArtikel() {
        return jdbcTemplate.queryForObject("select artikelId from artikelen where naam = 'test'", long.class);
    }

    @Test
    void findById() throws Exception {
        var id = idVanTestArtikel();
        mockMvc.perform(get("/artikels/" + id)).andExpectAll(
                status().isOk(),
                jsonPath("naam").value("test"));
    }

    @Test
    void findByIdMetOnbestaandeArtikelGeeftNotFound() throws Exception {
        mockMvc.perform(get("/artikels/" + Long.MAX_VALUE)).andExpectAll(
                status().isNotFound());
    }
}