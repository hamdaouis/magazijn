insert into Bestellingen(besteldatum, klantId, betaald, betaalwijzeId, bestellingsStatusId, actiecodeGebruikt,
                         bedrijfsnaam, btwNummer, voornaam, familienaam, facturatieAdresId, leveringsAdresId)
values ('2000-01-01 12:00:00', 1, 1, 1, 9, 0, 'test', '0887010362', 'test', 'test', 1, 7),
       ('2000-01-01 13:00:00', 1, 1, 1, 2, 0, 'test', '0887010362', 'test', 'test', 1, 7),
       ('2000-01-01 14:00:00', 1, 1, 1, 2, 0, 'test', '0887010362', 'test', 'test', 1, 7),
       ('2000-01-01 15:00:00', 1, 1, 1, 2, 0, 'test', '0887010362', 'test', 'test', 1, 7),
       ('2000-01-01 16:00:00', 1, 1, 1, 2, 0, 'test', '0887010362', 'test', 'test', 1, 7);
/* In Tv-Scherm moet er 5 bestellingen getoond worden daarom insert ik 5 test records. */