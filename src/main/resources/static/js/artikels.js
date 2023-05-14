"use strict"

import {byId, toon, verberg, setText} from "./util.js";
byId("hoofd-logo").addEventListener("click",function (){
    location.href="index.html";
})
const bestelArtikel = JSON.parse(sessionStorage.getItem("bestelling_"+"bestelArtikel"));

const artikelResponse = await fetch(`artikels/${bestelArtikel.artikelId}`);
if (artikelResponse.ok) {
    const artikel = await artikelResponse.json();
    setText("artikelNaam", artikel.naam);
    setText("artikelId", artikel.artikelId);
    setText("ean", artikel.ean);
    setText("beschrijving", artikel.beschrijving);
    setText("prijs", artikel.prijs);
    setText("gewicht", artikel.gewichtInGram);
    setText("bestelpeil", artikel.bestelpeil);
    setText("voorraad", artikel.voorraad);
    setText("minVoorraad", artikel.minimumVoorraad);
    setText("maxVoorraad", artikel.maximumVoorraad);
    setText("levertijd", artikel.levertijd);
    setText("maxInMagazijnPlaats", artikel.maxAantalInMagazijnPlaats);
} else {
    if (artikelResponse.status === 404) {
        toon("nietGevonden");
    } else {
        toon("storing");
    }
}
byId("terug").onclick = () => window.history.back();