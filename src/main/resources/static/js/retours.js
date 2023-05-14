"use strict"

import {byId, setText, toon, verberg, verwijderChildElementenVan} from "./util.js";

document.addEventListener('DOMContentLoaded', async function () {
    const pageState = sessionStorage.getItem("retour_" + "status");
    if (pageState === "bestelIdIngegeven") {
        const bestellijst = JSON.parse(sessionStorage.getItem("retour_" + "bestelling"));
        toonBestelling(bestellijst);
        verberg("bestelling");
        byId("labelCheckbox").style.visibility = "visible";
        toon("bestellingInfo");
    } else if (pageState === "overzicht") {
        toonArtikelen();
        verberg("bestellingInfo");
        verberg("bestelling");
        toon("retourMagazijnPlaatsenDIV");
        toon("afwerken");
    } else {
        verberg("bestellingInfo");
        verberg("bestelling");
        verberg("retourMagazijnPlaatsenDIV");
        toon("bestelling");
    }
})
byId("hoofd-logo").addEventListener("click", function () {
    location.href = "index.html";
})

byId("verwerk").onclick = async function () {
    byId("labelCheckbox").style.visibility = "visible";
    sessionStorage.setItem("retour_" + "status", "bestelIdIngegeven");
    const zoekIdInput = byId("zoekId");
    if (!zoekIdInput.checkValidity()) {
        toon("zoekIdFout");
        zoekIdInput.focus();
        return;
    }
    await findById(zoekIdInput.value);
    verberg("bestelling");
}

function toonBestelling(retour) {
    const retoursBody = byId("retoursBody");
    setText("voornaam", retour.voornaam);
    setText("achternaam", retour.familienaam);
    for (const artikel of retour.artikels) {
        const tr = retoursBody.insertRow();
        tr.insertCell().innerText = artikel.ean;
        tr.insertCell().innerText = artikel.beschrijving;
        tr.insertCell().innerText = artikel.aantal;
    }
    toon("bestellingInfo");
    toon("verder");
}

async function findById(id) {
    const retourResponse = await fetch(`retours/${id}`);
    if (retourResponse.ok) {
        sessionStorage.setItem("retour_" + "bestelling", JSON.stringify(await retourResponse.json()));
        verbergFouten();
        const retour = JSON.parse(sessionStorage.getItem("retour_" + "bestelling"));
        toonBestelling(retour);
    } else {
        toon("nietGevonden");
        toon("terug");
        sessionStorage.setItem("retour_" + "status", "");
        ("retour");
    }
}

async function stuurBeschadigd() {
    const retour = JSON.parse(sessionStorage.getItem("retour_" + "bestelling"));
    const uitgaandeLeveringStatus = {
        "statusId": 4
    };
    const response = await fetch(`leveringen/uitgaandeLeveringen/${retour.bestelId}`, {
        method: "PATCH",
        headers: {'Content-type': "application/json"},
        body: JSON.stringify(uitgaandeLeveringStatus)
    });
    if (response.ok) {
        console.log("beschadigd patch is doorgestuurd");
        byId("labelCheckbox").hidden = true;
        verberg("verder");
        verberg("checkboxAfwerken");
        verberg("labelCheckbox");
        verberg("retoursOverzicht");
        verberg("voorEnAchternaam");
        byId("afwerkenMessage").innerText = "Retour bestelling afgewerkt. U wordt doorgestuurd naar de homepage."
        byId("messageDiv").hidden = false;
        verberg("bestellingInfo");
        setTimeout(() => {
            window.location = "retours.html";
        }, 3000);
        byId("afwerken").style.visibility = "hidden";
    } else {
        toon("retourMagazijnPlaatsenDIV");
        verberg("retoursOverzicht");
        verberg("voornaam");
        verberg("achternaam");
        verberg("checkboxAfwerken");
        verberg("labelCheckbox");
        byId("verder").innerText = "Verder";
    }
}

const afwerkenButton = byId("verder");
const afwerkenCheckbox = byId("checkboxAfwerken");
byId("afwerken").disabled = true;

