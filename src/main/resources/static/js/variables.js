import {byId} from "./util.js";

const leveringlijnContainer = document.querySelector('.leveringslijn');
const forms = document.querySelectorAll('form');
const leveranciers = byId("leveranciers");
const bonnummerInvoer = byId("bonnummer");
const datumInvoer = byId("datum");
const leveringsForm = byId("leveringsForm");
const verstuurLevering = byId("verstuurLevering");
const deleteLevering = byId("deleteLevering");
const leveringslijnForm = byId("leveringslijnForm");
const eanNummer = byId("ean");
const goedgekeurd = byId("goedgekeurd");
const afgekeurd = byId("afgekeurd");
const add = byId("add");
const verstuur = byId("verstuur");
const tbody = byId("leveringslijnen");
const artikelenBody = byId("artikelenBody")
let leveringslijnSet = JSON.parse(sessionStorage.getItem("levering_" + "lijnset"));
if (!leveringslijnSet) leveringslijnSet = [];
let status = sessionStorage.getItem("levering_" + "status");
if (status === null) status = "default";

export { leveringlijnContainer, eanNummer, goedgekeurd, afgekeurd, leveringslijnSet, leveranciers,
    status, forms, leveringsForm, verstuurLevering, leveringslijnForm, deleteLevering,
    bonnummerInvoer, datumInvoer, tbody, add, verstuur, artikelenBody };