"use strict"

import {byId, setText, toon, verberg} from "./util.js";
import {
    bonnummerInvoer,
    datumInvoer,
    deleteLevering,
    eanNummer,
    forms,
    leveranciers,
    leveringsForm,
    leveringslijnForm,
    status,
    verstuurLevering,
    tbody, leveringslijnSet, add, verstuur, artikelenBody, leveringlijnContainer, afgekeurd, goedgekeurd
} from './variables.js';

// DOM content
document.addEventListener('DOMContentLoaded', function () {
    setPaginaStatus(status);
    const today = new Date().toISOString().split('T')[0];
    datumInvoer.setAttribute('max', today);
});


// Haal leverancierslijst op
async function getLeveranciers() {
    const response = await fetch(`leveranciers?naamBevat=${leveranciers.value}`);
    if (response.ok) {
        return await response.json();
    }
}

// Haal ean nummers op
async function getEanNummers() {
    const response = await fetch(`artikels?eanBevat=${eanNummer.value}`);
    if (response.ok) {
        return await response.json();
    }
}

//Haal de waarden/values van de inputs op en sla deze op in sessionStorage
forms.forEach(form => {
    const formId = form.getAttribute('id');
    const formInputs = form.querySelectorAll('input, select, textarea');
    formInputs.forEach(formInput => {
        const inputId = formInput.getAttribute('id');

        const savedValue = sessionStorage.getItem(`levering_${formId}_${inputId}`);

        if (savedValue) {
            formInput.value = savedValue;
        }
        formInput.addEventListener('input', () => {
            sessionStorage.setItem(`levering_${formId}_${inputId}`, formInput.value);
        });
        document.addEventListener('click', () => {
            sessionStorage.setItem(`levering_${formId}_${inputId}`, formInput.value);
        });
    });
});

// Vul de autocomplete functie met de leverancierslijst
await autocomplete(leveranciers, await getLeveranciers());
// Vul de autocomplete functie met de ean nummers
await autocomplete(eanNummer, await getEanNummers());

// Autocomplete functie voor leverancier en ean nummer suggesties weer te geven
async function autocomplete(input, lijst) {
    input.addEventListener('input', function () {
        verberg("error");
        sluitLijst();
        if (!this.value)
            return;
        const suggesties = document.createElement('div');
        suggesties.setAttribute('id', 'suggesties');
        this.parentNode.appendChild(suggesties);
        let count = 0;
        lijst.forEach(item => {
            if (count >= 6) {
                return;
            }
            let soort = "artikel";
            let naam = item.ean;
            let id = item.artikelId;
            if (naam === null || naam === undefined) {
                console.log(true);
                naam = item.naam;
                id = item.leveranciersId;
                soort = "leveranciers";
            }
            if (naam.toUpperCase().includes(this.value.toUpperCase())) {
                const suggestie = document.createElement('div');
                suggestie.innerHTML = naam;
                suggestie.id = id;
                suggestie.addEventListener('click', function () {
                    input.value = this.innerHTML;
                    sessionStorage.setItem("levering_" + soort + "Id", suggestie.id);
                    sluitLijst();
                });
                suggestie.style.cursor = 'pointer';
                suggesties.appendChild(suggestie);
                count++;
            }
        });
    });

    function sluitLijst() {
        let suggesties = byId('suggesties');
        if (suggesties)
            suggesties.parentNode.removeChild(suggesties);
    }
}

