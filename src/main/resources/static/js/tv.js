"use strict"

import {byId, setText, toon, verberg} from "./util.js";

byId("hoofd-logo").addEventListener("click",function (){
    location.href="index.html";
})
document.addEventListener('DOMContentLoaded', () => {
    getAantal();
    getBestellingen();
    startPolling();
});
async function getAantal(){
    byId("aantal").innerText = "";
    const aantalResponse = await fetch("TV/aantal");
    if (aantalResponse.ok) {
        const aantal = parseInt(await aantalResponse.text());
        setText("aantal", aantal)
    }
}
async function getBestellingen() {
    byId("bestellingenBody").innerHTML = "";
    const bestellingenResponse = await fetch("TV");
    if (bestellingenResponse.ok) {
        const bestellingen = await bestellingenResponse.json();
        for (const bestelling of bestellingen) {
            const tr = byId("bestellingenBody").insertRow();
            tr.insertCell().innerText = (bestelling.bestelId);
            tr.insertCell().innerText = (bestelling.aantalProducten);
            tr.insertCell().innerText = (bestelling.totaleGewicht);
        }
        const eersteRij = byId("bestellingenBody").rows[0];
        eersteRij.classList.add("active-row");
    }else {
        if (bestellingenResponse.status === 404) {
            toon("geenBestelling");
            verberg("bestellingen");
        } else {
            toon("storing");
        }
    }
}

function startPolling() {
    setInterval(() => {
        getBestellingen();
    }, 5000);
    setInterval(() => {
        getAantal();
    }, 5000);
}