afwerkenButton.addEventListener("click", () => {
    if (afwerkenCheckbox.checked === true) {
        verberg("checkboxAfwerken");
        stuurBeschadigd();
        sessionStorage.setItem("retour_" + "status", "");
        clearPaginaSessionStorage("retour");
    } else {
        sessionStorage.setItem("retour_" + "status", "overzicht");
        zetArtikelenTerug();
        toon("retourMagazijnPlaatsenDIV");
        verberg("bestellingInfo");
        toon("afwerken");
    }
});

async function zetArtikelenTerug() {
    const retour = JSON.parse(sessionStorage.getItem("retour_" + "bestelling"));
    const uitgaandeLeveringStatus = {
        "statusId": 6
    };
    const response = await fetch(`leveringen/uitgaandeLeveringen/${retour.bestelId}`, {
        method: "PATCH",
        headers: {'Content-type': "application/json"},
        body: JSON.stringify(uitgaandeLeveringStatus)
    });
    if (response.ok) {
        const retourResponse = await fetch(`retours/${retour.bestelId}/artikellijst`, {
            method: "PATCH",
            headers: {'Content-type': "application/json"},
            body: JSON.stringify(retour)
        });
        if (retourResponse.ok) {
            sessionStorage.setItem("retour_" + "overzicht", JSON.stringify(await retourResponse.json()));
            toonArtikelen();
        }
    }
}

function toonArtikelen() {
    const retour = JSON.parse(sessionStorage.getItem("retour_" + "overzicht"));
    const tbody = document.getElementById("artikelenBody");
    for (const artikel of retour) {
        const tr = tbody.insertRow();
        const naam = tr.insertCell();
        naam.innerText = artikel.naam;
        const beschrijving = tr.insertCell();
        beschrijving.innerText = artikel.beschrijving;
        const aantal = tr.insertCell();
        aantal.innerText = artikel.aantal;
        const locatie = tr.insertCell();
        locatie.innerText = artikel.rij + "" + artikel.rek;
        const gestockeerd = tr.insertCell();
        const checkbox = document.createElement("input");
        checkbox.type = "checkbox";
        checkbox.id = `${artikel.rij}${artikel.rek}`;
        gestockeerd.appendChild(checkbox);
    }
    checkboxStatus();
}

//input hide
//button hide


byId("afwerken").onclick = async function () {
    verberg("retourMagazijnPlaatsenDIV");
    byId("afwerkenMessage").innerText = "Retour bestelling afgewerkt. U wordt doorgestuurd naar de homepage."
    byId("messageDiv").hidden = false;
    verberg("checkboxAfwerken");
    verberg("bestellingInfo");
    clearPaginaSessionStorage("retour");
    verberg("afwerken");
    setTimeout(() => {
        window.location = "retours.html";
    }, 3000);
    clearPaginaSessionStorage("retour");
    verberg("afwerken");
}

function checkboxStatus() {
    const checkboxes = document.querySelectorAll('input[type="checkbox"]');
    const afgewerktButton = document.getElementById('afwerken');

    checkboxes.forEach((checkbox) => {
        const row = checkbox.parentElement.parentElement;
        checkbox.checked = sessionStorage.getItem("retour_" + checkbox.id) === 'true';
        row.style.background = sessionStorage.getItem("retour_" + checkbox.id + "_color") || row.style.background;
        checkbox.addEventListener('change', () => {
            const bgColor = checkbox.checked ? "beige" : "";
            row.style.background = bgColor;
            sessionStorage.setItem("retour_" + checkbox.id + "_color", bgColor);
            sessionStorage.setItem("retour_" + checkbox.id, checkbox.checked);
            afgewerktButton.disabled = document.querySelectorAll('input[type="checkbox"]:checked').length !== checkboxes.length - 1;
        });
        afgewerktButton.disabled = document.querySelectorAll('input[type="checkbox"]:checked').length !== checkboxes.length - 1;
    });
}

byId("terug").addEventListener("click", () => {
    location.reload();
});

function verbergFouten() {
    verberg("nietGevonden");
    verberg("storing");
    verberg("zoekIdFout");
}

function clearPaginaSessionStorage(pagina) {
    Object.keys(sessionStorage)
        .forEach(function (key) {
            if (key.startsWith(pagina + '_')) {
                sessionStorage.removeItem(key);
            }
        });
}