// Stel paginastatus in
function setPaginaStatus(status) {

    switch (status) {
        case 'leveringslijn':
            const inputs = leveringsForm.querySelectorAll('input, textarea, select');
            inputs.forEach(input => {
                input.disabled = true;
            });
            toon("deleteLevering");
            verstuurLevering.disabled = true;
            const leverijngslijninputs = leveringslijnForm.querySelectorAll('input, textarea, select, button');
            leverijngslijninputs.forEach(input => {
                input.disabled = false;
            });
            const table = document.querySelector('.container-right tbody');
            printLeveringslijn();
            if (table.hasChildNodes()) {
                toon("container-right")
            } else {
                verberg("container-right");
            }
            toggleCollapsibles("leveringslijnCollaps");
            break;
        case 'overzicht':
            forms.forEach(form => {
                const inputs = form.querySelectorAll('input, textarea, select, button');
                inputs.forEach(input => {
                    input.disabled = true;
                });
            });
            vulLijst();
            printLeveringslijn();
            toon("overzichtForm");
            toon("deleteLevering");
            verberg("verstuur");
            verberg("error");
            deleteLevering.disabled = false;
            toggleCollapsibles("overzichtCollaps");
            break;
        default:
            const leveringslijnInputs = leveringslijnForm.querySelectorAll('input, textarea, select, button');
            leveringslijnInputs.forEach(input => {
                input.disabled = true;
            });
            toggleCollapsibles("leveringCollaps");
    }
}

//Maak JSON voor een nieuw inkomende levering
function generateLeveringJSON() {
    const leveranciersId = sessionStorage.getItem("levering_" + "leveranciersId");
    return {
        leveranciersId: parseInt(leveranciersId),
        bonNummer: bonnummerInvoer.value,
        datum: datumInvoer.value
    };
}

//Stuur leveringsformulier door
leveringsForm.addEventListener("submit", async (event) => {
    event.preventDefault();
    try {
        const levering = generateLeveringJSON();
        const leveringResponse = await fetch("leveringen", {
            method: "POST",
            headers: {'Content-Type': "application/json"},
            body: JSON.stringify(levering)
        });
        if (leveringResponse.ok) {
            sessionStorage.setItem("levering_" + "inkomendeLeveringsId", await leveringResponse.text());
            sessionStorage.setItem("levering_" + "status", "leveringslijn");
            toggleCollapsibles("leveringCollaps");
            setPaginaStatus("leveringslijn");
            sessionStorage.removeItem("artikelId");
        } else {
            throw new Error(await leveringResponse.message);
        }
    } catch (error) {
        console.error(error);
    }
})

//Verwijder levering/leveringslijnen
deleteLevering.addEventListener("click", async (event) => {
    event.preventDefault();
    const leveringsId = sessionStorage.getItem("levering_" + "inkomendeLeveringsId");
    const response = await fetch(`leveringen/${leveringsId}`, {method: "Delete"});
    if (response.ok) {
        clearPaginaSessionStorage('levering');
        location.reload();
    } else {
        console.log("NOK");
    }
})

//Maak JSON voor een nieuw inkomende leveringslijn
function generateLeveringsLijn() {
    const json =
        {
            ean: eanNummer.value,
            artikelId: parseInt(sessionStorage.getItem("levering_" + "artikelId")),
            aantalGoedgekeurd: parseInt(goedgekeurd.value),
            aantalTeruggestuurd: parseInt(afgekeurd.value)
        }
    try {
        addJsonToSetAndLeveringsLijn(json)
    } catch (error) {
        console.error(error);
        byId("error").innerText = error;
        toon("error");
    }
}

//Voeg JSON toe aan leveringslijn lijst
function addJsonToSetAndLeveringsLijn(json) {
    if (json.artikelId === "" || json.aantalGoedgekeurd === "" || json.aantalTeruggestuurd === "") {
        return;
    }
    if (!leveringslijnSet.empty) {
        for (const item of leveringslijnSet) {
            if (item.artikelId === json.artikelId) {
                throw (`Artikel ${json.ean} werd al verwerkt`);
            }
        }
    }
    leveringslijnSet.push(json);
}

