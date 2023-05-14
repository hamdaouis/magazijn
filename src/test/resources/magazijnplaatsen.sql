insert into magazijnplaatsen(artikelId, rij, rek, aantal)
values ((select artikelId from artikelen where naam = 'test'), 'Z', 99999, 10),
       ((select artikelId from artikelen where naam = 'test2'), 'Z', 99998, 10);