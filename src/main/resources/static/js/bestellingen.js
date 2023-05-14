"use strict"

import {byId, setText, toon, verberg} from "./util.js";

verberg("afgewerkt");

document.addEventListener('DOMContentLoaded', async function () {
    const pageState = sessionStorage.getItem("bestelling_" + "status");

    if (pageState === "zichtbaar") {
        await laadArtikel();
        toggleCollapsibles("nieuw");

    }
    checkboxStatus();
})


byId("afgewerkt").addEventListener("click", async function () {
    clearPaginaSessionStorage("bestelling")
    toggleCollapsibles("nieuw");
    await verwerk();
    verberg("artikelen");
    verberg("afgewerkt")
    byId("nieuw").disabled = false;
    byId("afgewerkt").disabled = true;
});

async function getBestelId() {
    const response = await fetch(`bestelling`);
    if (response.ok) {
        return await response.text();
    } else {
        toon("error");
        const responseJson = await response.json();
        setText("errorText", responseJson.message);
        byId("afgewerkt").hidden = true;
        verberg("artikelen");
    }
}

async function verwerk() {
    console.log('verwerk function started');
    const bestelId = await getBestelId();
    console.log('bestelId: ', bestelId);
    const response = await fetch(`bestelling/verwerk/${bestelId}`,
        {
            method: "POST"
        });
    console.log('response: ', response);
    if (response.ok) {
        toon("bestellingAfgewerkt");
        console.log("Success: showing message");
    } else {
        console.log("Error: response status = " + response.status);
    }
}

async function laadArtikel() {
    byId("artikelenBody").innerHTML = "";
    const bestelId = await getBestelId();
    setText("bestelId", "#" + bestelId);
    const response = await fetch(`bestelling/${bestelId}/bestellijn`);
    if (response.ok) {
        const artikelen = await response.json();
        for (const artikel of artikelen) {
            const tr = byId("artikelenBody").insertRow();
            tr.id = "row";
            const naam = tr.insertCell();
            const link = document.createElement("a");
            link.innerText = artikel.naam;
            link.href = "artikels.html";
            link.onclick = () => {
                sessionStorage.setItem("bestelling_" + "bestelArtikel", JSON.stringify(artikel));
            };
            naam.appendChild(link);
            tr.insertCell().innerText = (artikel.aantal);
            const magazijnPlaats = tr.insertCell();
            magazijnPlaats.id = "locatie";
            const nestedTable = document.createElement('table');
            artikel.magazijnplaatsen.forEach(plaats => {
                const locaties = [plaats.rij, plaats.rek].join("");
                const nestedRow = nestedTable.insertRow();
                const magazijnplaatsTitel = nestedRow.insertCell();
                magazijnplaatsTitel.innerHTML = "Magazijnplaats:" + "<br>" + "Voorraad aanwezig:" + "<br>" + "Aantal op te halen:";
                const magazijnplaatsLocatie = nestedRow.insertCell();
                magazijnplaatsLocatie.innerHTML = "<strong>" + locaties + "</strong>" + "<br>" + plaats.aantal + "<br>" + "<strong>" + plaats.aantalOpTeHalen + "</strong>";
                const checkboxCell = nestedRow.insertCell();
                const checkbox = document.createElement("input");
                checkbox.type = "checkbox";
                const rowIndex = [...checkboxCell.closest('tbody').querySelectorAll('tr')].indexOf(checkboxCell.closest('tr'));
                checkbox.id = `${artikel.artikelId} ${rowIndex}`;
                checkboxCell.appendChild(checkbox);
            });
            magazijnPlaats.appendChild(nestedTable);
        }
        toon("artikelen");
        toon("afgewerkt");
        byId("nieuw").disabled = true;
    } else {
        if (response.status === 404) {
            verberg("bestelId");
            toon("error");
            setText("errorText", "Geen geldige bestelId")
            verberg("bestelling");
            sessionStorage.removeItem("status");
        } else if (response.status === 409) {
            toon("error");
            const responseJson = await response.json();
            setText("errorText", responseJson.message)
            verberg("bestelId");
            sessionStorage.removeItem("status");
            verberg("bestelling");
        } else {
            verberg("bestelId");
            verberg("bestelling");
            toon("error");
            sessionStorage.removeItem("status");
        }
    }
    checkboxStatus();
}

function checkboxStatus() {
    const checkboxes = document.querySelectorAll('input[type="checkbox"]');
    const afgewerktButton = document.getElementById('afgewerkt');

    checkboxes.forEach((checkbox) => {
        const row = checkbox.parentElement.parentElement;
        checkbox.checked = sessionStorage.getItem("bestelling_" + checkbox.id) === 'true';
        checkbox.checked = sessionStorage.getItem("bestelling_" + checkbox.id) === 'true';

        row.parentElement.parentElement.parentElement.parentElement.style.background = sessionStorage.getItem("bestelling_" + checkbox.id + "_color") || row.parentElement.parentElement.parentElement.parentElement.style.background;
        checkbox.addEventListener('change', () => {

            const parentRow = checkbox.closest('tbody');
            const nestedCheckboxes = parentRow.querySelectorAll('input[type="checkbox"]');
            console.log(nestedCheckboxes);
            const allChecked = [...nestedCheckboxes].every(cb => cb.checked);
            console.log(allChecked);

            const bgColor = allChecked ? "beige" : "";
            row.parentElement.parentElement.parentElement.parentElement.style.background = bgColor;
            sessionStorage.setItem("bestelling_" + checkbox.id + "_color", bgColor);
            sessionStorage.setItem("bestelling_" + checkbox.id, checkbox.checked);
            afgewerktButton.disabled = document.querySelectorAll('input[type="checkbox"]:checked').length !== checkboxes.length;
        });
        afgewerktButton.disabled = document.querySelectorAll('input[type="checkbox"]:checked').length !== checkboxes.length;
    });
}


// In- en uitklapbare vensters
document.querySelectorAll(".collapsible").forEach(venster => {
    venster.addEventListener("click", async function () {
        sessionStorage.setItem("bestelling_" + "status", "zichtbaar");
        await laadArtikel();
        verberg("bestellingAfgewerkt");
        toggleCollapsibles(venster.id);
    })
})

// Toggle om tussen de twee staten te veranderen
function toggleCollapsibles(name) {
    byId(name).classList.toggle("active");
    const content = byId(name).nextElementSibling;
    if (content.style.display === "block") {
        content.style.display = "none";
    } else {
        content.style.display = "block";
    }
    if (content.style.maxHeight) {
        content.style.maxHeight = null;
    } else {
        content.style.maxHeight = content.scrollHeight + "px";
    }
}

//Verwijder alle sessionStorage items van de pagina
function clearPaginaSessionStorage(pagina) {
    Object.keys(sessionStorage)
        .forEach(function (key) {
            if (key.startsWith(pagina + '_')) {
                sessionStorage.removeItem(key);
            }
        });
}