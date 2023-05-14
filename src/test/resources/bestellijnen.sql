insert into Bestellijnen(bestelId, artikelId, aantalBesteld, aantalGeannuleerd)
values ((select bestelId from Bestellingen where besteldatum = '2000-01-01 12:00:00'),
        (select artikelId from Artikelen where naam = 'test'), 5, 0),
       ((select bestelId from Bestellingen where besteldatum = '2000-01-01 13:00:00'),
        (select artikelId from Artikelen where naam = 'test'), 55, 0);