//Toon lijst op pagina
function printLeveringslijn() {
    tbody.innerHTML = "";
    leveringslijnSet.forEach(lijn => {
        const tr = tbody.insertRow();
        tr.id = sessionStorage.getItem("levering_" + "artikelId");
        const eanCell = tr.insertCell();
        eanCell.innerText = lijn.ean;
        const goedgekeurdCell = tr.insertCell();
        goedgekeurdCell.innerText = lijn.aantalGoedgekeurd;
        const afgekeurdCell = tr.insertCell();
        afgekeurdCell.innerText = lijn.aantalTeruggestuurd;
    })
    toon("container-right");
}

//Verwerk toevoeging leveringslijnen
add.addEventListener("click", (event) => {
    const form = byId("leveringslijnForm");
    const inputs = leveringlijnContainer.querySelectorAll('input');
    if (form.checkValidity()) {
        event.preventDefault();
        generateLeveringsLijn();
        inputs.forEach(input => {
            input.value = '';
        });
        printLeveringslijn();
        sessionStorage.setItem("levering_" + "lijnset", JSON.stringify(leveringslijnSet));
        const content = byId("leveringslijnCollaps").nextElementSibling;
        content.style.maxHeight = content.scrollHeight + "px";
    } else {
    }
});

//Stuur alle leveringslijnen door en krijg het overzicht van de artikelen terug
verstuur.addEventListener("click", async () => {
    let newLijst = JSON.parse(JSON.stringify(leveringslijnSet));
    newLijst.forEach(lijn => {
        delete lijn.ean;
    });
    const inkomendeLeveringsId = sessionStorage.getItem("levering_" + "inkomendeLeveringsId");
    try {

        const response = await fetch(`leveringen/${inkomendeLeveringsId}/leveringslijnen`,
            {
                method: "POST",
                headers: {'Content-Type': "application/json"},
                body: JSON.stringify(newLijst)
            });
        if (response.ok) {
            sessionStorage.setItem("levering_" + "artikelLijst", JSON.stringify(await response.json()))
            sessionStorage.setItem("levering_" + "status", "overzicht");
            toggleCollapsibles("leveringslijnCollaps");
            setPaginaStatus("overzicht");
        } else {
            throw new Error(await leveringResponse.message);
        }
    } catch {
        console.log(error);
        byId("error").innerText = error;
        toon("error");
    }
})

//Toon overzicht
function vulLijst() {
    const lijst = JSON.parse(sessionStorage.getItem("levering_" + "artikelLijst"));
    for (const artikel of lijst) {
        const tr = artikelenBody.insertRow();
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

//Hernieuw pagina volledig bij het afwerken van levering
byId("overzichtForm").addEventListener("submit", (event) => {
    clearPaginaSessionStorage('levering');
    location.reload();
})

// In- en uitklapbare vensters
document.querySelectorAll(".collapsible").forEach(venster => {
    venster.addEventListener("click", function () {
        toggleCollapsibles(venster.id.toString());
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

//Controleer of alle checkboxes aangevinkt zijn
function checkboxStatus() {
    const checkboxes = document.querySelectorAll('input[type="checkbox"]');
    const afgewerktButton = document.getElementById('afwerken');

    checkboxes.forEach((checkbox) => {
        const row = checkbox.parentElement.parentElement;
        checkbox.checked = sessionStorage.getItem("levering_" + checkbox.id) === 'true';

        row.style.background = sessionStorage.getItem("levering_" + checkbox.id + "_color") || row.style.background;
        checkbox.addEventListener('change', () => {


            const bgColor = checkbox.checked ? "beige" : "";
            row.style.background = bgColor;
            sessionStorage.setItem("levering_" + checkbox.id + "_color", bgColor);
            sessionStorage.setItem("levering_" + checkbox.id, checkbox.checked);
            afgewerktButton.disabled = document.querySelectorAll('input[type="checkbox"]:checked').length !== checkboxes.length;
        });
        afgewerktButton.disabled = document.querySelectorAll('input[type="checkbox"]:checked').length !== checkboxes.length;
    });
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