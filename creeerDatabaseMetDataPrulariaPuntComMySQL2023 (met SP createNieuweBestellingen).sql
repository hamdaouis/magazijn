-- records toevoegen in inkomendeleveringen en inkomendeleveringslijnen + een voorbeeld van een leveringsbon in de opdracht Java plaatsen

-- create database
-- set global validate_password.policy=LOW;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


drop schema IF EXISTS `PrulariaCom`;

-- -----------------------------------------------------
-- Schema PrulariaCom
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `PrulariaCom` DEFAULT CHARACTER SET utf8 ;
USE `PrulariaCom` ;

-- -----------------------------------------------------
-- Table `PrulariaCom`.`Plaatsen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`Plaatsen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`Plaatsen` (
  `plaatsId` INT NOT NULL AUTO_INCREMENT,
  `postcode` VARCHAR(4) NOT NULL,
  `plaats` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`plaatsId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`Adressen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`Adressen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`Adressen` (
  `adresId` INT NOT NULL AUTO_INCREMENT,
  `straat` VARCHAR(100) NOT NULL,
  `huisNummer` VARCHAR(5) NOT NULL,
  `bus` VARCHAR(5) NULL,
  `plaatsId` INT NOT NULL,
  `actief` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`adresId`),
  INDEX `fk_Adressen_Plaatsen_idx` (`plaatsId` ASC),
  CONSTRAINT `fk_Adressen_Plaatsen`
    FOREIGN KEY (`plaatsId`)
    REFERENCES `PrulariaCom`.`Plaatsen` (`plaatsId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`Klanten`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`Klanten` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`Klanten` (
  `klantId` INT NOT NULL AUTO_INCREMENT,
  `facturatieAdresId` INT NOT NULL,
  `leveringsAdresId` INT NOT NULL,
  PRIMARY KEY (`klantId`),
  INDEX `fk_Klanten_Adressen1_idx` (`facturatieAdresId` ASC),
  INDEX `fk_Klanten_Adressen2_idx` (`leveringsAdresId` ASC),
  CONSTRAINT `fk_Klanten_Adressen1`
    FOREIGN KEY (`facturatieAdresId`)
    REFERENCES `PrulariaCom`.`Adressen` (`adresId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Klanten_Adressen2`
    FOREIGN KEY (`leveringsAdresId`)
    REFERENCES `PrulariaCom`.`Adressen` (`adresId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`GebruikersAccounts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`GebruikersAccounts` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`GebruikersAccounts` (
  `gebruikersAccountId` INT NOT NULL AUTO_INCREMENT,
  `emailadres` VARCHAR(45) NOT NULL,
  `paswoord` VARCHAR(255) NOT NULL,
  `disabled` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`gebruikersAccountId`),
  UNIQUE INDEX `gebrukersnaam_UNIQUE` (`emailadres` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`NatuurlijkePersonen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`NatuurlijkePersonen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`NatuurlijkePersonen` (
  `klantId` INT NOT NULL,
  `voornaam` VARCHAR(45) NOT NULL,
  `familienaam` VARCHAR(45) NOT NULL,
  `gebruikersAccountId` INT NOT NULL,
  PRIMARY KEY (`klantId`),
  INDEX `fk_PrivateKlanten_Klanten1_idx` (`klantId` ASC),
  INDEX `fk_NatuurlijkePersonen_gebruikersAccountId_idx` (`gebruikersAccountId` ASC),
  CONSTRAINT `fk_PrivateKlanten_Klanten1`
    FOREIGN KEY (`klantId`)
    REFERENCES `PrulariaCom`.`Klanten` (`klantId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_NatuurlijkePersonen_Gebruikersnamen1`
    FOREIGN KEY (`gebruikersAccountId`)
    REFERENCES `PrulariaCom`.`GebruikersAccounts` (`gebruikersAccountId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`Rechtspersonen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`Rechtspersonen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`Rechtspersonen` (
  `klantId` INT NOT NULL,
  `naam` VARCHAR(45) NOT NULL,
  `btwNummer` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`klantId`),
  CONSTRAINT `fk_Rechtspersonen_Klanten1`
    FOREIGN KEY (`klantId`)
    REFERENCES `PrulariaCom`.`Klanten` (`klantId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`Contactpersonen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`Contactpersonen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`Contactpersonen` (
  `contactpersoonId` INT NOT NULL AUTO_INCREMENT,
  `voornaam` VARCHAR(45) NOT NULL,
  `familienaam` VARCHAR(45) NOT NULL,
  `functie` VARCHAR(45) NOT NULL,
  `klantId` INT NOT NULL,
  `gebruikersAccountId` INT NOT NULL,
  PRIMARY KEY (`contactpersoonId`),
  INDEX `fk_Contactpersonen_Rechtspersonen1_idx` (`klantId` ASC),
  INDEX `fk_Contactpersonen_GebruikersAccounts_idx` (`gebruikersAccountId` ASC),
  CONSTRAINT `fk_Contactpersonen_Rechtspersonen1`
    FOREIGN KEY (`klantId`)
    REFERENCES `PrulariaCom`.`Rechtspersonen` (`klantId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Contactpersonen_GebruikersAccounts1`
    FOREIGN KEY (`gebruikersAccountId`)
    REFERENCES `PrulariaCom`.`GebruikersAccounts` (`gebruikersAccountId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`Categorieen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`Categorieen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`Categorieen` (
  `categorieId` INT NOT NULL AUTO_INCREMENT,
  `naam` VARCHAR(45) NOT NULL,
  `hoofdCategorieId` INT NULL,
  PRIMARY KEY (`categorieId`),
  INDEX `fk_Categorieen_Categorieen1_idx` (`hoofdCategorieId` ASC),
  CONSTRAINT `fk_Categorieen_Categorieen1`
    FOREIGN KEY (`hoofdCategorieId`)
    REFERENCES `PrulariaCom`.`Categorieen` (`categorieId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `PrulariaCom`.`Leveranciers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`Leveranciers` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`Leveranciers` (
  `leveranciersId` INT NOT NULL AUTO_INCREMENT,
  `naam` VARCHAR(45) NOT NULL,
  `btwNummer` VARCHAR(45) NOT NULL,
  `straat` VARCHAR(45) NOT NULL,
  `huisNummer` VARCHAR(5) NOT NULL,
  `bus` VARCHAR(5) NULL,
  `plaatsId` INT NOT NULL,
  `familienaamContactpersoon` VARCHAR(45) NOT NULL,
  `voornaamContactpersoon` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`leveranciersId`),
  INDEX `fk_Leveranciers_Plaatsen1_idx` (`plaatsId` ASC),
  CONSTRAINT `fk_Leveranciers_Plaatsen1`
    FOREIGN KEY (`plaatsId`)
    REFERENCES `PrulariaCom`.`Plaatsen` (`plaatsId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `PrulariaCom`.`Artikelen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`Artikelen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`Artikelen` (
  `artikelId` INT NOT NULL AUTO_INCREMENT,
  `ean` VARCHAR(13) NOT NULL,
  `naam` VARCHAR(45) NOT NULL,
  `beschrijving` VARCHAR(255) NOT NULL,
  `prijs` DECIMAL(18,5) NOT NULL,
  `gewichtInGram` INT NOT NULL,
  `bestelpeil` INT NOT NULL DEFAULT 0,
  `voorraad` INT NOT NULL DEFAULT 0,
  `minimumVoorraad` INT NOT NULL DEFAULT 0,
  `maximumVoorraad` INT NOT NULL DEFAULT 0,
  `levertijd` INT NOT NULL DEFAULT 1,
  `aantalBesteldLeverancier` INT NOT NULL DEFAULT 0,
  `maxAantalInMagazijnPLaats` INT NOT NULL DEFAULT 0,
  `leveranciersId` INT NOT NULL,
  PRIMARY KEY (`artikelId`),
  UNIQUE INDEX `ean_UNIQUE` (`ean` ASC),
  CONSTRAINT `fk_Artikelen_Leveranciers`
    FOREIGN KEY (`leveranciersId`)
    REFERENCES `PrulariaCom`.`Leveranciers` (`leveranciersId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`ArtikelCategorieen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`ArtikelCategorieen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`ArtikelCategorieen` (
  `categorieId` INT NOT NULL,
  `artikelId` INT NOT NULL,
  PRIMARY KEY (`categorieId`, `artikelId`),
  INDEX `fk_ArtikelCategorieen_Artikelen1_idx` (`artikelId` ASC),
  CONSTRAINT `fk_ArtikelCategorieen_Categorieen1`
    FOREIGN KEY (`categorieId`)
    REFERENCES `PrulariaCom`.`Categorieen` (`categorieId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ArtikelCategorieen_Artikelen1`
    FOREIGN KEY (`artikelId`)
    REFERENCES `PrulariaCom`.`Artikelen` (`artikelId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`Betaalwijzes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`Betaalwijzes` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`Betaalwijzes` (
  `betaalwijzeId` INT NOT NULL AUTO_INCREMENT,
  `naam` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`betaalwijzeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`BestellingsStatussen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`BestellingsStatussen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`BestellingsStatussen` (
  `bestellingsStatusId` INT NOT NULL AUTO_INCREMENT,
  `naam` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`bestellingsStatusId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`Bestellingen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`Bestellingen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`Bestellingen` (
  `bestelId` INT NOT NULL AUTO_INCREMENT,
  `besteldatum` DATETIME NOT NULL,
  `klantId` INT NOT NULL,
  `betaald` TINYINT(1) NOT NULL DEFAULT 0,
  `betalingscode` VARCHAR(45) NULL,
  `betaalwijzeId` INT NOT NULL,
  `annulatie` TINYINT(1) NOT NULL DEFAULT 0,
  `annulatiedatum` DATE NULL,
  `terugbetalingscode` VARCHAR(45) NULL,
  `bestellingsStatusId` INT NOT NULL,
  `actiecodeGebruikt` TINYINT(1) NOT NULL DEFAULT 0,
  `bedrijfsnaam` VARCHAR(45) NULL,
  `btwNummer` VARCHAR(45) NULL,
  `voornaam` VARCHAR(45) NOT NULL,
  `familienaam` VARCHAR(45) NOT NULL,
  `facturatieAdresId` INT NOT NULL,
  `leveringsAdresId` INT NOT NULL,
  PRIMARY KEY (`bestelId`),
  INDEX `fk_Bestellingen_Betaalwijzes1_idx` (`betaalwijzeId` ASC),
  INDEX `fk_Bestellingen_Klanten1_idx` (`klantId` ASC),
  INDEX `fk_Bestellingen_BestellingsStatussen1_idx` (`bestellingsStatusId` ASC),
  INDEX `fk_Bestellingen_Adressen1_idx` (`facturatieAdresId` ASC),
  INDEX `fk_Bestellingen_Adressen2_idx` (`leveringsAdresId` ASC),
  CONSTRAINT `fk_Bestellingen_Betaalwijzes1`
    FOREIGN KEY (`betaalwijzeId`)
    REFERENCES `PrulariaCom`.`Betaalwijzes` (`betaalwijzeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bestellingen_Klanten1`
    FOREIGN KEY (`klantId`)
    REFERENCES `PrulariaCom`.`Klanten` (`klantId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bestellingen_BestellingsStatussen1`
    FOREIGN KEY (`bestellingsStatusId`)
    REFERENCES `PrulariaCom`.`BestellingsStatussen` (`bestellingsStatusId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bestellingen_Adressen1`
    FOREIGN KEY (`facturatieAdresId`)
    REFERENCES `PrulariaCom`.`Adressen` (`adresId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bestellingen_Adressen2`
    FOREIGN KEY (`leveringsAdresId`)
    REFERENCES `PrulariaCom`.`Adressen` (`adresId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `PrulariaCom`.`Bestellijnen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`Bestellijnen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`Bestellijnen` (
  `bestellijnId` INT NOT NULL AUTO_INCREMENT,
  `bestelId` INT NOT NULL,
  `artikelId` INT NOT NULL,
  `aantalBesteld` INT NOT NULL,
  `aantalGeannuleerd` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`bestellijnId`),
  INDEX `fk_Bestellijnen_Bestellingen1_idx` (`bestelId` ASC),
  INDEX `fk_Bestellijnen_Artikelen1_idx` (`artikelId` ASC),
  CONSTRAINT `fk_Bestellijnen_Bestellingen1`
    FOREIGN KEY (`bestelId`)
    REFERENCES `PrulariaCom`.`Bestellingen` (`bestelId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bestellijnen_Artikelen1`
    FOREIGN KEY (`artikelId`)
    REFERENCES `PrulariaCom`.`Artikelen` (`artikelId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`UitgaandeLeveringsStatussen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`UitgaandeLeveringsStatussen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`UitgaandeLeveringsStatussen` (
  `uitgaandeLeveringsStatusId` INT NOT NULL AUTO_INCREMENT,
  `naam` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`uitgaandeLeveringsStatusId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`UitgaandeLeveringen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`UitgaandeLeveringen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`UitgaandeLeveringen` (
  `uitgaandeLeveringsId` INT NOT NULL AUTO_INCREMENT,
  `bestelId` INT NOT NULL,
  `vertrekDatum` DATE NOT NULL,
  `aankomstDatum` DATE NULL,
  `trackingcode` VARCHAR(45) NOT NULL,
  `klantId` INT NOT NULL,
  `uitgaandeLeveringsStatusId` INT NOT NULL,
  PRIMARY KEY (`uitgaandeLeveringsId`),
  INDEX `fk_UitgaandeLeveringen_Klanten1_idx` (`klantId` ASC),
  INDEX `fk_UitgaandeLeveringen_UitgaandeLeveringsStatussn1_idx` (`uitgaandeLeveringsStatusId` ASC),
  INDEX `fk_UitgaandeLeveringen_Bestellingen1_idx` (`bestelId` ASC),
  CONSTRAINT `fk_UitgaandeLeveringen_Klanten1`
    FOREIGN KEY (`klantId`)
    REFERENCES `PrulariaCom`.`Klanten` (`klantId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_UitgaandeLeveringen_UitgaandeLeveringsStatussn1`
    FOREIGN KEY (`uitgaandeLeveringsStatusId`)
    REFERENCES `PrulariaCom`.`UitgaandeLeveringsStatussen` (`uitgaandeLeveringsStatusId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_UitgaandeLeveringen_Bestellingen1`
    FOREIGN KEY (`bestelId`)
    REFERENCES `PrulariaCom`.`Bestellingen` (`bestelId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`KlantenReviews`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`KlantenReviews` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`KlantenReviews` (
  `klantenReviewId` INT NOT NULL AUTO_INCREMENT,
  `nickname` VARCHAR(45) NOT NULL,
  `score` INT NOT NULL,
  `commentaar` VARCHAR(255) NULL,
  `datum` DATE NOT NULL,
  `bestellijnId` INT NOT NULL,
  PRIMARY KEY (`klantenReviewId`),
  INDEX `fk_KlantenReviews_Bestellijnen1_idx` (`bestellijnId` ASC),
  CONSTRAINT `fk_KlantenReviews_Bestellijnen1`
    FOREIGN KEY (`bestellijnId`)
    REFERENCES `PrulariaCom`.`Bestellijnen` (`bestellijnId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`VeelgesteldeVragenArtikels`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`VeelgesteldeVragenArtikels` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`VeelgesteldeVragenArtikels` (
  `veelgesteldeVragenArtikelId` INT NOT NULL AUTO_INCREMENT,
  `artikelId` INT NOT NULL,
  `vraag` VARCHAR(255) NOT NULL,
  `antwoord` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`veelgesteldeVragenArtikelId`),
  INDEX `fk_VeelgesteldeVragenArtikels_Artikelen1_idx` (`artikelId` ASC),
  CONSTRAINT `fk_VeelgesteldeVragenArtikels_Artikelen1`
    FOREIGN KEY (`artikelId`)
    REFERENCES `PrulariaCom`.`Artikelen` (`artikelId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`MagazijnPlaatsen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`MagazijnPlaatsen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`MagazijnPlaatsen` (
  `magazijnPlaatsId` INT NOT NULL AUTO_INCREMENT,
  `artikelId` INT NULL,
  `rij` CHAR NOT NULL,
  `rek` INT NOT NULL,
  `aantal` INT NOT NULL,
  PRIMARY KEY (`magazijnPlaatsId`),
  INDEX `fk_MagazijnPlaatsen_Artikelen1_idx` (`artikelId` ASC),
  UNIQUE INDEX `uinx_rijrek` (`rij` ASC, `rek` ASC),
  CONSTRAINT `fk_MagazijnPlaatsen_Artikelen1`
    FOREIGN KEY (`artikelId`)
    REFERENCES `PrulariaCom`.`Artikelen` (`artikelId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`SecurityGroepen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`SecurityGroepen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`SecurityGroepen` (
  `securityGroepId` INT NOT NULL AUTO_INCREMENT,
  `naam` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`securityGroepId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`PersoneelslidAccounts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`PersoneelslidAccounts` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`PersoneelslidAccounts` (
  `personeelslidAccountId` INT NOT NULL AUTO_INCREMENT,
  `emailadres` VARCHAR(45) NOT NULL,
  `paswoord` VARCHAR(255) NOT NULL,
  `disabled` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`personeelslidAccountId`),
  UNIQUE INDEX `emailadres_UNIQUE` (`emailadres` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`Personeelsleden`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`Personeelsleden` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`Personeelsleden` (
  `personeelslidId` INT NOT NULL AUTO_INCREMENT,
  `voornaam` VARCHAR(45) NOT NULL,
  `familienaam` VARCHAR(45) NOT NULL,
  `inDienst` TINYINT(1) NOT NULL DEFAULT 1,
  `personeelslidAccountId` INT NOT NULL,
  PRIMARY KEY (`personeelslidId`),
  INDEX `fk_Personeelsleden_PersoneelslidAccounts1_idx` (`personeelslidAccountId` ASC),
  CONSTRAINT `fk_Personeelsleden_PersoneelslidAccounts1`
    FOREIGN KEY (`personeelslidAccountId`)
    REFERENCES `PrulariaCom`.`PersoneelslidAccounts` (`personeelslidAccountId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`PersoneelslidSecurityGroepen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`PersoneelslidSecurityGroepen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`PersoneelslidSecurityGroepen` (
  `personeelslidId` INT NOT NULL,
  `securityGroepId` INT NOT NULL,
  PRIMARY KEY (`personeelslidId`, `securityGroepId`),
  INDEX `fk_PersoneelslidSecurityGroepen_SecurityGroepen1_idx` (`securityGroepId` ASC),
  CONSTRAINT `fk_PersoneelslidSecurityGroepen_Personeelsleden1`
    FOREIGN KEY (`personeelslidId`)
    REFERENCES `PrulariaCom`.`Personeelsleden` (`personeelslidId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PersoneelslidSecurityGroepen_SecurityGroepen1`
    FOREIGN KEY (`securityGroepId`)
    REFERENCES `PrulariaCom`.`SecurityGroepen` (`securityGroepId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;





-- -----------------------------------------------------
-- Table `PrulariaCom`.`InkomendeLeveringen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`InkomendeLeveringen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`InkomendeLeveringen` (
  `inkomendeLeveringsId` INT NOT NULL AUTO_INCREMENT,
  `leveranciersId` INT NOT NULL,
  `leveringsbonNummer` VARCHAR(45) NOT NULL,
  `leveringsbondatum` DATE NOT NULL,
  `leverDatum` DATE NOT NULL,
  `ontvangerPersoneelslidId` INT NOT NULL,
  INDEX `fk_InkomendeLeveringen_Personeelsleden1_idx` (`ontvangerPersoneelslidId` ASC),
  PRIMARY KEY (`inkomendeLeveringsId`),
  CONSTRAINT `fk_InkomendeLeveringen_Leveranciers1`
    FOREIGN KEY (`leveranciersId`)
    REFERENCES `PrulariaCom`.`Leveranciers` (`leveranciersId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_InkomendeLeveringen_Personeelsleden1`
    FOREIGN KEY (`ontvangerPersoneelslidId`)
    REFERENCES `PrulariaCom`.`Personeelsleden` (`personeelslidId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`InkomendeLeveringsLijnen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`InkomendeLeveringsLijnen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`InkomendeLeveringsLijnen` (
  `inkomendeLeveringsId` INT NOT NULL,
  `artikelId` INT NOT NULL,
  `aantalGoedgekeurd` INT NOT NULL,
  `aantalTeruggestuurd` INT NOT NULL DEFAULT 0,
  `magazijnPlaatsId` INT not NULL,
  PRIMARY KEY (`inkomendeLeveringsId`, `artikelId`, `magazijnPlaatsId`),
  INDEX `fk_InkomendeLeverongsLijnen_Artikelen1_idx` (`artikelId` ASC),
  INDEX `fk_InkomendeLeverongsLijnen_MagazijnPlaatsen1_idx` (`magazijnPlaatsId` ASC),
  CONSTRAINT `fk_InkomendeLeverongsLijnen_InkomendeLeveringen1`
    FOREIGN KEY (`inkomendeLeveringsId`)
    REFERENCES `PrulariaCom`.`InkomendeLeveringen` (`inkomendeLeveringsId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_InkomendeLeverongsLijnen_Artikelen1`
    FOREIGN KEY (`artikelId`)
    REFERENCES `PrulariaCom`.`Artikelen` (`artikelId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_InkomendeLeverongsLijnen_MagazijnPlaatsen1`
    FOREIGN KEY (`magazijnPlaatsId`)
    REFERENCES `PrulariaCom`.`MagazijnPlaatsen` (`magazijnPlaatsId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`Actiecodes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`Actiecodes` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`Actiecodes` (
  `actiecodeId` INT NOT NULL AUTO_INCREMENT,
  `naam` VARCHAR(45) NOT NULL,
  `geldigVanDatum` DATE NOT NULL,
  `geldigTotDatum` DATE NOT NULL,
  `isEenmalig` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`actiecodeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`Chatgesprekken`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`Chatgesprekken` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`Chatgesprekken` (
  `chatgesprekId` INT NOT NULL AUTO_INCREMENT,
  `gebruikersAccountId` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`chatgesprekId`),
  INDEX `fk_ChatGesprekken_GebruikersAccounts1_idx` (`gebruikersAccountId` ASC),
  CONSTRAINT `fk_ChatGesprekken_GebruikersAccounts1`
    FOREIGN KEY (`gebruikersAccountId`)
    REFERENCES `PrulariaCom`.`GebruikersAccounts` (`gebruikersAccountId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`ArtikelLeveranciersInfoLijnen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`ArtikelLeveranciersInfoLijnen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`ArtikelLeveranciersInfoLijnen` (
  `artikelLeveranciersInfoLijnId` INT NOT NULL AUTO_INCREMENT,
  `artikelId` INT NOT NULL,
  `vraag` VARCHAR(255) NOT NULL,
  `antwoord` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`artikelLeveranciersInfoLijnId`, `artikelId`),
  INDEX `fk_ArtikelLeveranciersInfoLijnen_Artikelen1_idx` (`artikelId` ASC),
  CONSTRAINT `fk_ArtikelLeveranciersInfoLijnen_Artikelen1`
    FOREIGN KEY (`artikelId`)
    REFERENCES `PrulariaCom`.`Artikelen` (`artikelId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`ChatgesprekLijnen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`ChatgesprekLijnen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`ChatgesprekLijnen` (
  `chatgesprekLijnId` INT NOT NULL AUTO_INCREMENT,
  `chatgesprekId` INT NOT NULL,
  `bericht` VARCHAR(255) NOT NULL,
  `tijdstip` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gebruikersAccountId` INT NULL DEFAULT 0,
  `personeelslidAccountId` INT NULL DEFAULT 0,
  PRIMARY KEY (`chatgesprekLijnId`),
  INDEX `fk_ChatgesprekLijnen_ChatGesprekken1_idx` (`chatgesprekId` ASC),
  INDEX `fk_ChatgesprekLijnen_GebruikersAccounts1_idx` (`gebruikersAccountId` ASC),
  INDEX `fk_ChatgesprekLijnen_PersoneelslidAccounts1_idx` (`personeelslidAccountId` ASC),
  CONSTRAINT `fk_ChatgesprekLijnen_ChatGesprekken1`
    FOREIGN KEY (`chatgesprekId`)
    REFERENCES `PrulariaCom`.`Chatgesprekken` (`chatgesprekId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ChatgesprekLijnen_GebruikersAccounts1`
    FOREIGN KEY (`gebruikersAccountId`)
    REFERENCES `PrulariaCom`.`GebruikersAccounts` (`gebruikersAccountId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ChatgesprekLijnen_PersoneelslidAccounts1`
    FOREIGN KEY (`personeelslidAccountId`)
    REFERENCES `PrulariaCom`.`PersoneelslidAccounts` (`personeelslidAccountId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`WishListItems`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`WishListItems` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`WishListItems` (
  `wishListItemId` INT NOT NULL AUTO_INCREMENT,
  `artikelId` INT NOT NULL,
  `gebruikersAccountId` INT NOT NULL,
  `aanvraagDatum` DATE NOT NULL,
  `aantal` INT NOT NULL DEFAULT 1,
  `emailGestuurdDatum` DATE NULL,
  PRIMARY KEY (`wishListItemId`, `gebruikersAccountId`),
  INDEX `fk_WishListItems_Artikelen1_idx` (`artikelId` ASC),
  INDEX `fk_WishListItems_GebruikersAccounts1_idx` (`gebruikersAccountId` ASC),
  CONSTRAINT `fk_WishListItems_Artikelen1`
    FOREIGN KEY (`artikelId`)
    REFERENCES `PrulariaCom`.`Artikelen` (`artikelId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_WishListItems_GebruikersAccounts1`
    FOREIGN KEY (`gebruikersAccountId`)
    REFERENCES `PrulariaCom`.`GebruikersAccounts` (`gebruikersAccountId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PrulariaCom`.`EventWachtrijArtikelen`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PrulariaCom`.`EventWachtrijArtikelen` ;

CREATE TABLE IF NOT EXISTS `PrulariaCom`.`EventWachtrijArtikelen` (
  `artikelId` INT NOT NULL,
  `aantal` INT NOT NULL,
  `maxAantalInMagazijnPlaats` INT NOT NULL,
  PRIMARY KEY (`artikelId`))
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- functions

drop function if exists genereerEan;

delimiter |

create function genereerEan (id int) returns varchar(13) deterministic
begin
	declare eanValue varchar(13);
    declare i int default 1;
    declare cs int default 0;
    set eanValue = concat('5499999', lpad(id, 5, '0'));
    while (i <= 11) do
		set cs = cs + convert (substr(eanValue, i, 1), unsigned);
        set i = i + 2;
    end while;
    set i= 2; 
    while (i <= 12) do
		set cs = cs + (convert (substr(eanValue, i, 1), unsigned) * 3);
        set i = i + 2;
    end while;
    set eanValue = concat(eanValue,convert((10 - (cs mod 10)) mod 10, char));
    return eanValue;
end |

delimiter ;


-- select genereerEan(267);


-- triggers

use PrulariaCom;


drop trigger if exists insertTriggerUitgaandeleveringen;


delimiter |

create trigger insertTriggerUitgaandeleveringen before insert on UitgaandeLeveringen for each row
begin
set new.trackingcode = concat('ul',convert(from_unixtime(unix_timestamp()) + 0, char(14)));
update Bestellingen set bestellingsStatusId=5 where bestelId=new.bestelId;
end |

delimiter ;

drop trigger if exists updateTriggerUitgaandeleveringen;


delimiter |

create trigger updateTriggerUitgaandeleveringen before update on UitgaandeLeveringen for each row
begin
update Bestellingen set bestellingsStatusId=new.uitgaandeLeveringsStatusId + 4 where bestelid=new.bestelId;
end |

delimiter ;


drop trigger if exists insertTriggerBestellingen;

delimiter |

create TRIGGER insertTriggerBestellingen before insert on Bestellingen for each row
begin
	IF new.betaalwijzeId = 1 THEN
		set new.betalingscode = concat('K',convert(from_unixtime(unix_timestamp()) + 0, char(14)));
	ELSE
		set new.betalingscode = concat('O',convert(from_unixtime(unix_timestamp()) + 0, char(14)));
	END IF;    
    IF new.besteldatum = date(new.besteldatum) THEN
		set new.besteldatum = DATE_ADD(DATE_ADD(new.besteldatum, interval floor(RAND()*(hour(now())-1)+1) hour), interval -floor(RAND()*(60-1)+1) minute);
    END IF;
end |

delimiter ;


drop trigger if exists insertTriggerArtikelen;

delimiter |

create trigger insertTriggerArtikelen before insert on Artikelen for each row
begin
    declare eanValue varchar(13);
    declare i int default 1;
    declare cs int default 0;
    set eanValue = concat('5499999', lpad(If(new.artikelId>0, new.artikelId, (select max(artikelId)+1 from Artikelen)), 5, '0'));
    while (i <= 11) do
		set cs = cs + convert (substr(eanValue, i, 1), unsigned);
        set i = i + 2;
    end while;
    set i= 2; 
    while (i <= 12) do
		set cs = cs + (convert (substr(eanValue, i, 1), unsigned) * 3);
        set i = i + 2;
    end while;
    set eanValue = concat(eanValue,convert((10 - (cs mod 10)) mod 10, char));
	set new.ean=eanValue;    
end |

delimiter ;

-- gebruikers en rechten

-- gebruikers
drop user if exists 'DBAdmingebruiker'@'%';
drop user if exists 'Javagebruiker'@'%';
drop user if exists 'Cgebruiker'@'%';
drop user if exists 'PHPgebruiker'@'%';

create user 'DBAdmingebruiker'@'%' identified by 'PaswoordDBAdminScrum2020';
create user 'Javagebruiker'@'%' identified by 'PaswoordJavaScrum2020';
create user 'Cgebruiker'@'%' identified by 'PaswoordCsharpScrum2020';
create user 'PHPgebruiker'@'%' identified by 'PaswoordPHPScrum2020';

-- rechten
GRANT ALL PRIVILEGES ON PrulariaCom.* TO 'DBAdmingebruiker'@'%';

GRANT SELECT ON PrulariaCom.Plaatsen TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';

GRANT SELECT ON PrulariaCom.Adressen TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE ON PrulariaCom.Adressen TO 'Cgebruiker'@'%', 'PHPgebruiker'@'%', 'Javagebruiker'@'%';

GRANT SELECT ON PrulariaCom.Klanten TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.Klanten TO 'Cgebruiker'@'%', 'PHPgebruiker'@'%';

GRANT SELECT ON PrulariaCom.GebruikersAccounts TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.GebruikersAccounts TO 'Cgebruiker'@'%', 'PHPgebruiker'@'%';

GRANT SELECT, UPDATE ON PrulariaCom.PersoneelslidAccounts TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, DELETE ON PrulariaCom.PersoneelslidAccounts TO 'Cgebruiker'@'%';

GRANT SELECT ON PrulariaCom.NatuurlijkePersonen TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.NatuurlijkePersonen TO 'Cgebruiker'@'%', 'PHPgebruiker'@'%';

GRANT SELECT ON PrulariaCom.Rechtspersonen TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.Rechtspersonen TO 'Cgebruiker'@'%', 'PHPgebruiker'@'%';

GRANT SELECT ON PrulariaCom.Contactpersonen TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.Contactpersonen TO 'Cgebruiker'@'%', 'PHPgebruiker'@'%';

GRANT SELECT ON PrulariaCom.Categorieen TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.Categorieen TO 'Cgebruiker'@'%';

GRANT SELECT ON PrulariaCom.Categorieen TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.Categorieen TO 'Cgebruiker'@'%';

GRANT SELECT ON PrulariaCom.Artikelen TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, DELETE ON PrulariaCom.Artikelen TO 'Cgebruiker'@'%';
GRANT UPDATE (naam, beschrijving, prijs, gewichtingram, bestelpeil, voorraad, minimumvoorraad, maximumvoorraad, levertijd, aantalbesteldleverancier, maxAantalInMagazijnPLaats,leveranciersId) 
ON PrulariaCom.Artikelen  TO 'Javagebruiker'@'%', 'Cgebruiker'@'%';

GRANT SELECT, INSERT, UPDATE, DELETE ON PrulariaCom.EventWachtrijArtikelen TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';

GRANT SELECT ON PrulariaCom.ArtikelCategorieen TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.ArtikelCategorieen TO 'Cgebruiker'@'%';

GRANT SELECT ON PrulariaCom.Betaalwijzes TO 'Javagebruiker'@'%','Cgebruiker'@'%', 'PHPgebruiker'@'%';

GRANT SELECT ON PrulariaCom.BestellingsStatussen TO 'Javagebruiker'@'%','Cgebruiker'@'%', 'PHPgebruiker'@'%';

GRANT SELECT, INSERT, UPDATE ON PrulariaCom.Bestellingen TO 'Javagebruiker'@'%','Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE ON PrulariaCom.Bestellingen TO 'PHPgebruiker'@'%', 'Cgebruiker'@'%';
GRANT UPDATE (bestellingsStatusId) ON PrulariaCom.Bestellingen TO 'Javagebruiker'@'%';

GRANT SELECT, INSERT, UPDATE ON PrulariaCom.Bestellijnen TO 'Javagebruiker'@'%','Cgebruiker'@'%', 'PHPgebruiker'@'%';

GRANT SELECT ON PrulariaCom.UitgaandeLeveringsStatussen TO 'Javagebruiker'@'%','Cgebruiker'@'%', 'PHPgebruiker'@'%';

GRANT SELECT ON PrulariaCom.UitgaandeLeveringen TO 'Javagebruiker'@'%','Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.UitgaandeLeveringen TO 'Javagebruiker'@'%';

GRANT SELECT ON PrulariaCom.KlantenReviews TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT ON PrulariaCom.KlantenReviews TO 'PHPgebruiker'@'%';
GRANT DELETE ON PrulariaCom.KlantenReviews TO 'Cgebruiker'@'%';

GRANT SELECT ON PrulariaCom.VeelgesteldeVragenArtikels TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.VeelgesteldeVragenArtikels TO 'Cgebruiker'@'%';

GRANT SELECT ON PrulariaCom.MagazijnPlaatsen TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.MagazijnPlaatsen TO 'Javagebruiker'@'%';

GRANT SELECT ON PrulariaCom.SecurityGroepen TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';

GRANT SELECT ON PrulariaCom.Personeelsleden TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.Personeelsleden TO 'Cgebruiker'@'%';

GRANT SELECT ON PrulariaCom.PersoneelslidSecurityGroepen TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.PersoneelslidSecurityGroepen TO 'Cgebruiker'@'%';

GRANT SELECT ON PrulariaCom.Leveranciers TO 'Javagebruiker'@'%', 'PHPgebruiker'@'%', 'Cgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.Leveranciers TO 'Javagebruiker'@'%', 'Cgebruiker'@'%';

GRANT SELECT ON PrulariaCom.InkomendeLeveringen TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.InkomendeLeveringen TO 'Javagebruiker'@'%';

GRANT SELECT ON PrulariaCom.InkomendeLeveringsLijnen TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.InkomendeLeveringsLijnen TO 'Javagebruiker'@'%';

GRANT SELECT ON PrulariaCom.Actiecodes TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT DELETE ON PrulariaCom.Actiecodes TO 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.Actiecodes TO 'Cgebruiker'@'%';

GRANT SELECT ON PrulariaCom.Chatgesprekken TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.Chatgesprekken TO 'Cgebruiker'@'%', 'PHPgebruiker'@'%';

GRANT SELECT ON PrulariaCom.ArtikelLeveranciersInfoLijnen TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.ArtikelLeveranciersInfoLijnen TO 'Javagebruiker'@'%';

GRANT SELECT ON PrulariaCom.ChatgesprekLijnen TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.ChatgesprekLijnen TO 'Cgebruiker'@'%', 'PHPgebruiker'@'%';

GRANT SELECT ON PrulariaCom.WishListItems TO 'Javagebruiker'@'%', 'Cgebruiker'@'%', 'PHPgebruiker'@'%';
GRANT INSERT, UPDATE, DELETE ON PrulariaCom.WishListItems TO 'Javagebruiker'@'%', 'PHPgebruiker'@'%';

-- vaste data
use PrulariaCom;

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1,'2970','''S Gravenwezel'),
(2,'3700','''S Herenelderen'),
(3,'7510','3 Suisses'),
(4,'9420','Aaigem'),
(5,'8511','Aalbeke'),
(6,'3800','Aalst'),
(7,'9300','Aalst'),
(8,'9880','Aalter'),
(9,'3200','Aarschot'),
(10,'8700','Aarsele'),
(11,'8211','Aartrijke'),
(12,'2630','Aartselaar'),
(13,'4557','Abée'),
(14,'4280','Abolens'),
(15,'3930','Achel'),
(16,'5590','Achêne'),
(17,'5362','Achet'),
(18,'4219','Acosse'),
(19,'6280','Acoz'),
(20,'1105','ACTISOC'),
(21,'9991','Adegem'),
(22,'8660','Adinkerke'),
(23,'1790','Affligem'),
(24,'9051','Afsnee'),
(25,'5544','Agimont'),
(26,'4317','Aineffe'),
(27,'5310','Aische-En-Refail'),
(28,'6250','Aiseau'),
(29,'5070','Aisemont'),
(30,'3570','Alken'),
(31,'5550','Alle'),
(32,'4432','Alleur'),
(33,'1652','Alsemberg'),
(34,'8690','Alveringem'),
(35,'4540','Amay'),
(36,'6680','Amberloup'),
(37,'6953','Ambly'),
(38,'4219','Ambresin'),
(39,'4770','Amel'),
(40,'6997','Amonines'),
(41,'7750','Amougies'),
(42,'4540','Ampsin'),
(43,'5300','Andenne'),
(44,'1070','Anderlecht'),
(45,'6150','Anderlues'),
(46,'4821','Andrimont'),
(47,'4031','Angleur'),
(48,'7387','Angre'),
(49,'7387','Angreau'),
(50,'5537','Anhée');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(51,'6721','Anlier'),
(52,'6890','Anloy'),
(53,'5537','Annevoie-Rouillon'),
(54,'4430','Ans'),
(55,'5500','Anseremme'),
(56,'7750','Anseroeul'),
(57,'5520','Anthée'),
(58,'4520','Antheit'),
(59,'4160','Anthisnes'),
(60,'7640','Antoing'),
(61,'2000','Antwerpen'),
(62,'2018','Antwerpen'),
(63,'2020','Antwerpen'),
(64,'2030','Antwerpen'),
(65,'2040','Antwerpen'),
(66,'2050','Antwerpen'),
(67,'2060','Antwerpen'),
(68,'2099','Antwerpen X'),
(69,'7910','Anvaing'),
(70,'8570','Anzegem'),
(71,'9200','Appels'),
(72,'9400','Appelterre-Eichem'),
(73,'5170','Arbre'),
(74,'7811','Arbre'),
(75,'4990','Arbrefontaine'),
(76,'7910','Arc-Ainières'),
(77,'7910','Arc-Wattripont'),
(78,'1390','Archennes'),
(79,'8850','Ardooie'),
(80,'2370','Arendonk'),
(81,'4601','Argenteau'),
(82,'6700','Arlon'),
(83,'7181','Arquennes'),
(84,'5060','Arsimont'),
(85,'6870','Arville'),
(86,'3665','As'),
(87,'9404','Aspelare'),
(88,'9890','Asper'),
(89,'7040','Asquillies'),
(90,'1730','Asse'),
(91,'8310','Assebroek'),
(92,'1007','Assemble de la Commission Communautaire Française'),
(93,'9960','Assenede'),
(94,'6860','Assenois'),
(95,'3460','Assent'),
(96,'5330','Assesse'),
(97,'9800','Astene'),
(98,'7800','Ath'),
(99,'7387','Athis'),
(100,'6791','Athus');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(101,'3404','Attenhoven'),
(102,'3384','Attenrode'),
(103,'6717','Attert'),
(104,'7941','Attre'),
(105,'6790','Aubange'),
(106,'7972','Aubechies'),
(107,'4880','Aubel'),
(108,'5660','Aublain'),
(109,'6880','Auby-Sur-Semois'),
(110,'7382','Audregnies'),
(111,'7040','Aulnois'),
(112,'6706','Autelbas'),
(113,'1367','Autre-Eglise'),
(114,'7387','Autreppe'),
(115,'5060','Auvelais'),
(116,'5580','Ave-Et-Auffe'),
(117,'8630','Avekapelle'),
(118,'8580','Avelgem'),
(119,'4260','Avennes'),
(120,'3271','Averbode'),
(121,'4280','Avernas-Le-Bauduin'),
(122,'4280','Avin'),
(123,'4340','Awans'),
(124,'6870','Awenne'),
(125,'4400','Awirs'),
(126,'6900','Aye'),
(127,'4630','Ayeneux'),
(128,'4920','Aywaille'),
(129,'9890','Baaigem'),
(130,'3128','Baal'),
(131,'9310','Baardegem'),
(132,'2387','Baarle-Hertog'),
(133,'9200','Baasrode'),
(134,'9800','Bachte-Maria-Leerne'),
(135,'4837','Baelen'),
(136,'5550','Bagimont'),
(137,'6464','Baileux'),
(138,'6460','Bailièvre'),
(139,'5555','Baillamont'),
(140,'7730','Bailleul'),
(141,'5377','Baillonville'),
(142,'7380','Baisieux'),
(143,'1470','Baisy-Thy'),
(144,'5190','Balâtre'),
(145,'9860','Balegem'),
(146,'2490','Balen'),
(147,'9420','Bambrugge'),
(148,'6951','Bande'),
(149,'6500','Barben‡on'),
(150,'4671','Barchon');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(151,'5570','Baronville'),
(152,'7534','Barry'),
(153,'5370','Barvaux-Condroz'),
(154,'6940','Barvaux-Sur-Ourthe'),
(155,'4520','Bas-Oha'),
(156,'7971','Basècles'),
(157,'4983','Basse-Bodeux'),
(158,'4690','Bassenge'),
(159,'9968','Bassevelde'),
(160,'7830','Bassilly'),
(161,'6600','Bastogne'),
(162,'3870','Batsheers'),
(163,'4651','Battice'),
(164,'7130','Battignies'),
(165,'7331','Baudour'),
(166,'7870','Bauffe'),
(167,'7604','Baugnies'),
(168,'1401','Baulers'),
(169,'9520','Bavegem'),
(170,'8531','Bavikhove'),
(171,'9150','Bazel'),
(172,'4052','Beaufays'),
(173,'6500','Beaumont'),
(174,'5570','Beauraing'),
(175,'6980','Beausaint'),
(176,'1320','Beauvechain'),
(177,'6594','Beauwelz'),
(178,'7532','Béclers'),
(179,'3960','Beek'),
(180,'9630','Beerlegem'),
(181,'8730','Beernem'),
(182,'2340','Beerse'),
(183,'1650','Beersel'),
(184,'8600','Beerst'),
(185,'1673','Beert'),
(186,'9080','Beervelde'),
(187,'2580','Beerzel'),
(188,'5000','Beez'),
(189,'6987','Beffe'),
(190,'3130','Begijnendijk'),
(191,'6672','Beho'),
(192,'1852','Beigem'),
(193,'8480','Bekegem'),
(194,'1730','Bekkerzeel'),
(195,'3460','Bekkevoort'),
(196,'1009','Belgische Senaat'),
(197,'5001','Belgrade'),
(198,'4610','Bellaire'),
(199,'7170','Bellecourt'),
(200,'5555','Bellefontaine'),
(201,'6730','Bellefontaine'),
(202,'8510','Bellegem'),
(203,'9881','Bellem'),
(204,'6834','Bellevaux'),
(205,'4960','Bellevaux-Ligneuville'),
(206,'1674','Bellingen'),
(207,'7970','Beloeil'),
(208,'9111','Belsele'),
(209,'4500','Ben-Ahin'),
(210,'6941','Bende'),
(211,'3540','Berbroek'),
(212,'2600','Berchem'),
(213,'9690','Berchem'),
(214,'2040','Berendrecht'),
(215,'1910','Berg'),
(216,'3700','Berg'),
(217,'4360','Bergilers'),
(218,'3580','Beringen'),
(219,'2590','Berlaar'),
(220,'9290','Berlare'),
(221,'3830','Berlingen'),
(222,'4257','Berloz'),
(223,'4607','Berneau'),
(224,'7320','Bernissart'),
(225,'6560','Bersillies-L''Abbaye'),
(226,'3060','Bertem'),
(227,'6687','Bertogne'),
(228,'4280','Bertr‚e'),
(229,'6880','Bertrix'),
(230,'5651','Berz‚e'),
(231,'8980','Beselare'),
(232,'3130','Betekom'),
(233,'4300','Bettincourt'),
(234,'5030','Beuzet'),
(235,'2560','Bevel'),
(236,'1547','Bever'),
(237,'4960','Beverc‚'),
(238,'9700','Bevere'),
(239,'8791','Beveren'),
(240,'8800','Beveren'),
(241,'8691','Beveren-Aan-De-Ijzer'),
(242,'9120','Beveren-Waas'),
(243,'3581','Beverlo'),
(244,'3740','Beverst'),
(245,'4610','Beyne-Heusay'),
(246,'6543','Bienne-Lez-Happart'),
(247,'3360','Bierbeek'),
(248,'6533','Biercée'),
(249,'1301','Bierges'),
(250,'1430','Bierghes');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(251,'4460','Bierset'),
(252,'5380','Bierwart'),
(253,'5640','Biesme'),
(254,'6531','Biesme-Sous-Thuin'),
(255,'5640','Biesmerée'),
(256,'5555','Bièvre'),
(257,'1390','Biez'),
(258,'6690','Bihain'),
(259,'8920','Bikschote'),
(260,'4831','Bilstain'),
(261,'3740','Bilzen'),
(262,'7130','Binche'),
(263,'3850','Binderveld'),
(264,'3211','Binkom'),
(265,'5537','Bioul'),
(266,'8501','Bissegem'),
(267,'7783','Bizet'),
(268,'2830','Blaasveld'),
(269,'5542','Blaimont'),
(270,'7522','Blandain'),
(271,'3052','Blanden'),
(272,'8370','Blankenberge'),
(273,'7040','Blaregnies'),
(274,'7321','Blaton'),
(275,'7370','Blaugies'),
(276,'4670','Blégny'),
(277,'7620','Bléharies'),
(278,'4280','Blehen'),
(279,'6760','Bleid'),
(280,'4300','Bleret'),
(281,'7903','Blicquy'),
(282,'3950','Bocholt'),
(283,'4537','Bodegnée'),
(284,'2530','Boechout'),
(285,'3890','Boekhout'),
(286,'9961','Boekhoute'),
(287,'4250','Boëlhe'),
(288,'8904','Boezinge'),
(289,'1670','Bogaarden'),
(290,'5550','Bohan'),
(291,'5140','Boignée'),
(292,'4690','Boirs'),
(293,'7170','Bois-D''Haine'),
(294,'7866','Bois-De-Lessines'),
(295,'5170','Bois-De-Villers'),
(296,'4560','Bois-Et-Borsu'),
(297,'5310','Bolinne'),
(298,'4653','Bolland'),
(299,'1367','Bomal'),
(300,'6941','Bomal-Sur-Ourthe');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(301,'4607','Bombaye'),
(302,'3840','Bommershoven'),
(303,'7603','Bon-Secours'),
(304,'4100','Boncelles'),
(305,'5310','Boneffe'),
(306,'2820','Bonheiden'),
(307,'5021','Boninne'),
(308,'1325','Bonlez'),
(309,'6700','Bonnert'),
(310,'5300','Bonneville'),
(311,'5377','Bonsin'),
(312,'2221','Booischot'),
(313,'8630','Booitshoeke'),
(314,'2850','Boom'),
(315,'3631','Boorsem'),
(316,'3190','Boortmeerbeek'),
(317,'1761','Borchtlombeek'),
(318,'2140','Borgerhout'),
(319,'3840','Borgloon'),
(320,'4317','Borlez'),
(321,'3891','Borlo'),
(322,'6941','Borlon'),
(323,'2880','Bornem'),
(324,'1404','Bornival'),
(325,'2150','Borsbeek'),
(326,'9552','Borsbeke'),
(327,'5032','Bossière'),
(328,'8583','Bossuit'),
(329,'1390','Bossut-Gottechain'),
(330,'3300','Bost'),
(331,'5032','Bothey'),
(332,'9820','Bottelare'),
(333,'6200','Bouffioulx'),
(334,'5004','Bouge'),
(335,'7040','Bougnies'),
(336,'6830','Bouillon'),
(337,'6464','Bourlers'),
(338,'5575','Bourseigne-Neuve'),
(339,'5575','Bourseigne-Vieille'),
(340,'7110','Boussoit'),
(341,'7300','Boussu'),
(342,'5660','Boussu-En-Fagne'),
(343,'6440','Boussu-Lez-Walcourt'),
(344,'1470','Bousval'),
(345,'3370','Boutersem'),
(346,'5500','Bouvignes-Sur-Meuse'),
(347,'7803','Bouvignies'),
(348,'2288','Bouwel'),
(349,'8680','Bovekerke'),
(350,'3870','Bovelingen');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(351,'4300','Bovenistier'),
(352,'5081','Bovesse'),
(353,'6671','Bovigny'),
(354,'4990','Bra'),
(355,'7604','Braffe'),
(356,'5590','Braibant'),
(357,'1420','Braine-L''Alleud'),
(358,'1440','Braine-Le-Château'),
(359,'7090','Braine-Le-Comte'),
(360,'4260','Braives'),
(361,'9660','Brakel'),
(362,'5310','Branchon'),
(363,'6800','Bras'),
(364,'7604','Brasm‚nil'),
(365,'2930','Brasschaat'),
(366,'7130','Bray'),
(367,'2960','Brecht'),
(368,'8450','Bredene'),
(369,'3960','Bree'),
(370,'2870','Breendonk'),
(371,'4020','Bressoux'),
(372,'8900','Brielen'),
(373,'2520','Broechem'),
(374,'3840','Broekom'),
(375,'1931','Brucargo'),
(376,'7940','Brugelette'),
(377,'8000','Brugge'),
(378,'5660','Brûly'),
(379,'5660','Brûly-De-Pesche'),
(380,'1785','Brussegem'),
(381,'1000','Brussel'),
(382,'1099','Brussel X'),
(383,'3800','Brustem'),
(384,'7641','Bruyelle'),
(385,'6222','Brye'),
(386,'3440','Budingen'),
(387,'9255','Buggenhout'),
(388,'7911','Buissenal'),
(389,'5580','Buissonville'),
(390,'1501','Buizingen'),
(391,'1910','Buken'),
(392,'8630','Bulskamp'),
(393,'3380','Bunsbeek'),
(394,'2070','Burcht'),
(395,'4210','Burdinne'),
(396,'6927','Bure'),
(397,'9420','Burst'),
(398,'7602','Bury'),
(399,'4750','Butgenbach'),
(400,'3891','Buvingen');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(401,'7133','Buvrinnes'),
(402,'6743','Buzenol'),
(403,'6230','Buzet'),
(404,'4760','Büllingen'),
(405,'7604','Callenelle'),
(406,'7642','Calonne'),
(407,'7940','Cambron-Casteau'),
(408,'7870','Cambron-Saint-Vincent'),
(409,'1804','Cargovil'),
(410,'6850','Carlsbourg'),
(411,'7141','Carnières'),
(412,'7061','Casteau'),
(413,'5650','Castillon'),
(414,'4317','Celles'),
(415,'5561','Celles'),
(416,'7760','Celles'),
(417,'4632','Cérexhe-Heuseux'),
(418,'5630','Cerfontaine'),
(419,'1341','Céroux-Mousty'),
(420,'4650','Chaineux'),
(421,'5550','Chairière'),
(422,'5020','Champion'),
(423,'6971','Champlon'),
(424,'6921','Chanly'),
(425,'6742','Chantemelle'),
(426,'7903','Chapelle-À-Oie'),
(427,'7903','Chapelle-À-Wattines'),
(428,'7160','Chapelle-Lez-Herlaimont'),
(429,'4537','Chapon-Seraing'),
(430,'6000','Charleroi'),
(431,'6099','Charleroi X'),
(432,'4654','Charneux'),
(433,'6824','Chassepierre'),
(434,'1450','Chastre-Villeroux-Blanmont'),
(435,'5650','Chastrès'),
(436,'6200','Châtelet'),
(437,'6200','Châtelineau'),
(438,'6747','Châtillon'),
(439,'4050','Chaudfontaine'),
(440,'1325','Chaumont-Gistoux'),
(441,'7063','Chauss‚e-Notre-Dame-Louvignies'),
(442,'4032','Chênée'),
(443,'6673','Cherain'),
(444,'4602','Cheratte'),
(445,'7521','Chercq'),
(446,'5590','Chevetogne'),
(447,'4987','Chevron'),
(448,'7950','Chièvres'),
(449,'6460','Chimay'),
(450,'6810','Chiny');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(451,'4400','Chokier'),
(452,'1031','Christelijke Sociale Organisaties'),
(453,'5560','Ciergnon'),
(454,'5590','Ciney'),
(455,'4260','Ciplet'),
(456,'7024','Ciply'),
(457,'1480','Clabecq'),
(458,'4560','Clavier'),
(459,'4890','Clermont'),
(460,'5650','Clermont'),
(461,'4480','Clermont-Sous-Huy'),
(462,'5022','Cognelée'),
(463,'7340','Colfontaine'),
(464,'4170','Comblain-Au-Pont'),
(465,'4180','Comblain-Fairon'),
(466,'4180','Comblain-La-Tour'),
(467,'5590','Conneux'),
(468,'1435','Corbais'),
(469,'6838','Corbion'),
(470,'7910','Cordes'),
(471,'5620','Corenne'),
(472,'4860','Cornesse'),
(473,'5555','Cornimont'),
(474,'1935','Corporate Village'),
(475,'5032','Corroy-Le-Château'),
(476,'1325','Corroy-Le-Grand'),
(477,'4257','Corswarem'),
(478,'1450','Cortil-Noirmont'),
(479,'5380','Cortil-Wodon'),
(480,'6010','Couillet'),
(481,'6120','Cour-Sur-Heure'),
(482,'6180','Courcelles'),
(483,'5336','Courrière'),
(484,'1490','Court-Saint-Etienne'),
(485,'4218','Couthuin'),
(486,'5300','Coutisse'),
(487,'1380','Couture-Saint-Germain'),
(488,'5660','Couvin'),
(489,'4280','Cras-Avernas'),
(490,'4280','Crehen'),
(491,'4367','Crisn‚e'),
(492,'7120','Croix-Lez-Rouveroy'),
(493,'4784','Crombach'),
(494,'5332','Crupet'),
(495,'6075','CSM Charleroi X'),
(496,'9075','CSM Gent X'),
(497,'7033','Cuesmes'),
(498,'6880','Cugnon'),
(499,'5660','Cul-Des-Sarts'),
(500,'5562','Custinne');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(501,'8890','Dadizele'),
(502,'5660','Dailly'),
(503,'9160','Daknam'),
(504,'4607','Dalhem'),
(505,'8340','Damme'),
(506,'6767','Dampicourt'),
(507,'6020','Dampremy'),
(508,'7512','DANIEL JOUVANCE'),
(509,'4253','Darion'),
(510,'5630','Daussois'),
(511,'5020','Daussoulx'),
(512,'5100','Dave'),
(513,'6929','Daverdisse'),
(514,'8420','De Haan'),
(515,'9170','De Klinge'),
(516,'8630','De Moeren'),
(517,'8660','De Panne'),
(518,'9840','De Pinte'),
(519,'8540','Deerlijk'),
(520,'9570','Deftinge'),
(521,'9800','Deinze'),
(522,'9280','Denderbelle'),
(523,'9450','Denderhoutem'),
(524,'9470','Denderleeuw'),
(525,'9200','Dendermonde'),
(526,'9400','Denderwindeke'),
(527,'5537','Denée'),
(528,'8720','Dentergem'),
(529,'7912','Dergneau'),
(530,'2480','Dessel'),
(531,'8792','Desselgem'),
(532,'9070','Destelbergen'),
(533,'9042','Desteldonk'),
(534,'9831','Deurle'),
(535,'2100','Deurne'),
(536,'3290','Deurne'),
(537,'7864','Deux-Acren'),
(538,'5310','Dhuy'),
(539,'1831','Diegem'),
(540,'3590','Diepenbeek'),
(541,'3290','Diest'),
(542,'3700','Diets-Heur'),
(543,'8900','Dikkebus'),
(544,'9630','Dikkele'),
(545,'9890','Dikkelvenne'),
(546,'8600','Diksmuide'),
(547,'1700','Dilbeek'),
(548,'3650','Dilsen'),
(549,'3650','Dilsen-Stokkem'),
(550,'5500','Dinant');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(551,'5570','Dion'),
(552,'1325','Dion-Valmont'),
(553,'4820','Dison'),
(554,'6960','Dochamps'),
(555,'9130','Doel'),
(556,'6836','Dohan'),
(557,'5680','Doische'),
(558,'4140','Dolembreux'),
(559,'4357','Donceel'),
(560,'1370','Dongelberg'),
(561,'3540','Donk'),
(562,'6536','Donstiennes'),
(563,'5530','Dorinne'),
(564,'3440','Dormaal'),
(565,'7711','Dottenijs'),
(566,'7370','Dour'),
(567,'5670','Dourbes'),
(568,'8951','Dranouter'),
(569,'5500','Dréhance'),
(570,'8600','Driekapellen'),
(571,'3350','Drieslinter'),
(572,'1620','Drogenbos'),
(573,'9031','Drongen'),
(574,'8380','Dudzele'),
(575,'2570','Duffel'),
(576,'3080','Duisburg'),
(577,'3803','Duras'),
(578,'6940','Durbuy'),
(579,'5530','Durnal'),
(580,'1653','Dworp'),
(581,'4690','Eben-Emael'),
(582,'6860','Ebly'),
(583,'7190','Ecaussinnes-D''Enghien'),
(584,'7191','Ecaussinnes-Lalaing'),
(585,'2650','Edegem'),
(586,'9700','Edelare'),
(587,'7850','Edingen'),
(588,'9900','Eeklo'),
(589,'8480','Eernegem'),
(590,'8740','Egem'),
(591,'8630','Eggewaartskapelle'),
(592,'5310','Eghez‚e'),
(593,'4120','Ehein'),
(594,'4480','Ehein'),
(595,'3740','Eigenbilzen'),
(596,'2430','Eindhout'),
(597,'9700','Eine'),
(598,'3630','Eisden'),
(599,'9810','Eke'),
(600,'2180','Ekeren');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(601,'9160','Eksaarde'),
(602,'3941','Eksel'),
(603,'3650','Elen'),
(604,'9620','Elene'),
(605,'1982','Elewijt'),
(606,'3400','Eliksem'),
(607,'1671','Elingen'),
(608,'4590','Ellemelle'),
(609,'7890','Ellezelles'),
(610,'7910','Ellignies-Lez-Frasnes'),
(611,'7972','Ellignies-Sainte-Anne'),
(612,'3670','Ellikom'),
(613,'7370','Elouges'),
(614,'9790','Elsegem'),
(615,'4750','Elsenborn'),
(616,'1050','Elsene'),
(617,'9660','Elst'),
(618,'8906','Elverdinge'),
(619,'9140','Elversele'),
(620,'2520','Emblem'),
(621,'4053','Embourg'),
(622,'8870','Emelgem'),
(623,'5080','Emines'),
(624,'5363','Emptinne'),
(625,'9700','Ename'),
(626,'3800','Engelmanshoven'),
(627,'4480','Engis'),
(628,'1350','Enines'),
(629,'4800','Ensival'),
(630,'7134','Epinois'),
(631,'1980','Eppegem'),
(632,'5580','Eprave'),
(633,'7050','Erbaut'),
(634,'7050','Erbisoeul'),
(635,'7500','Ere'),
(636,'9320','Erembodegem'),
(637,'6997','Erezée'),
(638,'5644','Ermeton-Sur-Biert'),
(639,'5030','Ernage'),
(640,'6972','Erneuville'),
(641,'4920','Ernonheid'),
(642,'9420','Erondegem'),
(643,'9420','Erpe'),
(644,'5101','Erpent'),
(645,'6441','Erpion'),
(646,'3071','Erps-Kwerps'),
(647,'6560','Erquelinnes'),
(648,'7387','Erquennes'),
(649,'9940','Ertvelde'),
(650,'9620','Erwetegem');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(651,'7760','Escanaffles'),
(652,'8600','Esen'),
(653,'4130','Esneux'),
(654,'7502','Esplechin'),
(655,'7743','Esquelmes'),
(656,'2910','Essen'),
(657,'1790','Essene'),
(658,'7730','Estaimbourg'),
(659,'7730','Estaimpuis'),
(660,'7120','Estinnes-Au-Mont'),
(661,'7120','Estinnes-Au-Val'),
(662,'6740','Etalle'),
(663,'6760','Ethe'),
(664,'9680','Etikhove'),
(665,'8460','Ettelgem'),
(666,'1040','Etterbeek'),
(667,'7080','Eugies'),
(668,'4700','Eupen'),
(669,'1046','European External Action Service'),
(670,'1047','Europees Parlement'),
(671,'1049','Europese unie - Commissie'),
(672,'1048','Europese unie - Raad'),
(673,'4631','Evegn‚e'),
(674,'5350','Evelette'),
(675,'9660','Everbeek'),
(676,'3078','Everberg'),
(677,'1140','Evere'),
(678,'9940','Evergem'),
(679,'7730','Evregnies'),
(680,'5530','Evrehailles'),
(681,'4731','Eynatten'),
(682,'3400','Ezemaal'),
(683,'5600','Fagnolle'),
(684,'4317','Faimes'),
(685,'5522','Fala‰n'),
(686,'5060','Falisolle'),
(687,'4260','Fallais'),
(688,'5500','Falmagne'),
(689,'5500','Falmignoul'),
(690,'7181','Familleureux'),
(691,'6240','Farciennes'),
(692,'5340','Faulx-Les-Tombes'),
(693,'7120','Fauroeulx'),
(694,'6637','Fauvillers'),
(695,'4950','Faymonville'),
(696,'6856','Fays-Les-Veneurs'),
(697,'7387','Fayt-Le-Franc'),
(698,'7170','Fayt-Lez-Manage'),
(699,'5570','Felenne'),
(700,'7181','Feluy'),
(701,'4607','Feneur'),
(702,'4190','Ferrières'),
(703,'5570','Feschaux'),
(704,'4347','Fexhe-Le-Haut-Clocher'),
(705,'4458','Fexhe-Slins'),
(706,'4181','Filot'),
(707,'5560','Finnevaux'),
(708,'4530','Fize-Fontaine'),
(709,'4367','Fize-Le-Marsal'),
(710,'6686','Flamierge'),
(711,'5620','Flavion'),
(712,'5020','Flawinne'),
(713,'4400','Flémalle-Grande'),
(714,'4400','Flémalle-Haute'),
(715,'7012','Flénu'),
(716,'4620','Fléron'),
(717,'6220','Fleurus'),
(718,'4540','Flône'),
(719,'5334','Florée'),
(720,'5150','Floreffe'),
(721,'5620','Florennes'),
(722,'6820','Florenville'),
(723,'5150','Floriffoux'),
(724,'5370','Flostoy'),
(725,'5572','Focant'),
(726,'1212','FOD Mobiliteit'),
(727,'1350','Folx-Les-Caves'),
(728,'6140','Fontaine-L''Evêque'),
(729,'6567','Fontaine-Valmont'),
(730,'5650','Fontenelle'),
(731,'6820','Fontenoille'),
(732,'7643','Fontenoy'),
(733,'4340','Fooz'),
(734,'6141','Forchies-La-Marche'),
(735,'7910','Forest'),
(736,'4870','Forêt'),
(737,'6596','Forge-Philippe'),
(738,'6464','Forges'),
(739,'6953','Forrières'),
(740,'5380','Forville'),
(741,'4980','Fosse'),
(742,'5070','Fosses-La-Ville'),
(743,'7830','Fouleng'),
(744,'6440','Fourbechies'),
(745,'5504','Foy-Notre-Dame'),
(746,'4870','Fraipont'),
(747,'5650','Fraire'),
(748,'4557','Fraiture'),
(749,'7080','Frameries'),
(750,'6853','Framont');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(751,'5380','Franc-Waret'),
(752,'5600','Franchimont'),
(753,'4970','Francorchamps'),
(754,'5150','Franière'),
(755,'5660','Frasnes'),
(756,'7911','Frasnes-Lez-Buissenal'),
(757,'6210','Frasnes-Lez-Gosselies'),
(758,'4347','Freloux'),
(759,'6800','Freux'),
(760,'6440','Froidchapelle'),
(761,'5576','Froidfontaine'),
(762,'7504','Froidmont'),
(763,'6990','Fronville'),
(764,'7503','Froyennes'),
(765,'4260','Fumal'),
(766,'5500','Furfooz'),
(767,'5641','Furnaux'),
(768,'1750','Gaasbeek'),
(769,'7943','Gages'),
(770,'7906','Gallaix'),
(771,'1570','Galmaarden'),
(772,'1083','Ganshoren'),
(773,'7530','Gaurain-Ramecroix'),
(774,'9890','Gavere'),
(775,'5575','Gedinne'),
(776,'2440','Geel'),
(777,'4250','Geer'),
(778,'1367','Geest-Gérompont-Petit-Rosière'),
(779,'3450','Geetbets'),
(780,'5024','Gelbressée'),
(781,'3800','Gelinden'),
(782,'3620','Gellik'),
(783,'3200','Gelrode'),
(784,'8980','Geluveld'),
(785,'8940','Geluwe'),
(786,'6929','Gembes'),
(787,'5030','Gembloux'),
(788,'4851','Gemmenich'),
(789,'1470','Genappe'),
(790,'3600','Genk'),
(791,'7040','Genly'),
(792,'3770','Genoelselderen'),
(793,'9000','Gent'),
(794,'9099','Gent X'),
(795,'9050','Gentbrugge'),
(796,'1450','Gentinnes'),
(797,'1332','Genval'),
(798,'9500','Geraardsbergen'),
(799,'3960','Gerdingen'),
(800,'5524','Gérin');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(801,'1367','Gérompont'),
(802,'6769','Gérouville'),
(803,'6280','Gerpinnes'),
(804,'2590','Gestel'),
(805,'5340','Gesves'),
(806,'7822','Ghislenghien'),
(807,'7011','Ghlin'),
(808,'7863','Ghoy'),
(809,'7823','Gibecq'),
(810,'2275','Gierle'),
(811,'8691','Gijverinkhove'),
(812,'9308','Gijzegem'),
(813,'8570','Gijzelbrechtegem'),
(814,'9860','Gijzenzele'),
(815,'6060','Gilly'),
(816,'5680','Gimnée'),
(817,'3890','Gingelom'),
(818,'8470','Gistel'),
(819,'8830','Gits'),
(820,'7041','Givry'),
(821,'1473','Glabais'),
(822,'3380','Glabbeek'),
(823,'4000','Glain'),
(824,'4400','Gleixhe'),
(825,'1315','Glimes'),
(826,'4690','Glons'),
(827,'5680','Gochenée'),
(828,'7160','Godarville'),
(829,'5530','Godinne'),
(830,'9620','Godveerdegem'),
(831,'4834','Goé'),
(832,'9500','Goeferdinge'),
(833,'7040','Goegnies-Chaussée'),
(834,'5353','Goesnes'),
(835,'3300','Goetsenhoven'),
(836,'4140','Gomz‚-Andoumont'),
(837,'7830','Gondregnies'),
(838,'5660','Gonrieux'),
(839,'9090','Gontrode'),
(840,'1755','Gooik'),
(841,'3840','Gors-Opleeuw'),
(842,'3803','Gorsem'),
(843,'6041','Gosselies'),
(844,'3840','Gotem'),
(845,'9800','Gottem'),
(846,'7070','Gottignies'),
(847,'6280','Gougnies'),
(848,'5651','Gourdinne'),
(849,'6030','Goutroux'),
(850,'6670','Gouvy');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(851,'6181','Gouy-Lez-Piéton'),
(852,'6534','Gozée'),
(853,'4460','Grâce-Berleur'),
(854,'4460','Grâce-Hollogne'),
(855,'5555','Graide'),
(856,'9800','Grammene'),
(857,'4300','Grand-Axhe'),
(858,'4280','Grand-Hallet'),
(859,'6698','Grand-Halleux'),
(860,'5031','Grand-Leez'),
(861,'5030','Grand-Manil'),
(862,'4650','Grand-Rechain'),
(863,'6560','Grand-Reng'),
(864,'1367','Grand-Rosière-Hottomont'),
(865,'7973','Grandglise'),
(866,'6940','Grandhan'),
(867,'6960','Grandménil'),
(868,'7900','Grandmetz'),
(869,'6470','Grandrieu'),
(870,'4360','Grandville'),
(871,'6840','Grandvoir'),
(872,'6840','Grapfontaine'),
(873,'7830','Graty'),
(874,'5640','Graux'),
(875,'3450','Grazen'),
(876,'9200','Grembergen'),
(877,'1390','Grez-Doiceau'),
(878,'1850','Grimbergen'),
(879,'9506','Grimminge'),
(880,'4030','Grivegnée'),
(881,'2280','Grobbendonk'),
(882,'1702','Groot-Bijgaarden'),
(883,'3800','Groot-Gelmen'),
(884,'3840','Groot-Loon'),
(885,'5555','Gros-Fays'),
(886,'7950','Grosage'),
(887,'3990','Grote-Brogel'),
(888,'3740','Grote-Spouwen'),
(889,'9620','Grotenberge'),
(890,'3670','Gruitrode'),
(891,'6952','Grune'),
(892,'6927','Grupont'),
(893,'7620','Guignies'),
(894,'3723','Guigoven'),
(895,'6704','Guirsch'),
(896,'8560','Gullegem'),
(897,'3870','Gutshoven'),
(898,'3150','Haacht'),
(899,'9450','Haaltert'),
(900,'9120','Haasdonk');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(901,'3053','Haasrode'),
(902,'6720','Habay-La-Neuve'),
(903,'6723','Habay-La-Vieille'),
(904,'6782','Habergy'),
(905,'4684','Haccourt'),
(906,'6720','Hachy'),
(907,'7911','Hacquegnies'),
(908,'5351','Haillot'),
(909,'7100','Haine-Saint-Paul'),
(910,'7100','Haine-Saint-Pierre'),
(911,'7350','Hainin'),
(912,'3300','Hakendover'),
(913,'6792','Halanzy'),
(914,'3545','Halen'),
(915,'2220','Hallaar'),
(916,'1500','Halle'),
(917,'2980','Halle'),
(918,'3440','Halle-Booienhoven'),
(919,'6986','Halleux'),
(920,'6922','Halma'),
(921,'3800','Halmaal'),
(922,'5340','Haltinne'),
(923,'6120','Ham-Sur-Heure'),
(924,'5190','Ham-Sur-Sambre'),
(925,'6840','Hamipr‚'),
(926,'1785','Hamme'),
(927,'9220','Hamme'),
(928,'1320','Hamme-Mille'),
(929,'4180','Hamoir'),
(930,'5360','Hamois'),
(931,'3930','Hamont'),
(932,'6990','Hampteau'),
(933,'5580','Han-Sur-Lesse'),
(934,'8610','Handzame'),
(935,'4357','Haneffe'),
(936,'4210','Hannêche'),
(937,'4280','Hannut'),
(938,'5310','Hanret'),
(939,'9850','Hansbeke'),
(940,'6560','Hantes-Wihéries'),
(941,'5621','Hanzinelle'),
(942,'5621','Hanzinne'),
(943,'7321','Harchies'),
(944,'8530','Harelbeke'),
(945,'1130','Haren'),
(946,'3700','Haren'),
(947,'3840','Haren'),
(948,'6900','Hargimont'),
(949,'7022','Harmignies'),
(950,'6767','Harnoncourt');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(951,'6960','Harre'),
(952,'6950','Harsin'),
(953,'7022','Harveng'),
(954,'4920','Harz‚'),
(955,'3500','Hasselt'),
(956,'5540','Hastière-Lavaux'),
(957,'5541','Hastière-Par-Delà'),
(958,'6870','Hatrival'),
(959,'7120','Haulchin'),
(960,'4730','Hauset'),
(961,'6929','Haut-Fays'),
(962,'1461','Haut-Ittre'),
(963,'5537','Haut-Le-Wastia'),
(964,'7334','Hautrage'),
(965,'7041','Havay'),
(966,'5370','Havelange'),
(967,'5590','Haversin'),
(968,'7531','Havinnes'),
(969,'7021','Havré'),
(970,'3940','Hechtel'),
(971,'5543','Heer'),
(972,'3870','Heers'),
(973,'3740','Hees'),
(974,'8551','Heestert'),
(975,'2801','Heffen'),
(976,'1670','Heikruis'),
(977,'2830','Heindonk'),
(978,'6700','Heinsch'),
(979,'8301','Heist-Aan-Zee'),
(980,'2220','Heist-Op-Den-Berg'),
(981,'1790','Hekelgem'),
(982,'3870','Heks'),
(983,'3530','Helchteren'),
(984,'9450','Heldergem'),
(985,'3440','Helen-Bos'),
(986,'8587','Helkijn'),
(987,'7830','Hellebecq'),
(988,'9571','Hemelveerdegem'),
(989,'2620','Hemiksem'),
(990,'5380','Hemptinne'),
(991,'5620','Hemptinne-Lez-Florennes'),
(992,'3840','Hendrieken'),
(993,'3700','Henis'),
(994,'7090','Hennuyères'),
(995,'4841','Henri-Chapelle'),
(996,'7090','Henripont'),
(997,'7350','Hensies'),
(998,'3971','Heppen'),
(999,'4771','Heppenbach'),
(1000,'6220','Heppignies');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1001,'6887','Herbeumont'),
(1002,'7050','Herchies'),
(1003,'3770','Herderen'),
(1004,'9310','Herdersem'),
(1005,'3020','Herent'),
(1006,'2200','Herentals'),
(1007,'2270','Herenthout'),
(1008,'1540','Herfelingen'),
(1009,'4728','Hergenrath'),
(1010,'7742','Hérinnes-Lez-Pecq'),
(1011,'3540','Herk-De-Stad'),
(1012,'4681','Hermalle-Sous-Argenteau'),
(1013,'4480','Hermalle-Sous-Huy'),
(1014,'4680','Hermée'),
(1015,'5540','Hermeton-Sur-Meuse'),
(1016,'1540','Herne'),
(1017,'4217','Héron'),
(1018,'7911','Herquegies'),
(1019,'7712','Herseaux'),
(1020,'2230','Herselt'),
(1021,'4040','Herstal'),
(1022,'3717','Herstappe'),
(1023,'7522','Hertain'),
(1024,'3831','Herten'),
(1025,'8020','Hertsberge'),
(1026,'4650','Herve'),
(1027,'9550','Herzele'),
(1028,'8501','Heule'),
(1029,'5377','Heure'),
(1030,'4682','Heure-Le-Romain'),
(1031,'9700','Heurne'),
(1032,'3550','Heusden'),
(1033,'9070','Heusden'),
(1034,'3550','Heusden-Zolder'),
(1035,'4802','Heusy'),
(1036,'3191','Hever'),
(1037,'3001','Heverlee'),
(1038,'1435','Hévillers'),
(1039,'6941','Heyd'),
(1040,'1733','HighCo DATA'),
(1041,'9550','Hillegem'),
(1042,'2880','Hingene'),
(1043,'5380','Hingeon'),
(1044,'6984','Hives'),
(1045,'2660','Hoboken'),
(1046,'4351','Hodeige'),
(1047,'6987','Hodister'),
(1048,'4162','Hody'),
(1049,'3320','Hoegaarden'),
(1050,'1560','Hoeilaart');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1051,'8340','Hoeke'),
(1052,'3746','Hoelbeek'),
(1053,'3471','Hoeleden'),
(1054,'3840','Hoepertingen'),
(1055,'3730','Hoeselt'),
(1056,'2940','Hoevenen'),
(1057,'1981','Hofstade'),
(1058,'9308','Hofstade'),
(1059,'5377','Hogne'),
(1060,'4342','Hognoul'),
(1061,'7620','Hollain'),
(1062,'6637','Hollange'),
(1063,'8902','Hollebeke'),
(1064,'4460','Hollogne-Aux-Pierres'),
(1065,'4250','Hollogne-Sur-Geer'),
(1066,'3220','Holsbeek'),
(1067,'2811','Hombeek'),
(1068,'4852','Hombourg'),
(1069,'6640','Hompré'),
(1070,'6780','Hondelange'),
(1071,'5570','Honnay'),
(1072,'8830','Hooglede'),
(1073,'8690','Hoogstade'),
(1074,'2320','Hoogstraten'),
(1075,'4460','Horion-Hoz‚mont'),
(1076,'7301','Hornu'),
(1077,'3870','Horpmaal'),
(1078,'7060','Horrues'),
(1079,'6990','Hotton'),
(1080,'6724','Houdemont'),
(1081,'7110','Houdeng-Aimeries'),
(1082,'7110','Houdeng-Goegnies'),
(1083,'5575','Houdremont'),
(1084,'6660','Houffalize'),
(1085,'5563','Hour'),
(1086,'4671','Housse'),
(1087,'1476','Houtain-Le-Val'),
(1088,'4682','Houtain-Saint-Siméon'),
(1089,'7812','Houtaing'),
(1090,'8377','Houtave'),
(1091,'8630','Houtem'),
(1092,'3530','Houthalen'),
(1093,'7781','Houthem'),
(1094,'8650','Houthulst'),
(1095,'2235','Houtvenne'),
(1096,'3390','Houwaart'),
(1097,'5530','Houx'),
(1098,'5560','Houyet'),
(1099,'2540','Hove'),
(1100,'7830','Hoves');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1101,'7624','Howardries'),
(1102,'4520','Huccorgne'),
(1103,'9750','Huise'),
(1104,'7950','Huissignies'),
(1105,'1654','Huizingen'),
(1106,'3040','Huldenberg'),
(1107,'2235','Hulshout'),
(1108,'5560','Hulsonniaux'),
(1109,'8531','Hulste'),
(1110,'6900','Humain'),
(1111,'1851','Humbeek'),
(1112,'9630','Hundelgem'),
(1113,'1367','Huppaye'),
(1114,'4500','Huy'),
(1115,'7022','Hyon'),
(1116,'8480','Ichtegem'),
(1117,'9472','Iddergem'),
(1118,'9506','Idegem'),
(1119,'8900','Ieper'),
(1120,'9340','Impe'),
(1121,'1315','Incourt'),
(1122,'8770','Ingelmunster'),
(1123,'8570','Ingooigem'),
(1124,'1041','International press center'),
(1125,'7801','Irchonwelz'),
(1126,'7822','Isières'),
(1127,'5032','Isnes'),
(1128,'2222','Itegem'),
(1129,'1701','Itterbeek'),
(1130,'1460','Ittre'),
(1131,'4400','Ivoz-Ramet'),
(1132,'8870','Izegem'),
(1133,'6810','Izel'),
(1134,'8691','Izenberge'),
(1135,'6941','Izier'),
(1136,'8490','Jabbeke'),
(1137,'4845','Jalhay'),
(1138,'5354','Jallet'),
(1139,'5600','Jamagne'),
(1140,'5100','Jambes'),
(1141,'5600','Jamiolle'),
(1142,'6120','Jamioulx'),
(1143,'6810','Jamoigne'),
(1144,'1350','Jandrain-Jandrenouille'),
(1145,'1350','Jauche'),
(1146,'1370','Jauchelette'),
(1147,'5570','Javingue'),
(1148,'4540','Jehay'),
(1149,'6880','Jehonville'),
(1150,'7012','Jemappes');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1151,'5580','Jemelle'),
(1152,'5589','Jemelle'),
(1153,'4101','Jemeppe-Sur-Meuse'),
(1154,'5190','Jemeppe-Sur-Sambre'),
(1155,'4357','Jeneffe'),
(1156,'5370','Jeneffe'),
(1157,'3840','Jesseren'),
(1158,'1090','Jette'),
(1159,'3890','Jeuk'),
(1160,'1370','Jodoigne'),
(1161,'1370','Jodoigne-Souveraine'),
(1162,'7620','Jollain-Merlin'),
(1163,'6280','Joncret'),
(1164,'4650','Jul‚mont'),
(1165,'6040','Jumet'),
(1166,'4020','Jupille-Sur-Meuse'),
(1167,'4450','Juprelle'),
(1168,'7050','Jurbise'),
(1169,'6642','Juseret'),
(1170,'8600','Kaaskerke'),
(1171,'8870','Kachtem'),
(1172,'3293','Kaggevinne'),
(1173,'7540','Kain'),
(1174,'9270','Kalken'),
(1175,'9120','Kallo'),
(1176,'9130','Kallo'),
(1177,'2920','Kalmthout'),
(1178,'1008','Kamer van Volksvertegenwoordigers'),
(1179,'1910','Kampenhout'),
(1180,'8700','Kanegem'),
(1181,'3770','Kanne'),
(1182,'1880','Kapelle-Op-Den-Bos'),
(1183,'2950','Kapellen'),
(1184,'3381','Kapellen'),
(1185,'9970','Kaprijke'),
(1186,'8572','Kaster'),
(1187,'2460','Kasterlee'),
(1188,'3950','Kaulille'),
(1189,'3140','Keerbergen'),
(1190,'8600','Keiem'),
(1191,'4720','Kelmis'),
(1192,'4367','Kemexhe'),
(1193,'8956','Kemmel'),
(1194,'9190','Kemzeke'),
(1195,'8581','Kerkhove'),
(1196,'3370','Kerkom'),
(1197,'3800','Kerkom-Bij-Sint-Truiden'),
(1198,'9451','Kerksken'),
(1199,'3510','Kermt'),
(1200,'3840','Kerniel');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1201,'3472','Kersbeek-Miskom'),
(1202,'2560','Kessel'),
(1203,'3010','Kessel Lo'),
(1204,'3640','Kessenich'),
(1205,'1755','Kester'),
(1206,'4701','Kettenis'),
(1207,'5060','Keumiée'),
(1208,'9130','Kieldrecht'),
(1209,'3640','Kinrooi'),
(1210,'3870','Klein-Gelmen'),
(1211,'3990','Kleine-Brogel'),
(1212,'3740','Kleine-Spouwen'),
(1213,'8420','Klemskerke'),
(1214,'8650','Klerken'),
(1215,'9940','Kluizen'),
(1216,'9910','Knesselare'),
(1217,'8300','Knokke'),
(1218,'1730','Kobbegem'),
(1219,'8680','Koekelare'),
(1220,'1081','Koekelberg'),
(1221,'3582','Koersel'),
(1222,'8670','Koksijde'),
(1223,'3700','Kolmont'),
(1224,'3840','Kolmont'),
(1225,'7780','Komen'),
(1226,'7780','Komen-Waasten'),
(1227,'2500','Koningshooikt'),
(1228,'3700','Koninksem'),
(1229,'2550','Kontich'),
(1230,'8510','Kooigem'),
(1231,'8000','Koolkerke'),
(1232,'8851','Koolskamp'),
(1233,'3060','Korbeek-Dijle'),
(1234,'3360','Korbeek-Lo'),
(1235,'8610','Kortemark'),
(1236,'3470','Kortenaken'),
(1237,'3070','Kortenberg'),
(1238,'3720','Kortessem'),
(1239,'3890','Kortijs'),
(1240,'8500','Kortrijk'),
(1241,'3220','Kortrijk-Dutsel'),
(1242,'3850','Kozen'),
(1243,'1950','Kraainem'),
(1244,'8972','Krombeke'),
(1245,'9150','Kruibeke'),
(1246,'9770','Kruishoutem'),
(1247,'3300','Kumtich'),
(1248,'3511','Kuringen'),
(1249,'3840','Kuttekoven'),
(1250,'8520','Kuurne');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1251,'3945','Kwaadmechelen'),
(1252,'9690','Kwaremont'),
(1253,'1320','L''Ecluse'),
(1254,'6464','L''Escaillère'),
(1255,'7080','La Bouverie'),
(1256,'7611','La Glanerie'),
(1257,'4987','La Gleize'),
(1258,'7170','La Hestre'),
(1259,'1310','La Hulpe'),
(1260,'7100','La Louvière'),
(1261,'4910','La Reid'),
(1262,'6980','La Roche-En-Ardenne'),
(1263,'3400','Laar'),
(1264,'9270','Laarne'),
(1265,'6567','Labuissière'),
(1266,'6821','Lacuisine'),
(1267,'7950','Ladeuze'),
(1268,'5550','Laforêt'),
(1269,'7890','Lahamaide'),
(1270,'1020','Laken'),
(1271,'7522','Lamain'),
(1272,'4800','Lambermont'),
(1273,'6220','Lambusart'),
(1274,'4350','Lamine'),
(1275,'4210','Lamontzée'),
(1276,'6767','Lamorteau'),
(1277,'8600','Lampernisse'),
(1278,'3620','Lanaken'),
(1279,'4600','Lanaye'),
(1280,'9850','Landegem'),
(1281,'6111','Landelies'),
(1282,'3400','Landen'),
(1283,'5300','Landenne'),
(1284,'9860','Landskouter'),
(1285,'5651','Laneffe'),
(1286,'3201','Langdorp'),
(1287,'8920','Langemark'),
(1288,'3650','Lanklaar'),
(1289,'7800','Lanquesaint'),
(1290,'4450','Lantin'),
(1291,'4300','Lantremange'),
(1292,'7622','Laplaigne'),
(1293,'8340','Lapscheure'),
(1294,'1380','Lasne-Chapelle-Saint-Lambert'),
(1295,'1370','Lathuy'),
(1296,'4261','Latinne'),
(1297,'6761','Latour'),
(1298,'3700','Lauw'),
(1299,'8930','Lauwe'),
(1300,'6681','Lavacherie');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1301,'5580','Lavaux-Sainte-Anne'),
(1302,'4217','Lavoir'),
(1303,'5670','Le Mesnil'),
(1304,'7070','Le Roeulx'),
(1305,'5070','Le Roux'),
(1306,'9280','Lebbeke'),
(1307,'9340','Lede'),
(1308,'9050','Ledeberg'),
(1309,'8880','Ledegem'),
(1310,'3061','Leefdaal'),
(1311,'1755','Leerbeek'),
(1312,'6142','Leernes'),
(1313,'6530','Leers-Et-Fosteau'),
(1314,'7730','Leers-Nord'),
(1315,'2811','Leest'),
(1316,'9620','Leeuwergem'),
(1317,'8432','Leffinge'),
(1318,'6860','Léglise'),
(1319,'5590','Leignon'),
(1320,'8691','Leisele'),
(1321,'8600','Leke'),
(1322,'1502','Lembeek'),
(1323,'9971','Lembeke'),
(1324,'9820','Lemberge'),
(1325,'8860','Lendelede'),
(1326,'7870','Lens'),
(1327,'4280','Lens-Saint-Remy'),
(1328,'4250','Lens-Saint-Servais'),
(1329,'4360','Lens-Sur-Geer'),
(1330,'3970','Leopoldsburg'),
(1331,'4560','Les Avins'),
(1332,'6811','Les Bulles'),
(1333,'6830','Les Hayons'),
(1334,'4317','Les Waleffes'),
(1335,'7621','Lesdain'),
(1336,'7860','Lessines'),
(1337,'5580','Lessive'),
(1338,'6953','Lesterny'),
(1339,'5170','Lesve'),
(1340,'7850','Lettelingen'),
(1341,'9521','Letterhoutem'),
(1342,'6500','Leugnies'),
(1343,'9700','Leupegem'),
(1344,'3630','Leut'),
(1345,'3000','Leuven'),
(1346,'5310','Leuze'),
(1347,'7900','Leuze-En-Hainaut'),
(1348,'6500','Leval-Chaudeville'),
(1349,'7134','Leval-Trahegnies'),
(1350,'6238','Liberchies');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1351,'6890','Libin'),
(1352,'6800','Libramont-Chevigny'),
(1353,'2460','Lichtaart'),
(1354,'8810','Lichtervelde'),
(1355,'1770','Liedekerke'),
(1356,'9400','Lieferinge'),
(1357,'4000','Liège'),
(1358,'4020','Liège'),
(1359,'4099','Liège X'),
(1360,'2500','Lier'),
(1361,'4990','Lierneux'),
(1362,'5310','Liernu'),
(1363,'4042','Liers'),
(1364,'2870','Liezele'),
(1365,'7812','Ligne'),
(1366,'4254','Ligney'),
(1367,'5140','Ligny'),
(1368,'2275','Lille'),
(1369,'2040','Lillo'),
(1370,'1428','Lillois-Witterzée'),
(1371,'1300','Limal'),
(1372,'4830','Limbourg'),
(1373,'1342','Limelette'),
(1374,'6670','Limerl‚'),
(1375,'4357','Limont'),
(1376,'4287','Lincent'),
(1377,'3210','Linden'),
(1378,'1630','Linkebeek'),
(1379,'3560','Linkhout'),
(1380,'1357','Linsmeau'),
(1381,'2547','Lint'),
(1382,'3350','Linter'),
(1383,'2890','Lippelo'),
(1384,'5501','Lisogne'),
(1385,'8380','Lissewege'),
(1386,'5101','Lives-Sur-Meuse'),
(1387,'4600','Lixhe'),
(1388,'8647','Lo'),
(1389,'6540','Lobbes'),
(1390,'9080','Lochristi'),
(1391,'6042','Lodelinsart'),
(1392,'2990','Loenhout'),
(1393,'8958','Loker'),
(1394,'9160','Lokeren'),
(1395,'3545','Loksbergen'),
(1396,'8434','Lombardsijde'),
(1397,'7870','Lombise'),
(1398,'3920','Lommel'),
(1399,'4783','Lommersweiler'),
(1400,'6463','Lompret');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1401,'6924','Lomprez'),
(1402,'4431','Loncin'),
(1403,'1840','Londerzeel'),
(1404,'5310','Longchamps'),
(1405,'6688','Longchamps'),
(1406,'6840','Longlier'),
(1407,'1325','Longueville'),
(1408,'6600','Longvilly'),
(1409,'4710','Lontzen'),
(1410,'5030','Lonzée'),
(1411,'3040','Loonbeek'),
(1412,'8210','Loppem'),
(1413,'4987','Lorc‚'),
(1414,'1651','Lot'),
(1415,'9880','Lotenhulle'),
(1416,'5575','Louette-Saint-Denis'),
(1417,'5575','Louette-Saint-Pierre'),
(1418,'1471','Loupoigne'),
(1419,'1348','Louvain-La-Neuve'),
(1420,'4141','Louveign‚'),
(1421,'4920','Louveign‚'),
(1422,'9920','Lovendegem'),
(1423,'3360','Lovenjoel'),
(1424,'6280','Loverval'),
(1425,'5101','Loyers'),
(1426,'3210','Lubbeek'),
(1427,'7700','Luingne'),
(1428,'3560','Lummen'),
(1429,'5170','Lustin'),
(1430,'6238','Luttre'),
(1431,'9680','Maarke-Kerkem'),
(1432,'3680','Maaseik'),
(1433,'3630','Maasmechelen'),
(1434,'6663','Mabompr‚'),
(1435,'1830','Machelen'),
(1436,'9870','Machelen'),
(1437,'6591','Macon'),
(1438,'6593','Macquenoise'),
(1439,'5374','Maffe'),
(1440,'7810','Maffle'),
(1441,'4623','Magn‚e'),
(1442,'5330','Maillen'),
(1443,'7812','Mainvault'),
(1444,'7020','Maisières'),
(1445,'6852','Maissin'),
(1446,'5300','Maizeret'),
(1447,'3700','Mal'),
(1448,'9990','Maldegem'),
(1449,'1840','Malderen'),
(1450,'6960','Malempré');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1451,'1360','Malèves-Sainte-Marie-Wastinnes'),
(1452,'2390','Malle'),
(1453,'4960','Malmedy'),
(1454,'5020','Malonne'),
(1455,'5575','Malvoisin'),
(1456,'7170','Manage'),
(1457,'4760','Manderfeld'),
(1458,'8433','Mannekensvere'),
(1459,'1380','Maransart'),
(1460,'1495','Marbais'),
(1461,'6120','Marbaix'),
(1462,'6900','Marche-En-Famenne'),
(1463,'5024','Marche-Les-Dames'),
(1464,'7190','Marche-Lez-Ecaussinnes'),
(1465,'6030','Marchienne-Au-Pont'),
(1466,'4570','Marchin'),
(1467,'7387','Marchipont'),
(1468,'5380','Marchovelette'),
(1469,'6001','Marcinelle'),
(1470,'6987','Marcourt'),
(1471,'6990','Marenne'),
(1472,'9030','Mariakerke'),
(1473,'2880','Mariekerke'),
(1474,'5660','Mariembourg'),
(1475,'1350','Marilles'),
(1476,'7850','Mark'),
(1477,'8510','Marke'),
(1478,'8720','Markegem'),
(1479,'4210','Marneffe'),
(1480,'7522','Marquain'),
(1481,'6630','Martelange'),
(1482,'3742','Martenslinde'),
(1483,'5573','Martouzin-Neuville'),
(1484,'6953','Masbourg'),
(1485,'7050','Masnuy-Saint-Jean'),
(1486,'7050','Masnuy-Saint-Pierre'),
(1487,'9230','Massemen'),
(1488,'2240','Massenhoven'),
(1489,'5680','Matagne-La-Grande'),
(1490,'5680','Matagne-La-Petite'),
(1491,'9700','Mater'),
(1492,'7640','Maubray'),
(1493,'7534','Maulde'),
(1494,'7110','Maurage'),
(1495,'5670','Maz‚e'),
(1496,'1745','Mazenzele'),
(1497,'5032','Mazy'),
(1498,'5372','Méan'),
(1499,'2800','Mechelen'),
(1500,'3630','Mechelen-Aan-De-Maas');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1501,'3870','Mechelen-Bovelingen'),
(1502,'4219','Meeffe'),
(1503,'3391','Meensel-Kiezegem'),
(1504,'2321','Meer'),
(1505,'3078','Meerbeek'),
(1506,'9402','Meerbeke'),
(1507,'9170','Meerdonk'),
(1508,'2450','Meerhout'),
(1509,'2328','Meerle'),
(1510,'3630','Meeswijk'),
(1511,'8377','Meetkerke'),
(1512,'3670','Meeuwen'),
(1513,'5310','Mehaigne'),
(1514,'9800','Meigem'),
(1515,'9630','Meilegem'),
(1516,'1860','Meise'),
(1517,'6769','Meix-Devant-Virton'),
(1518,'6747','Meix-Le-Tige'),
(1519,'9700','Melden'),
(1520,'3320','Meldert'),
(1521,'3560','Meldert'),
(1522,'9310','Meldert'),
(1523,'4633','Melen'),
(1524,'1370','Mélin'),
(1525,'3350','Melkwezer'),
(1526,'9090','Melle'),
(1527,'1495','Mellery'),
(1528,'7540','Melles'),
(1529,'6211','Mellet'),
(1530,'6860','Mellier'),
(1531,'1820','Melsbroek'),
(1532,'9120','Melsele'),
(1533,'9820','Melsen'),
(1534,'4837','Membach'),
(1535,'5550','Membre'),
(1536,'3770','Membruggen'),
(1537,'9042','Mendonk'),
(1538,'8930','Menen'),
(1539,'6567','Merbes-Le-Chƒteau'),
(1540,'6567','Merbes-Sainte-Marie'),
(1541,'1785','Merchtem'),
(1542,'4280','Merdorp'),
(1543,'9420','Mere'),
(1544,'9820','Merelbeke'),
(1545,'9850','Merendree'),
(1546,'8650','Merkem'),
(1547,'2170','Merksem'),
(1548,'2330','Merksplas'),
(1549,'5600','Merlemont'),
(1550,'8957','Mesen');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1551,'7822','Meslin-L''Evêque'),
(1552,'5560','Mesnil-Eglise'),
(1553,'5560','Mesnil-Saint-Blaise'),
(1554,'9200','Mespelare'),
(1555,'6780','Messancy'),
(1556,'3272','Messelbroek'),
(1557,'7022','Mesvin'),
(1558,'3870','Mettekoven'),
(1559,'5640','Mettet'),
(1560,'8760','Meulebeke'),
(1561,'5081','Meux'),
(1562,'7942','Mévergnies-Lez-Lens'),
(1563,'4770','Meyerode'),
(1564,'9660','Michelbeke'),
(1565,'4630','Micheroux'),
(1566,'9992','Middelburg'),
(1567,'8430','Middelkerke'),
(1568,'5376','Miécret'),
(1569,'3891','Mielen-Boven-Aalst'),
(1570,'7070','Mignault'),
(1571,'3770','Millen'),
(1572,'4041','Milmort'),
(1573,'2322','Minderhout'),
(1574,'1035','Ministerie van het Brussels Hoofdstedelijk Gewest'),
(1575,'6870','Mirwart'),
(1576,'4577','Modave'),
(1577,'3790','Moelingen'),
(1578,'8552','Moen'),
(1579,'9500','Moerbeke'),
(1580,'9180','Moerbeke-Waas'),
(1581,'8470','Moere'),
(1582,'8340','Moerkerke'),
(1583,'9220','Moerzeke'),
(1584,'7700','Moeskroen'),
(1585,'4520','Moha'),
(1586,'5361','Mohiville'),
(1587,'5060','Moignel‚e'),
(1588,'6800','Moircy'),
(1589,'2400','Mol'),
(1590,'7760','Molenbaix'),
(1591,'3461','Molenbeek-Wersbeek'),
(1592,'3640','Molenbeersel'),
(1593,'3294','Molenstede'),
(1594,'1730','Mollem'),
(1595,'4350','Momalle'),
(1596,'6590','Momignies'),
(1597,'5555','Monceau-En-Ardenne'),
(1598,'6592','Monceau-Imbrechies'),
(1599,'6031','Monceau-Sur-Sambre'),
(1600,'7000','Mons');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1601,'4400','Mons-Lez-Liège'),
(1602,'1400','Monstreux'),
(1603,'5530','Mont'),
(1604,'6661','Mont'),
(1605,'5580','Mont-Gauthier'),
(1606,'1367','Mont-Saint-André'),
(1607,'7542','Mont-Saint-Aubert'),
(1608,'1435','Mont-Saint-Guibert'),
(1609,'7141','Mont-Sainte-Aldegonde'),
(1610,'6540','Mont-Sainte-Geneviève'),
(1611,'6032','Mont-Sur-Marchienne'),
(1612,'6470','Montbliart'),
(1613,'4420','Montegnée'),
(1614,'3890','Montenaken'),
(1615,'7870','Montignies-Lez-Lens'),
(1616,'6560','Montignies-Saint-Christophe'),
(1617,'7387','Montignies-Sur-Roc'),
(1618,'6061','Montignies-Sur-Sambre'),
(1619,'6110','Montigny-Le-Tilleul'),
(1620,'6674','Montleban'),
(1621,'7911','Montroeul-Au-Bois'),
(1622,'7350','Montroeul-Sur-Haine'),
(1623,'4850','Montzen'),
(1624,'9310','Moorsel'),
(1625,'8560','Moorsele'),
(1626,'8890','Moorslede'),
(1627,'9860','Moortsele'),
(1628,'3740','Mopertingen'),
(1629,'9790','Moregem'),
(1630,'4850','Moresnet'),
(1631,'6640','Morhet'),
(1632,'5621','Morialm‚'),
(1633,'2200','Morkhoven'),
(1634,'7140','Morlanwelz-Mariemont'),
(1635,'6997','Mormont'),
(1636,'5190','Mornimont'),
(1637,'4670','Mortier'),
(1638,'4607','Mortroux'),
(1639,'2640','Mortsel'),
(1640,'5620','Morville'),
(1641,'7812','Moulbaix'),
(1642,'7543','Mourcourt'),
(1643,'7911','Moustier'),
(1644,'5190','Moustier-Sur-Sambre'),
(1645,'5550','Mouzaive'),
(1646,'4280','Moxhe'),
(1647,'5340','Mozet'),
(1648,'2812','Muizen'),
(1649,'3891','Muizen'),
(1650,'9700','Mullem');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1651,'9630','Munkzwalm'),
(1652,'6820','Muno'),
(1653,'3740','Munsterbilzen'),
(1654,'9820','Munte'),
(1655,'6750','Musson'),
(1656,'6750','Mussy-La-Ville'),
(1657,'4190','My'),
(1658,'7062','Naast'),
(1659,'6660','Nadrin'),
(1660,'5550','Nafraiture'),
(1661,'6120','Nalinnes'),
(1662,'5300','Namˆche'),
(1663,'5000','Namur'),
(1664,'4550','Nandrin'),
(1665,'5100','Naninne'),
(1666,'5555','Naom‚'),
(1667,'6950','Nassogne'),
(1668,'1110','NATO'),
(1669,'5360','Natoye'),
(1670,'9810','Nazareth'),
(1671,'7730','Néchin'),
(1672,'1120','Neder-Over-Heembeek'),
(1673,'9500','Nederboelare'),
(1674,'9660','Nederbrakel'),
(1675,'9700','Nederename'),
(1676,'9400','Nederhasselt'),
(1677,'1910','Nederokkerzeel'),
(1678,'9636','Nederzwalm-Hermelgem'),
(1679,'3670','Neerglabbeek'),
(1680,'3620','Neerharen'),
(1681,'3350','Neerhespen'),
(1682,'1357','Neerheylissem'),
(1683,'3040','Neerijse'),
(1684,'3404','Neerlanden'),
(1685,'3350','Neerlinter'),
(1686,'3680','Neeroeteren'),
(1687,'3910','Neerpelt'),
(1688,'3700','Neerrepen'),
(1689,'3370','Neervelp'),
(1690,'7784','Neerwaasten'),
(1691,'3400','Neerwinden'),
(1692,'9403','Neigem'),
(1693,'3700','Nerem'),
(1694,'4870','Nessonvaux'),
(1695,'1390','Nethen'),
(1696,'5377','Nettinne'),
(1697,'4721','Neu-Moresnet'),
(1698,'4608','Neufchâteau'),
(1699,'6840','Neufchâteau'),
(1700,'7332','Neufmaison');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1701,'7063','Neufvilles'),
(1702,'5600','Neuville'),
(1703,'4121','Neuville-En-Condroz'),
(1704,'9850','Nevele'),
(1705,'2845','Niel'),
(1706,'3668','Niel-Bij-As'),
(1707,'3890','Niel-Bij-Sint-Truiden'),
(1708,'9506','Nieuwenhove'),
(1709,'1880','Nieuwenrode'),
(1710,'3850','Nieuwerkerken'),
(1711,'9320','Nieuwerkerken'),
(1712,'8600','Nieuwkapelle'),
(1713,'8950','Nieuwkerke'),
(1714,'9100','Nieuwkerken-Waas'),
(1715,'8377','Nieuwmunster'),
(1716,'8620','Nieuwpoort'),
(1717,'3221','Nieuwrode'),
(1718,'2560','Nijlen'),
(1719,'1457','Nil-Saint-Vincent-Saint-Martin'),
(1720,'7020','Nimy'),
(1721,'9400','Ninove'),
(1722,'5670','Nismes'),
(1723,'1400','Nivelles'),
(1724,'5680','Niverlée'),
(1725,'6640','Nives'),
(1726,'6717','Nobressart'),
(1727,'1320','Nodebais'),
(1728,'1350','Noduwez'),
(1729,'7080','Noirchain'),
(1730,'6831','Noirfontaine'),
(1731,'5377','Noiseux'),
(1732,'9771','Nokere'),
(1733,'6851','Nollevaux'),
(1734,'2200','Noorderwijk'),
(1735,'8647','Noordschote'),
(1736,'1930','Nossegem'),
(1737,'6717','Nothomb'),
(1738,'7022','Nouvelles'),
(1739,'4347','Noville'),
(1740,'6600','Noville'),
(1741,'5380','Noville-Les-Bois'),
(1742,'5310','Noville-Sur-Mehaigne'),
(1743,'9681','Nukerke'),
(1744,'6230','Obaix'),
(1745,'7743','Obigies'),
(1746,'7034','Obourg'),
(1747,'6890','Ochamps'),
(1748,'4560','Ocquier'),
(1749,'6960','Odeigne'),
(1750,'4367','Odeur');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1751,'8730','Oedelem'),
(1752,'8800','Oekene'),
(1753,'2520','Oelegem'),
(1754,'8690','Oeren'),
(1755,'8720','Oeselgem'),
(1756,'1755','Oetingen'),
(1757,'7911','Oeudeghien'),
(1758,'2260','Oevel'),
(1759,'6850','Offagne'),
(1760,'1934','Office Exchange Brussels Airport Remailing'),
(1761,'7862','Ogy'),
(1762,'1380','Ohain'),
(1763,'5350','Ohey'),
(1764,'5670','Oignies-En-Thiérache'),
(1765,'1480','Oisquercq'),
(1766,'5555','Oizy'),
(1767,'9400','Okegem'),
(1768,'2250','Olen'),
(1769,'4300','Oleye'),
(1770,'7866','Ollignies'),
(1771,'5670','Olloy-Sur-Viroin'),
(1772,'2491','Olmen'),
(1773,'4877','Olne'),
(1774,'9870','Olsene'),
(1775,'4252','Omal'),
(1776,'4540','Ombret'),
(1777,'5600','Omez‚e'),
(1778,'6900','On'),
(1779,'5520','Onhaye'),
(1780,'9500','Onkerzele'),
(1781,'7387','Onnezies'),
(1782,'5190','Onoz'),
(1783,'1760','Onze-Lieve-Vrouw-Lombeek'),
(1784,'2861','Onze-Lieve-Vrouw-Waver'),
(1785,'8710','Ooigem'),
(1786,'9700','Ooike'),
(1787,'9790','Ooike'),
(1788,'9520','Oombergen'),
(1789,'9620','Oombergen'),
(1790,'3300','Oorbeek'),
(1791,'9340','Oordegem'),
(1792,'9041','Oostakker'),
(1793,'8670','Oostduinkerke'),
(1794,'9968','Oosteeklo'),
(1795,'8400','Oostende'),
(1796,'9860','Oosterzele'),
(1797,'3945','Oostham'),
(1798,'8020','Oostkamp'),
(1799,'8340','Oostkerke'),
(1800,'8600','Oostkerke');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1801,'2390','Oostmalle'),
(1802,'8840','Oostnieuwkerke'),
(1803,'8780','Oostrozebeke'),
(1804,'8640','Oostvleteren'),
(1805,'9931','Oostwinkel'),
(1806,'9660','Opbrakel'),
(1807,'9255','Opdorp'),
(1808,'3660','Opglabbeek'),
(1809,'3630','Opgrimbie'),
(1810,'1421','Ophain-Bois-Seigneur-Isaac'),
(1811,'9500','Ophasselt'),
(1812,'3870','Opheers'),
(1813,'1357','Opheylissem'),
(1814,'3640','Ophoven'),
(1815,'3960','Opitter'),
(1816,'3300','Oplinter'),
(1817,'3680','Opoeteren'),
(1818,'6852','Opont'),
(1819,'1315','Opprebais'),
(1820,'2890','Oppuurs'),
(1821,'3360','Opvelp'),
(1822,'1745','Opwijk'),
(1823,'1360','Orbais'),
(1824,'5550','Orchimont'),
(1825,'7501','Orcq'),
(1826,'3800','Ordingen'),
(1827,'5640','Oret'),
(1828,'4360','Oreye'),
(1829,'6880','Orgeo'),
(1830,'7802','Ormeignies'),
(1831,'1350','Orp-Le-Grand'),
(1832,'7750','Orroir'),
(1833,'3350','Orsmaal-Gussenhoven'),
(1834,'6983','Ortho'),
(1835,'7804','Ostiches'),
(1836,'8553','Otegem'),
(1837,'4210','Oteppe'),
(1838,'4340','Othée'),
(1839,'4360','Otrange'),
(1840,'3040','Ottenburg'),
(1841,'9420','Ottergem'),
(1842,'1340','Ottignies'),
(1843,'3050','Oud-Heverlee'),
(1844,'2360','Oud-Turnhout'),
(1845,'9200','Oudegem'),
(1846,'8600','Oudekapelle'),
(1847,'9700','Oudenaarde'),
(1848,'1600','Oudenaken'),
(1849,'8460','Oudenburg'),
(1850,'1160','Oudergem');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1851,'4590','Ouffet'),
(1852,'4102','Ougrée'),
(1853,'4680','Oupeye'),
(1854,'9406','Outer'),
(1855,'3321','Outgaarden'),
(1856,'4577','Outrelouxhe'),
(1857,'8582','Outrijve'),
(1858,'9750','Ouwegem'),
(1859,'9500','Overboelare'),
(1860,'3350','Overhespen'),
(1861,'3090','Overijse'),
(1862,'9290','Overmere'),
(1863,'3900','Overpelt'),
(1864,'3700','Overrepen'),
(1865,'3400','Overwinden'),
(1866,'3583','Paal'),
(1867,'4452','Paifve'),
(1868,'4560','Pailhe'),
(1869,'6850','Paliseul'),
(1870,'1760','Pamel'),
(1871,'7861','Papignies'),
(1872,'9661','Parike'),
(1873,'1012','Parlement de la communaut‚ française'),
(1874,'5012','Parlement Wallon'),
(1875,'8980','Passendale'),
(1876,'5575','Patignies'),
(1877,'7340','Pâturages'),
(1878,'9630','Paulatem'),
(1879,'7740','Pecq'),
(1880,'3990','Peer'),
(1881,'7120','Peissant'),
(1882,'4287','Pellaines'),
(1883,'3212','Pellenberg'),
(1884,'1670','Pepingen'),
(1885,'4860','Pepinster'),
(1886,'1820','Perk'),
(1887,'7640','Péronnes-Lez-Antoing'),
(1888,'7134','Péronnes-Lez-Binche'),
(1889,'7600','Péruwelz'),
(1890,'8600','Pervijze'),
(1891,'1360','Perwez'),
(1892,'5352','Perwez-Haillot'),
(1893,'5660','Pesche'),
(1894,'5590','Pessoux'),
(1895,'9800','Petegem-Aan-De-Leie'),
(1896,'9790','Petegem-Aan-De-Schelde'),
(1897,'5660','Pétigny'),
(1898,'5555','Petit-Fays'),
(1899,'4280','Petit-Hallet'),
(1900,'4800','Petit-Rechain');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1901,'7090','Petit-Roeulx-Lez-Braine'),
(1902,'7181','Petit-Roeulx-Lez-Nivelles'),
(1903,'6692','Petit-Thier'),
(1904,'5660','Petite-Chapelle'),
(1905,'1800','Peutie'),
(1906,'5600','Philippeville'),
(1907,'7160','Piéton'),
(1908,'1370','Piétrain'),
(1909,'1315','Piétrebais'),
(1910,'7904','Pipaix'),
(1911,'3700','Piringen'),
(1912,'6240','Pironchamps'),
(1913,'8740','Pittem'),
(1914,'4122','Plainevaux'),
(1915,'1380','Plancenoit'),
(1916,'7782','Ploegsteert'),
(1917,'2275','Poederlee'),
(1918,'9880','Poeke'),
(1919,'8920','Poelkapelle'),
(1920,'9850','Poesele'),
(1921,'9401','Pollare'),
(1922,'4800','Polleur'),
(1923,'4910','Polleur'),
(1924,'8647','Pollinkhove'),
(1925,'7322','Pommeroeul'),
(1926,'5574','Pondrôme'),
(1927,'6230','Pont-À-Celles'),
(1928,'6250','Pont-De-Loup'),
(1929,'5380','Pontillas'),
(1930,'8970','Poperinge'),
(1931,'2382','Poppel'),
(1932,'7760','Popuelles'),
(1933,'5370','Porcheresse'),
(1934,'6929','Porcheresse'),
(1935,'1100','Postcheque'),
(1936,'7760','Pottes'),
(1937,'4280','Poucet'),
(1938,'4171','Poulseur'),
(1939,'6830','Poupehan'),
(1940,'4350','Pousset'),
(1941,'5660','Presgaux'),
(1942,'6250','Presles'),
(1943,'5170','Profondeville'),
(1944,'8972','Proven'),
(1945,'5650','Pry'),
(1946,'2242','Pulderbos'),
(1947,'2243','Pulle'),
(1948,'5530','Purnode'),
(1949,'5550','Pussemange'),
(1950,'2580','Putte');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(1951,'2870','Puurs'),
(1952,'7390','Quaregnon'),
(1953,'7540','Quartes'),
(1954,'1430','Quenast'),
(1955,'4610','Queue-Du-Bois'),
(1956,'7972','Quevaucamps'),
(1957,'7040','Quévy-Le-Grand'),
(1958,'7040','Quévy-Le-Petit'),
(1959,'7380','Quiévrain'),
(1960,'1006','Raad van de Vlaamse Gemeenschapscommissie'),
(1961,'6792','Rachecourt'),
(1962,'4287','Racour'),
(1963,'4730','Raeren'),
(1964,'6532','Ragnies'),
(1965,'4987','Rahier'),
(1966,'7971','Ramegnies'),
(1967,'7520','Ramegnies-Chin'),
(1968,'4557','Ramelot'),
(1969,'1367','Ramillies'),
(1970,'1880','Ramsdonk'),
(1971,'2230','Ramsel'),
(1972,'8301','Ramskapelle'),
(1973,'8620','Ramskapelle'),
(1974,'6470','Rance'),
(1975,'6043','Ransart'),
(1976,'3470','Ransberg'),
(1977,'2520','Ranst'),
(1978,'2380','Ravels'),
(1979,'7804','Rebaix'),
(1980,'1430','Rebecq-Rognon'),
(1981,'4780','Recht'),
(1982,'6800','Recogne'),
(1983,'6890','Redu'),
(1984,'2840','Reet'),
(1985,'3621','Rekem'),
(1986,'8930','Rekkem'),
(1987,'1731','Relegem'),
(1988,'6800','Remagne'),
(1989,'3791','Remersdaal'),
(1990,'4350','Remicourt'),
(1991,'6987','Rendeux'),
(1992,'8647','Reninge'),
(1993,'8970','Reningelst'),
(1994,'6500','Renlies'),
(1995,'3950','Reppel'),
(1996,'7134','Ressaix'),
(1997,'9551','Ressegem'),
(1998,'6927','Resteigne'),
(1999,'2470','Retie'),
(2000,'4621','Retinne');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(2001,'4790','Reuland'),
(2002,'6210','Rèves'),
(2003,'5080','Rhisnes'),
(2004,'4600','Richelle'),
(2005,'3770','Riemst'),
(2006,'5575','Rienne'),
(2007,'6464','Rièzes'),
(2008,'3840','Rijkel'),
(2009,'2310','Rijkevorsel'),
(2010,'3740','Rijkhoven'),
(2011,'2820','Rijmenam'),
(2012,'3700','Riksingen'),
(2013,'3202','Rillaar'),
(2014,'5170','Rivière'),
(2015,'1330','Rixensart'),
(2016,'6460','Robechies'),
(2017,'6769','Robelmont'),
(2018,'4950','Robertville'),
(2019,'9630','Roborst'),
(2020,'5580','Rochefort'),
(2021,'6830','Rochehaut'),
(2022,'4761','Rocherath'),
(2023,'4690','Roclenge-Sur-Geer'),
(2024,'4000','Rocourt'),
(2025,'8972','Roesbrugge-Haringe'),
(2026,'8800','Roeselare'),
(2027,'5651','Rognée'),
(2028,'7387','Roisin'),
(2029,'8460','Roksem'),
(2030,'8510','Rollegem'),
(2031,'8880','Rollegem-Kapelle'),
(2032,'4347','Roloux'),
(2033,'5600','Roly'),
(2034,'5600','Romedenne'),
(2035,'5680','Romerée'),
(2036,'3730','Romershoven'),
(2037,'4624','Romsée'),
(2038,'7623','Rongy'),
(2039,'7090','Ronquières'),
(2040,'9600','Ronse'),
(2041,'9932','Ronsele'),
(2042,'3370','Roosbeek'),
(2043,'1760','Roosdaal'),
(2044,'5620','Rosée'),
(2045,'6250','Roselies'),
(2046,'1331','Rosières'),
(2047,'3740','Rosmeer'),
(2048,'4257','Rosoux-Crenwick'),
(2049,'6730','Rossignol'),
(2050,'3650','Rotem');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(2051,'4120','Rotheux-Rimière'),
(2052,'3110','Rotselaar'),
(2053,'7601','Roucourt'),
(2054,'7120','Rouveroy'),
(2055,'4140','Rouvreux'),
(2056,'6044','Roux'),
(2057,'1315','Roux-Miroir'),
(2058,'6900','Roy'),
(2059,'9630','Rozebeke'),
(2060,'1044','RTBF'),
(2061,'1033','RTL-TVI'),
(2062,'8020','Ruddervoorde'),
(2063,'6760','Ruette'),
(2064,'9690','Ruien'),
(2065,'1601','Ruisbroek'),
(2066,'2870','Ruisbroek'),
(2067,'8755','Ruiselede'),
(2068,'3870','Rukkelingen-Loon'),
(2069,'6724','Rulles'),
(2070,'8800','Rumbeke'),
(2071,'7610','Rumes'),
(2072,'7540','Rumillies'),
(2073,'3454','Rummen'),
(2074,'3400','Rumsdorp'),
(2075,'2840','Rumst'),
(2076,'3803','Runkelen'),
(2077,'9150','Rupelmonde'),
(2078,'7750','Russeignies'),
(2079,'3700','Rutten'),
(2080,'3798','S Gravenvoeren'),
(2081,'5010','SA SudPresse'),
(2082,'6221','Saint-Amand'),
(2083,'4606','Saint-Andr‚'),
(2084,'5620','Saint-Aubin'),
(2085,'7034','Saint-Denis'),
(2086,'5081','Saint-Denis-Bovesse'),
(2087,'4470','Saint-Georges-Sur-Meuse'),
(2088,'5640','Saint-Gérard'),
(2089,'5310','Saint-Germain'),
(2090,'1450','Saint-Géry'),
(2091,'7330','Saint-Ghislain'),
(2092,'6870','Saint-Hubert'),
(2093,'1370','Saint-Jean-Geest'),
(2094,'6747','Saint-Léger'),
(2095,'7730','Saint-Léger'),
(2096,'5003','Saint-Marc'),
(2097,'6762','Saint-Mard'),
(2098,'5190','Saint-Martin'),
(2099,'7500','Saint-Maur'),
(2100,'6887','Saint-Médard');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(2101,'4420','Saint-Nicolas'),
(2102,'6800','Saint-Pierre'),
(2103,'4672','Saint-Remy'),
(2104,'6460','Saint-Remy'),
(2105,'1370','Saint-Remy-Geest'),
(2106,'7912','Saint-Sauveur'),
(2107,'5002','Saint-Servais'),
(2108,'4550','Saint-Séverin'),
(2109,'7030','Saint-Symphorien'),
(2110,'7100','Saint-Vaast'),
(2111,'6730','Saint-Vincent'),
(2112,'6820','Sainte-Cécile'),
(2113,'6800','Sainte-Marie-Chevigny'),
(2114,'6740','Sainte-Marie-Sur-Semois'),
(2115,'1480','Saintes'),
(2116,'4671','Saive'),
(2117,'6460','Salles'),
(2118,'5600','Samart'),
(2119,'6982','Samrée'),
(2120,'4780','Sankt-Vith'),
(2121,'7080','Sars-La-Bruyère'),
(2122,'6542','Sars-La-Buissière'),
(2123,'5330','Sart-Bernard'),
(2124,'5575','Sart-Custinne'),
(2125,'1495','Sart-Dames-Avelines'),
(2126,'5600','Sart-En-Fagne'),
(2127,'5070','Sart-Eustache'),
(2128,'4845','Sart-Lez-Spa'),
(2129,'5070','Sart-Saint-Laurent'),
(2130,'6470','Sautin'),
(2131,'5600','Sautour'),
(2132,'5030','Sauvenière'),
(2133,'1101','Scanning'),
(2134,'1030','Schaarbeek'),
(2135,'3290','Schaffen'),
(2136,'3732','Schalkhoven'),
(2137,'5364','Schaltin'),
(2138,'9820','Schelderode'),
(2139,'9860','Scheldewindeke'),
(2140,'2627','Schelle'),
(2141,'9260','Schellebelle'),
(2142,'9506','Schendelbeke'),
(2143,'1703','Schepdaal'),
(2144,'3270','Scherpenheuvel'),
(2145,'2970','Schilde'),
(2146,'9200','Schoonaarde'),
(2147,'8433','Schore'),
(2148,'9688','Schorisse'),
(2149,'2900','Schoten'),
(2150,'2223','Schriek');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(2151,'8700','Schuiferskapelle'),
(2152,'3540','Schulen'),
(2153,'4782','Schönberg'),
(2154,'5300','Sclayn'),
(2155,'5361','Scy'),
(2156,'5300','Seilles'),
(2157,'6781','Sélange'),
(2158,'6596','Seloignes'),
(2159,'9890','Semmerzake'),
(2160,'7180','Seneffe'),
(2161,'6832','Sensenruth'),
(2162,'4557','Seny'),
(2163,'5630','Senzeilles'),
(2164,'6940','Septon'),
(2165,'4100','Seraing'),
(2166,'4537','Seraing-Le-Chƒteau'),
(2167,'5590','Serinchamps'),
(2168,'9260','Serskamp'),
(2169,'5521','Serville'),
(2170,'7010','SHAPE'),
(2171,'6640','Sibret'),
(2172,'6750','Signeulx'),
(2173,'8340','Sijsele'),
(2174,'5630','Silenrieux'),
(2175,'7830','Silly'),
(2176,'9112','Sinaai-Waas'),
(2177,'5377','Sinsin'),
(2178,'1082','Sint-Agatha-Berchem'),
(2179,'3040','Sint-Agatha-Rode'),
(2180,'2890','Sint-Amands'),
(2181,'9040','Sint-Amandsberg'),
(2182,'8200','Sint-Andries'),
(2183,'9550','Sint-Antelinks'),
(2184,'8710','Sint-Baafs-Vijve'),
(2185,'9630','Sint-Blasius-Boekel'),
(2186,'8554','Sint-Denijs'),
(2187,'9630','Sint-Denijs-Boekel'),
(2188,'9051','Sint-Denijs-Westrem'),
(2189,'8793','Sint-Eloois-Vijve'),
(2190,'8880','Sint-Eloois-Winkel'),
(2191,'1640','Sint-Genesius-Rode'),
(2192,'1060','Sint-Gillis'),
(2193,'9200','Sint-Gillis-Dendermonde'),
(2194,'9170','Sint-Gillis-Waas'),
(2195,'9620','Sint-Goriks-Oudenhove'),
(2196,'3730','Sint-Huibrechts-Hern'),
(2197,'3910','Sint-Huibrechts-Lille'),
(2198,'8600','Sint-Jacobs-Kapelle'),
(2199,'8900','Sint-Jan'),
(2200,'9982','Sint-Jan-In-Eremo');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(2201,'1080','Sint-Jans-Molenbeek'),
(2202,'2960','Sint-Job-In-''T-Goor'),
(2203,'1210','Sint-Joost-Ten-Noode'),
(2204,'8620','Sint-Joris'),
(2205,'8730','Sint-Joris'),
(2206,'3051','Sint-Joris-Weert'),
(2207,'3390','Sint-Joris-Winge'),
(2208,'2860','Sint-Katelijne-Waver'),
(2209,'1742','Sint-Katherina-Lombeek'),
(2210,'9667','Sint-Kornelis-Horebeke'),
(2211,'8310','Sint-Kruis'),
(2212,'9042','Sint-Kruis-Winkel'),
(2213,'1750','Sint-Kwintens-Lennik'),
(2214,'3500','Sint-Lambrechts-Herk'),
(2215,'1200','Sint-Lambrechts-Woluwe'),
(2216,'9980','Sint-Laureins'),
(2217,'1600','Sint-Laureins-Berchem'),
(2218,'2960','Sint-Lenaarts'),
(2219,'9550','Sint-Lievens-Esse'),
(2220,'9520','Sint-Lievens-Houtem'),
(2221,'9981','Sint-Margriete'),
(2222,'3300','Sint-Margriete-Houtem'),
(2223,'3470','Sint-Margriete-Houtem'),
(2224,'9667','Sint-Maria-Horebeke'),
(2225,'9630','Sint-Maria-Latem'),
(2226,'9570','Sint-Maria-Lierde'),
(2227,'9620','Sint-Maria-Oudenhove'),
(2228,'9660','Sint-Maria-Oudenhove'),
(2229,'1700','Sint-Martens-Bodegem'),
(2230,'9830','Sint-Martens-Latem'),
(2231,'9800','Sint-Martens-Leerne'),
(2232,'1750','Sint-Martens-Lennik'),
(2233,'9572','Sint-Martens-Lierde'),
(2234,'3790','Sint-Martens-Voeren'),
(2235,'8200','Sint-Michiels'),
(2236,'9100','Sint-Niklaas'),
(2237,'9170','Sint-Pauwels'),
(2238,'1541','Sint-Pieters-Kapelle'),
(2239,'8433','Sint-Pieters-Kapelle'),
(2240,'1600','Sint-Pieters-Leeuw'),
(2241,'3220','Sint-Pieters-Rode'),
(2242,'3792','Sint-Pieters-Voeren'),
(2243,'1150','Sint-Pieters-Woluwe'),
(2244,'8690','Sint-Rijkers'),
(2245,'1932','Sint-Stevens-Woluwe'),
(2246,'3800','Sint-Truiden'),
(2247,'1700','Sint-Ulriks-Kapelle'),
(2248,'0612','Sinterklaas'),
(2249,'4851','Sippenaeken'),
(2250,'7332','Sirault');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(2251,'6470','Sivry'),
(2252,'9940','Sleidinge'),
(2253,'8433','Slijpe'),
(2254,'4450','Slins'),
(2255,'3700','Sluizen'),
(2256,'9506','Smeerebbe-Vloerzegem'),
(2257,'9340','Smetlede'),
(2258,'6890','Smuid'),
(2259,'8470','Snaaskerke'),
(2260,'8490','Snellegem'),
(2261,'4557','Soheit-Tinlot'),
(2262,'6920','Sohier'),
(2263,'7060','Soignies'),
(2264,'4861','Soiron'),
(2265,'6500','Solre-Saint-Géry'),
(2266,'6560','Solre-Sur-Sambre'),
(2267,'5140','Sombreffe'),
(2268,'5377','Somme-Leuze'),
(2269,'6769','Sommethonne'),
(2270,'5523','Sommière'),
(2271,'5651','Somzée'),
(2272,'5340','Sorée'),
(2273,'5333','Sorinne-La-Longue'),
(2274,'5503','Sorinnes'),
(2275,'5537','Sosoye'),
(2276,'4920','Sougn‚-Remouchamps'),
(2277,'5680','Soulme'),
(2278,'4630','Soumagne'),
(2279,'5630','Soumoy'),
(2280,'4950','Sourbrodt'),
(2281,'6182','Souvret'),
(2282,'5590','Sovet'),
(2283,'6997','Soy'),
(2284,'5150','Soye'),
(2285,'4900','Spa'),
(2286,'3510','Spalbeek'),
(2287,'7032','Spiennes'),
(2288,'8587','Spiere'),
(2289,'5530','Spontin'),
(2290,'4140','Sprimont'),
(2291,'5190','Spy'),
(2292,'2940','Stabroek'),
(2293,'8840','Staden'),
(2294,'8490','Stalhille'),
(2295,'7973','Stambruges'),
(2296,'5646','Stave'),
(2297,'8691','Stavele'),
(2298,'4970','Stavelot'),
(2299,'9140','Steendorp'),
(2300,'1840','Steenhuffel');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(2301,'9550','Steenhuize-Wijnhuize'),
(2302,'8630','Steenkerke'),
(2303,'7090','Steenkerque'),
(2304,'1820','Steenokkerzeel'),
(2305,'9190','Stekene'),
(2306,'4801','Stembert'),
(2307,'8400','Stene'),
(2308,'1933','Sterrebeek'),
(2309,'3512','Stevoort'),
(2310,'3650','Stokkem'),
(2311,'3511','Stokrooie'),
(2312,'4987','Stoumont'),
(2313,'6887','Straimont'),
(2314,'6511','Strée'),
(2315,'4577','Strée-Lez-Huy'),
(2316,'7110','Strépy-Bracquegnies'),
(2317,'9620','Strijpen'),
(2318,'1760','Strijtem'),
(2319,'1853','Strombeek-Bever'),
(2320,'8600','Stuivekenskerke'),
(2321,'5020','Suarlée'),
(2322,'5550','Sugny'),
(2323,'5600','Surice'),
(2324,'6812','Suxy'),
(2325,'6661','Tailles'),
(2326,'7618','Taintignies'),
(2327,'5060','Tamines'),
(2328,'5651','Tarcienne'),
(2329,'4163','Tavier'),
(2330,'5310','Taviers'),
(2331,'6662','Tavigny'),
(2332,'6927','Tellin'),
(2333,'7520','Templeuve'),
(2334,'5020','Temploux'),
(2335,'9140','Temse'),
(2336,'6970','Tenneville'),
(2337,'1790','Teralfene'),
(2338,'2840','Terhagen'),
(2339,'6813','Termes'),
(2340,'1740','Ternat'),
(2341,'7333','Tertre'),
(2342,'3080','Tervuren'),
(2343,'4560','Terwagne'),
(2344,'3980','Tessenderlo'),
(2345,'3272','Testelt'),
(2346,'3793','Teuven'),
(2347,'4910','Theux'),
(2348,'6717','Thiaumont'),
(2349,'7070','Thieu'),
(2350,'7901','Thieulain');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(2351,'7061','Thieusies'),
(2352,'6230','Thiméon'),
(2353,'4890','Thimister'),
(2354,'7533','Thimougies'),
(2355,'1402','Thines'),
(2356,'6500','Thirimont'),
(2357,'4280','Thisnes'),
(2358,'4791','Thommen'),
(2359,'5300','Thon'),
(2360,'1360','Thorembais-Les-Béguines'),
(2361,'1360','Thorembais-Saint-Trond'),
(2362,'7830','Thoricourt'),
(2363,'6536','Thuillies'),
(2364,'6530','Thuin'),
(2365,'7350','Thulin'),
(2366,'7971','Thumaide'),
(2367,'5621','Thy-Le-Baudouin'),
(2368,'5651','Thy-Le-Chƒteau'),
(2369,'5502','Thynes'),
(2370,'4367','Thys'),
(2371,'8573','Tiegem'),
(2372,'2460','Tielen'),
(2373,'9140','Tielrode'),
(2374,'3390','Tielt'),
(2375,'8700','Tielt'),
(2376,'3300','Tienen'),
(2377,'4630','Tignée'),
(2378,'4500','Tihange'),
(2379,'3150','Tildonk'),
(2380,'4130','Tilff'),
(2381,'6680','Tillet'),
(2382,'4420','Tilleur'),
(2383,'5380','Tillier'),
(2384,'1495','Tilly'),
(2385,'4557','Tinlot'),
(2386,'6637','Tintange'),
(2387,'6730','Tintigny'),
(2388,'2830','Tisselt'),
(2389,'6700','Toernich'),
(2390,'6941','Tohogne'),
(2391,'1570','Tollembeek'),
(2392,'3700','Tongeren'),
(2393,'2260','Tongerlo'),
(2394,'3960','Tongerlo'),
(2395,'7951','Tongre-Notre-Dame'),
(2396,'7950','Tongre-Saint-Martin'),
(2397,'5140','Tongrinne'),
(2398,'6717','Tontelange'),
(2399,'6767','Torgny'),
(2400,'8820','Torhout');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(2401,'4263','Tourinne'),
(2402,'1320','Tourinnes-La-Grosse'),
(2403,'1457','Tourinnes-Saint-Lambert'),
(2404,'7500','Tournai'),
(2405,'6840','Tournay'),
(2406,'7904','Tourpes'),
(2407,'6890','Transinne'),
(2408,'6183','Trazegnies'),
(2409,'5670','Treignes'),
(2410,'4670','Trembleur'),
(2411,'3120','Tremelo'),
(2412,'7100','Trivières'),
(2413,'4280','Trognée'),
(2414,'4980','Trois-Ponts'),
(2415,'1480','Tubize'),
(2416,'2300','Turnhout'),
(2417,'6833','Ucimont'),
(2418,'3631','Uikhoven'),
(2419,'9290','Uitbergen'),
(2420,'8370','Uitkerke'),
(2421,'1180','Ukkel'),
(2422,'3832','Ulbeek'),
(2423,'5310','Upigny'),
(2424,'9910','Ursel'),
(2425,'3054','Vaalbeek'),
(2426,'3770','Val-Meer'),
(2427,'6741','Vance'),
(2428,'2431','Varendonk'),
(2429,'8490','Varsenare'),
(2430,'5680','Vaucelles'),
(2431,'7536','Vaulx'),
(2432,'6462','Vaulx-Lez-Chimay'),
(2433,'6960','Vaux-Chavanne'),
(2434,'4530','Vaux-Et-Borset'),
(2435,'6640','Vaux-Lez-Rosières'),
(2436,'4051','Vaux-Sous-Chèvremont'),
(2437,'6640','Vaux-Sur-Sûre'),
(2438,'3870','Vechmaal'),
(2439,'5020','Vedrin'),
(2440,'2431','Veerle'),
(2441,'5060','Velaine-Sur-Sambre'),
(2442,'7760','Velaines'),
(2443,'8210','Veldegem'),
(2444,'3620','Veldwezelt'),
(2445,'7120','Vellereille-Le-Sec'),
(2446,'7120','Vellereille-Les-Brayeux'),
(2447,'3806','Velm'),
(2448,'4460','Velroux'),
(2449,'3020','Veltem-Beisem'),
(2450,'9620','Velzeke-Ruddershove');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(2451,'5575','Vencimont'),
(2452,'1005','Verenigde Vergadering van de Gemeenschappelijke '),
(2453,'6440','Vergnies'),
(2454,'4537','Verlaine'),
(2455,'5370','Verlée'),
(2456,'9130','Verrebroek'),
(2457,'3370','Vertrijk'),
(2458,'4800','Verviers'),
(2459,'6870','Vesqueville'),
(2460,'3870','Veulen'),
(2461,'8630','Veurne'),
(2462,'5300','Vezin'),
(2463,'7538','Vezon'),
(2464,'9500','Viane'),
(2465,'8570','Vichte'),
(2466,'6690','Vielsalm'),
(2467,'4317','Viemme'),
(2468,'2240','Viersel'),
(2469,'4577','Vierset-Barse'),
(2470,'5670','Vierves-Sur-Viroin'),
(2471,'6230','Viesville'),
(2472,'1472','Vieux-Genappe'),
(2473,'4530','Vieux-Waleffe'),
(2474,'4190','Vieuxville'),
(2475,'6890','Villance'),
(2476,'4260','Ville-En-Hesbaye'),
(2477,'7322','Ville-Pommeroeul'),
(2478,'7070','Ville-Sur-Haine'),
(2479,'7334','Villerot'),
(2480,'4161','Villers-Aux-Tours'),
(2481,'5630','Villers-Deux-Eglises'),
(2482,'6823','Villers-Devant-Orval'),
(2483,'5600','Villers-En-Fagne'),
(2484,'4340','Villers-L''Evêque'),
(2485,'6600','Villers-La-Bonne-Eau'),
(2486,'6769','Villers-La-Loue'),
(2487,'6460','Villers-La-Tour'),
(2488,'1495','Villers-La-Ville'),
(2489,'4530','Villers-Le-Bouillet'),
(2490,'5600','Villers-Le-Gambon'),
(2491,'4280','Villers-Le-Peuplier'),
(2492,'4550','Villers-Le-Temple'),
(2493,'5080','Villers-Lez-Heest'),
(2494,'7812','Villers-Notre-Dame'),
(2495,'6210','Villers-Perwin'),
(2496,'6280','Villers-Poterie'),
(2497,'7812','Villers-Saint-Amand'),
(2498,'7031','Villers-Saint-Ghislain'),
(2499,'4453','Villers-Saint-Siméon'),
(2500,'6941','Villers-Sainte-Gertrude');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(2501,'5580','Villers-Sur-Lesse'),
(2502,'6740','Villers-Sur-Semois'),
(2503,'1800','Vilvoorde'),
(2504,'4520','Vinalmont'),
(2505,'9921','Vinderhoute'),
(2506,'8630','Vinkem'),
(2507,'9800','Vinkt'),
(2508,'6461','Virelles'),
(2509,'1460','Virginal-Samme'),
(2510,'6760','Virton'),
(2511,'4600','Vis‚'),
(2512,'3300','Vissenaken'),
(2513,'7511','Vitrine Magique'),
(2514,'5070','Vitrival'),
(2515,'4683','Vivegnis'),
(2516,'6833','Vivy'),
(2517,'1011','Vlaams Parlement'),
(2518,'8600','Vladslo'),
(2519,'8908','Vlamertinge'),
(2520,'9420','Vlekkem'),
(2521,'1602','Vlezenbeek'),
(2522,'3724','Vliermaal'),
(2523,'3721','Vliermaalroot'),
(2524,'9520','Vlierzele'),
(2525,'3770','Vlijtingen'),
(2526,'2340','Vlimmeren'),
(2527,'8421','Vlissegem'),
(2528,'7880','Vloesberg'),
(2529,'5600','Vodecée'),
(2530,'5680','Vodelée'),
(2531,'5650','Vogenée'),
(2532,'9700','Volkegem'),
(2533,'1570','Vollezele'),
(2534,'5570','Vonêche'),
(2535,'9400','Voorde'),
(2536,'8902','Voormezele'),
(2537,'3840','Voort'),
(2538,'4347','Voroux-Goreux'),
(2539,'4451','Voroux-Lez-Liers'),
(2540,'2290','Vorselaar'),
(2541,'3890','Vorsen'),
(2542,'1190','Vorst'),
(2543,'2430','Vorst'),
(2544,'2350','Vosselaar'),
(2545,'9850','Vosselare'),
(2546,'3080','Vossem'),
(2547,'4041','Vottem'),
(2548,'9120','Vrasene'),
(2549,'2531','Vremde'),
(2550,'3700','Vreren');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(2551,'5550','Vresse-Sur-Semois'),
(2552,'3770','Vroenhoven'),
(2553,'1043','VRT'),
(2554,'1818','VTM'),
(2555,'3630','Vucht'),
(2556,'9890','Vurste'),
(2557,'4570','Vyle-Et-Tharoul'),
(2558,'3473','Waanrode'),
(2559,'9506','Waarbeke'),
(2560,'8020','Waardamme'),
(2561,'2550','Waarloos'),
(2562,'8581','Waarmaarde'),
(2563,'9950','Waarschoot'),
(2564,'3401','Waasmont'),
(2565,'9250','Waasmunster'),
(2566,'7784','Waasten'),
(2567,'9185','Wachtebeke'),
(2568,'7971','Wadelincourt'),
(2569,'6223','Wagnelée'),
(2570,'6900','Waha'),
(2571,'5377','Waillet'),
(2572,'8720','Wakken'),
(2573,'5650','Walcourt'),
(2574,'2800','Walem'),
(2575,'1457','Walhain-Saint-Paul'),
(2576,'4711','Walhorn'),
(2577,'3401','Walsbets'),
(2578,'3401','Walshoutem'),
(2579,'3740','Waltwilder'),
(2580,'1741','Wambeek'),
(2581,'5570','Wancennes'),
(2582,'4020','Wandre'),
(2583,'6224','Wanfercée-Baulet'),
(2584,'3400','Wange'),
(2585,'6220','Wangenies'),
(2586,'5564','Wanlin'),
(2587,'4980','Wanne'),
(2588,'7861','Wannebecq'),
(2589,'9772','Wannegem-Lede'),
(2590,'4280','Wansin'),
(2591,'4520','Wanze'),
(2592,'9340','Wanzele'),
(2593,'7548','Warchin'),
(2594,'7740','Warcoing'),
(2595,'6600','Wardin'),
(2596,'8790','Waregem'),
(2597,'4300','Waremme'),
(2598,'4217','Waret-L''Evêque'),
(2599,'5310','Waret-La-Chaussée'),
(2600,'5080','Warisoulx');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(2601,'5537','Warnant'),
(2602,'4530','Warnant-Dreye'),
(2603,'7340','Warquignies'),
(2604,'4608','Warsage'),
(2605,'4590','Warzée'),
(2606,'7340','Wasmes'),
(2607,'7604','Wasmes-Audemez-Briffoeil'),
(2608,'7390','Wasmuel'),
(2609,'4219','Wasseiges'),
(2610,'9988','Waterland-Oudeman'),
(2611,'1410','Waterloo'),
(2612,'1170','Watermaal-Bosvoorde'),
(2613,'9988','Watervliet'),
(2614,'8978','Watou'),
(2615,'7910','Wattripont'),
(2616,'7131','Waudrez'),
(2617,'5540','Waulsort'),
(2618,'1440','Wauthier-Braine'),
(2619,'1300','Wavre'),
(2620,'5580','Wavreille'),
(2621,'6210','Wayaux'),
(2622,'1474','Ways'),
(2623,'3290','Webbekom'),
(2624,'2275','Wechelderzande'),
(2625,'2381','Weelde'),
(2626,'1982','Weerde'),
(2627,'2880','Weert'),
(2628,'4860','Wegnez'),
(2629,'5523','Weillen'),
(2630,'4950','Weismes'),
(2631,'9700','Welden'),
(2632,'4840','Welkenraedt'),
(2633,'9473','Welle'),
(2634,'3830','Wellen'),
(2635,'6920','Wellin'),
(2636,'1780','Wemmel'),
(2637,'8420','Wenduine'),
(2638,'5100','Wépion'),
(2639,'4190','Werbomont'),
(2640,'3118','Werchter'),
(2641,'6940','Wéris'),
(2642,'8610','Werken'),
(2643,'3730','Werm'),
(2644,'8940','Wervik'),
(2645,'3150','Wespelaar'),
(2646,'8434','Westende'),
(2647,'2260','Westerlo'),
(2648,'8300','Westkapelle'),
(2649,'8460','Westkerke'),
(2650,'2390','Westmalle');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(2651,'2235','Westmeerbeek'),
(2652,'8954','Westouter'),
(2653,'9230','Westrem'),
(2654,'8840','Westrozebeke'),
(2655,'8640','Westvleteren'),
(2656,'9230','Wetteren'),
(2657,'8560','Wevelgem'),
(2658,'7620','Wez-Velvain'),
(2659,'3111','Wezemaal'),
(2660,'1970','Wezembeek-Oppem'),
(2661,'3401','Wezeren'),
(2662,'6666','Wibrin'),
(2663,'9260','Wichelen'),
(2664,'3700','Widooie'),
(2665,'2222','Wiekevorst'),
(2666,'8710','Wielsbeke'),
(2667,'5100','Wierde'),
(2668,'7608','Wiers'),
(2669,'5571','Wiesme'),
(2670,'9280','Wieze'),
(2671,'7370','Wihéries'),
(2672,'4452','Wihogne'),
(2673,'3990','Wijchmaal'),
(2674,'3850','Wijer'),
(2675,'3018','Wijgmaal'),
(2676,'2110','Wijnegem'),
(2677,'3670','Wijshagen'),
(2678,'8953','Wijtschate'),
(2679,'3803','Wilderen'),
(2680,'7904','Willaupuis'),
(2681,'3370','Willebringen'),
(2682,'2830','Willebroek'),
(2683,'7506','Willemeau'),
(2684,'5575','Willerzie'),
(2685,'2610','Wilrijk'),
(2686,'3012','Wilsele'),
(2687,'8431','Wilskerke'),
(2688,'3501','Wimmertingen'),
(2689,'5570','Winenne'),
(2690,'8750','Wingene'),
(2691,'3020','Winksele'),
(2692,'3722','Wintershoven'),
(2693,'6860','Witry'),
(2694,'7890','Wodecq'),
(2695,'8640','Woesten'),
(2696,'6780','Wolkrange'),
(2697,'1861','Wolvertem'),
(2698,'2160','Wommelgem'),
(2699,'3350','Wommersom'),
(2700,'4690','Wonck');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(2701,'9032','Wondelgem'),
(2702,'9800','Wontergem'),
(2703,'9790','Wortegem'),
(2704,'2323','Wortel'),
(2705,'9550','Woubrechtegem'),
(2706,'8600','Woumen'),
(2707,'8670','Wulpen'),
(2708,'8952','Wulvergem'),
(2709,'8630','Wulveringem'),
(2710,'2990','Wuustwezel'),
(2711,'4652','Xhendelesse'),
(2712,'4432','Xhendremael'),
(2713,'4190','Xhoris'),
(2714,'4550','Yernée-Fraineux'),
(2715,'7513','Yves Rocher'),
(2716,'5650','Yves-Gomezée'),
(2717,'5530','Yvoir'),
(2718,'9080','Zaffelare'),
(2719,'9506','Zandbergen'),
(2720,'8680','Zande'),
(2721,'2240','Zandhoven'),
(2722,'2040','Zandvliet'),
(2723,'8400','Zandvoorde'),
(2724,'8980','Zandvoorde'),
(2725,'9500','Zarlardinge'),
(2726,'8610','Zarren'),
(2727,'1930','Zaventem'),
(2728,'8210','Zedelgem'),
(2729,'8380','Zeebrugge'),
(2730,'9660','Zegelsem'),
(2731,'9240','Zele'),
(2732,'3545','Zelem'),
(2733,'1731','Zellik'),
(2734,'9060','Zelzate'),
(2735,'1980','Zemst'),
(2736,'3800','Zepperen'),
(2737,'8490','Zerkegem'),
(2738,'1370','Zétrud-Lumay'),
(2739,'8470','Zevekote'),
(2740,'9080','Zeveneken'),
(2741,'9800','Zeveren'),
(2742,'9840','Zevergem'),
(2743,'3271','Zichem'),
(2744,'3770','Zichen-Zussen-Bolder'),
(2745,'8902','Zillebeke'),
(2746,'9750','Zingem'),
(2747,'2260','Zoerle-Parwijs'),
(2748,'2980','Zoersel'),
(2749,'3550','Zolder'),
(2750,'9930','Zomergem');

insert into `PrulariaCom`.`Plaatsen` (plaatsId, postcode, plaats) 
values 
(2751,'3520','Zonhoven'),
(2752,'8980','Zonnebeke'),
(2753,'9520','Zonnegem'),
(2754,'9620','Zottegem'),
(2755,'8630','Zoutenaaie'),
(2756,'3440','Zoutleeuw'),
(2757,'8904','Zuidschote'),
(2758,'8377','Zuienkerke'),
(2759,'9870','Zulte'),
(2760,'9690','Zulzeke'),
(2761,'3690','Zutendaal'),
(2762,'8550','Zwevegem'),
(2763,'8750','Zwevezele'),
(2764,'9052','Zwijnaarde'),
(2765,'2070','Zwijndrecht');

insert into `PrulariaCom`.`Betaalwijzes` (betaalwijzeId, naam) 
values
(1, 'Kredietkaart'),
(2, 'Overschrijving');

insert into `PrulariaCom`.`BestellingsStatussen` (bestellingsStatusId, naam) 
values
(1, 'Lopend'),
(2, 'Betaald'),
(3, 'Geannuleerd'),
(4, 'Klaarmaken'),
(5, 'Onderweg'),
(6, 'Geleverd'),
(7, 'Verloren'),
(8, 'Beschadigd'),
(9, 'Retour'), -- pakjesdienst staat aan de deur met het pakje waar alle producten van de bestelling in zitten
(10, 'RetourInStock'); -- alle producten uit retour zijn terug in het magazijn geplaatst

insert into `PrulariaCom`.`UitgaandeLeveringsStatussen` (uitgaandeLeveringsStatusId, naam) 
values
(1, 'Onderweg'),
(2, 'Geleverd'),
(3, 'Verloren'),
(4, 'Beschadigd'),
(5, 'Retour'),
(6, 'RetourInStock');

-- anonieme gebruikersaccount
insert into `PrulariaCom`.`GebruikersAccounts` (gebruikersAccountId, emailadres, paswoord, disabled) 
values (1, 'anoniemeKlant@prularia.com','',true);

-- magazijnplaatsen
drop procedure if exists createMagazijnplaatsen;

delimiter |

create procedure createMagazijnplaatsen()
begin
declare idValue int default 1;
declare rijValue int default ORD('A');
declare rekValue int default 0; 
WHILE (rijValue <= ORD('Z')) DO
	SET rekValue = 1;
    WHILE (rekValue <= 60) DO
		insert into MagazijnPlaatsen (magazijnplaatsid, rij, rek, aantal) 
        values (idValue, CHAR(rijValue), rekValue, 0);
        set rekValue = rekValue + 1;
        set idValue = idValue + 1;
	END WHILE;
    SET rijValue = rijValue + 1;
END WHILE;
end |

delimiter ;

call createMagazijnplaatsen;

drop procedure createMagazijnplaatsen;

-- securitygroepen
insert into SecurityGroepen (securitygroepid, naam) 
values 
(1, 'PHPwebsite'), 
(2, 'Cwebsite'),
(3, 'Javawebsite'),
(4, 'Adminwebsite');

-- events

use PrulariaCom;

set global event_scheduler = on;

-- voor PHPgebruiker 
-- er worden elke dag nieuwe artikelen geleverd

drop event if exists InkomendeLeveringElkeDag;

delimiter |

create event InkomendeLeveringElkeDag 
ON SCHEDULE every 1 day
starts adddate(adddate(current_date(), interval 1 day), interval 11 hour)
DO 
BEGIN
declare magazijnPlaatsIdValue int;
declare artikelIdValue int;
declare voorraadValue int;
declare maxAantalInMagazijnPlaatsValue int;
declare aantalInMagazijnPlaatsValue int;
insert into EventWachtrijArtikelen (artikelId, aantal, maxAantalInMagazijnPlaats) 
select artikelid, bestelpeil - voorraad, maxAantalInMagazijnPlaats 
from Artikelen 
where voorraad < minimumVoorraad and aantalBesteldLeverancier = 0;
insert into EventWachtrijArtikelen (artikelId, aantal, maxAantalInMagazijnPlaats) 
select artikelid, aantalBesteldLeverancier, maxAantalInMagazijnPlaats 
from Artikelen 
where voorraad < minimumVoorraad and aantalBesteldLeverancier > 0;
update Artikelen set voorraad = bestelpeil
where voorraad < minimumVoorraad and aantalBesteldLeverancier = 0 and artikelId>0;
update Artikelen set voorraad = voorraad + aantalBesteldLeverancier, aantalBesteldLeverancier = 0 
where voorraad < minimumVoorraad and aantalBesteldLeverancier > 0  and artikelId>0;
SET magazijnPlaatsIdValue = 1;
SET artikelIdValue=1;
WHILE ((magazijnPlaatsIdValue <= (select count(*) from MagazijnPlaatsen)) and (artikelIdValue <= (select count(*) from Artikelen))) DO
	SET voorraadValue = (select aantal from EventWachtrijArtikelen where artikelId=artikelIdValue);
	SET maxAantalInMagazijnPlaatsValue  = (select maxAantalInMagazijnPlaats from Artikelen where artikelId=artikelIdValue);
	WHILE (voorraadValue>0) and (magazijnPlaatsIdValue <= (select count(*) from MagazijnPlaatsen)) and 
          (artikelIdValue <= (select count(*) from Artikelen)) do
		  set aantalInMagazijnPlaatsValue = (select aantal from MagazijnPlaatsen where magazijnPlaatsId=magazijnPlaatsIdValue);
            if (aantalInMagazijnPlaatsValue=0) then
                select voorraadValue;
				if (voorraadValue < maxAantalInMagazijnPlaatsValue) then
					update MagazijnPlaatsen set artikelId=artikelIdValue, aantal=voorraadValue 
						where magazijnPlaatsId=magazijnPlaatsIdValue;
					set voorraadValue = 0;
				else
					update MagazijnPlaatsen set artikelId=artikelIdValue, aantal=maxAantalInMagazijnPlaatsValue 
                       where magazijnPlaatsId=magazijnPlaatsIdValue;
					set voorraadValue = voorraadValue - maxAantalInMagazijnPlaatsValue;            
				end if;
			end if;
            set  magazijnplaatsidValue = magazijnplaatsidValue + 1;          
        end while;
	set artikelidValue = artikelidValue + 1;
END WHILE;
delete from EventWachtrijArtikelen where artikelId>0;
END |

delimiter ;

drop event if exists UitgaandeLeveringElkeDag;

delimiter |

create event UitgaandeLeveringElkeDag 
ON SCHEDULE every 1 day
starts adddate(adddate(current_date(), interval 1 day), interval 10 hour)
DO 
BEGIN
update Bestellingen set bestellingsStatusId = 6 
where bestelId = (select bestelId from UitgaandeLeveringen 
                  where vertrekDatum < current_date() and uitgaandeLeveringsStatusId = 1);
update UitgaandeLeveringen
set uitgaandeLeveringsStatusId = 2, aankomstDatum=current_date() 
where vertrekDatum < current_date() and uitgaandeLeveringsStatusId = 1;
END |

delimiter ;

drop event if exists VerwijderVervallenActiecodesElkeDag;

delimiter |

create event VerwijderVervallenActiecodesElkeDag 
ON SCHEDULE every 1 day
starts adddate(adddate(current_date(), interval 1 day), interval 8 hour)
DO 
BEGIN
delete from Actiecodes where actiecodeId>0 and geldigTotDatum < current_date();
END |

delimiter ;


-- om de events op te vragen
-- SHOW EVENTS FROM PrulariaCom;

-- artikelen, bestellingen, klanten .....

use PrulariaCom;

insert into Categorieen (categorieId, naam, hoofdcategorieid) 
values 
(1, 'Huishouden', null),
(2, 'Schoonmaken', 1),
(3, 'Aan tafel', 1),
(4, 'Koken', 1),
(5, 'Bewaren', 1),
(6, 'Bestek', 3),
(7, 'Borden', 3),
(8, 'Potten en pannen',3),
(9, 'Opdienen',3),
(10, 'Glazen', 3),
(11, 'Tassen', 3),
(20, 'Klussen', null), 
(21, 'Handgereedschap', 20),
(22, 'Tuinieren', 20),
(23, 'Ijzerwaren', 20),
(24, 'Powertools', 20),
(30, 'Wonen', null),
(31, 'Eettafel', 30),
(32, 'Bijzettafel', 30),
(33, 'Stoel', 30),
(34, 'Kruk', 30),
(35, 'Salontafel', 30),
(36, 'Sofa', 30),
(37, 'TV-meubel', 30),
(38, 'Dressoir', 30),
(39, 'Lade-kast', 30),
(40, 'Wandrek', 30),
(41, 'Kapstok', 30),
(42, 'Staande lamp', 30),
(43, 'Hanglamp', 30);

insert into prulariacom.Leveranciers (leveranciersId, naam, btwnummer, straat, huisnummer, bus, plaatsId, familienaamContactpersoon, voornaamContactpersoon) 
values 
(1, 'Mooie meubels', '1234567890', 'Somersstraat', 22, null, 62, 'Deur', 'D.' ),
(2, 'Alles om te bewaren', '2345678901', 'Industrieweg', 50, null, 2701, 'Deksel', 'A.'),
(3, 'Tafelen en dineren', '3456789012', 'Interleuvenlaan', 2, null, 1037, 'Bord', 'X.'),
(4, 'Doe-het-zelf', '4567890123', 'Vlamingstraat', 10, null, 2657, 'Klusser', 'E'),
(5, 'Groothandel HierVindJeAlles', '5678901234', 'Thor Park', 8040, null, 790, 'Thor', 'I.');

insert into Artikelen 
(artikelId, naam, beschrijving, prijs, gewichtingram, minimumvoorraad, maximumvoorraad, voorraad, bestelpeil, maxAantalInMagazijnPLaats, leveranciersId) 
values
(1,'emmer 10 l','huishoudemmer inhoud 10 l',2,400,10,100,50,25,25, 5),
(2,'emmer 12 l','huishoudemmer inhoud 12 l',4,500,10,100,50,25,25, 5),
(3,'emmer 5 l','huishoudemmer inhoud 5 l',1.8,200,10,100,50,25,25, 5),
(4,'keukenstoel','houten keukenstoel wit',59,1200,10,100,50,25,6, 1),
(5,'keukenstoel','houten keukenstoel grijs',59,1200,10,100,50,25,6, 1),
(6,'keukenstoel','houten keukenstoel zwart',59,1200,10,100,50,25,6, 1),
(7,'keukenstoel','houten keukenstoel rood',59,1200,10,100,50,25,6, 1),
(8,'keukenstoel','kunststof keukenstoel wit',39,950,10,100,50,25,6, 1),
(9,'keukenstoel','kunststof keukenstoel grijs',39,950,10,100,50,25,6, 1),
(10,'keukenstoel','kunststof keukenstoel zwart',39,950,10,100,50,25,6, 1),
(11,'keukenstoel','kunststof keukenstoel rood',39,950,10,100,50,25,6, 1),
(12,'keukenstoel','lederen keukenstoel wit',199,1650,10,100,50,25,6, 1),
(13,'keukenstoel','lederen keukenstoel grijs',199,1650,10,100,50,25,6, 1),
(14,'keukenstoel','lederen keukenstoel zwart',199,1650,10,100,50,25,6, 1),
(15,'keukenstoel','lederen keukenstoel rood',199,1650,10,100,50,25,6, 1),
(16,'bijzettafel','Houten bijzettafel rond - 50 cm',99,2500,10,100,50,25,10, 1),
(17,'bijzettafel','Houten bijzettafel rond - 90 cm',137,3000,10,100,50,25,10, 1),
(18,'bijzettafel','Houten bijzettafel rond - 30 cm',57,2000,10,100,50,25,10, 1),
(19,'salontafel','Houten salontafel rond - 90 cm',125,3500,1,10,5,3,1, 1),
(20,'salontafel','Houten salontafel rond - 120 cm',150,4000,1,10,5,3,1, 1),
(21,'salontafel','Houten salontafel 50cm - 95 cm',135,3750,1,10,5,3,1, 1),
(22,'salontafel','Houten salontafel 50cm - 120 cm',175,4500,1,10,5,3,1, 1),
(23,'eettafel','Houten keukentafel rond - 120 cm',109,5000,1,10,5,3,1, 1),
(24,'eettafel','Houten keukentafel rond - 150 cm',129,6000,1,10,5,3,1, 1),
(25,'eettafel','Houten keukentafel rond - 180 cm',149,7000,1,10,5,3,1, 1),
(26,'eettafel','Kunststof keukentafel wit rond - 120 cm',79,3500,1,10,5,3,1, 1),
(27,'eettafel','Kunststof keukentafel wit rond - 150 cm',99,4000,1,10,5,3,1, 1),
(28,'eettafel','Kunststof keukentafel wit rond - 180 cm',119,4500,1,10,5,3,1, 1),
(29,'kruk','4 houten krukken',259,8000,1,10,5,3,6, 1),
(30,'kruk','6 houten krukken',379,10000,1,10,5,3,6, 1),
(31,'kruk','8 houten krukken',469,16000,1,10,5,3,6, 1),
(32,'kruk','1 houten kruk',75,2000,1,10,5,3,6, 1),
(33,'sofa','stoffen 2-zit',350,20000,1,10,5,3,1, 1),
(34,'sofa','stoffen 3-zit',429,24000,1,10,5,3,1, 1),
(35,'sofa','stoffen 4-zit',499,28000,1,10,5,3,1, 1),
(36,'sofa','lederen 2-zit',699,20000,1,10,5,3,1, 1),
(37,'sofa','lederen 3-zit',850,24000,1,10,5,3,1, 1),
(38,'sofa','lederen 4-zit',1099,28000,1,10,5,3,1, 1),
(39,'TV-meubel','TV-meubel 1 lade',399,5000,1,10,5,3,2, 1),
(40,'TV-meubel','TV-meubel 2 lades',479,5500,1,10,5,3,2, 1),
(41,'TV-meubel','TV-meubel 1 lade en 2 zijkastjes',579,6500,1,10,5,3,2, 1),
(42,'TV-meubel','TV-meubel 2 lades en 2 zijkastjes',699,7000,1,10,5,3,2, 1),
(43,'Dressoir','Dressoir 2 deuren',349,20000,1,10,5,3,1, 1),
(44,'Dressoir','Dressoir 3 deuren',499,25000,1,10,5,3,1, 1),
(45,'Dressoir','Dressoir 4 deuren',649,30000,1,10,5,3,1, 1),
(46,'Ladekast','Ladekast 3 lades 90 cm',146,7500,1,10,5,3,1, 1),
(47,'Ladekast','Ladekast 4 lades 90 cm',189,8500,1,10,5,3,1, 1),
(48,'Ladekast','Ladekast 3 lades 120 cm',219,9000,1,10,5,3,1, 1),
(49,'Ladekast','Ladekast 4 lades 120 cm',259,1000,1,10,5,3,1, 1);

insert into Artikelen 
(artikelId, naam, beschrijving, prijs, gewichtingram, minimumvoorraad, maximumvoorraad, voorraad, bestelpeil, maxAantalInMagazijnPLaats, leveranciersId) 
values
(50,'Wandrek','Houten wandrek enkel - 90 cm',49,1250,1,10,5,3,4, 1),
(51,'Wandrek','Houten wandrek dubbel - 90 cm',79,1750,1,10,5,3,4, 1),
(52,'Wandrek','Houten wandrek enkel - 120 cm',65,1650,1,10,5,3,4, 1),
(53,'Wandrek','Houten wandrek dubbel - 120 cm',125,3300,1,10,5,3,4, 1),
(54,'Kapstok','Wand kapstok hout - 90 cm',75,1500,1,10,5,3,2, 1),
(55,'Kapstok','Wand kapstok metaal - 90 cm',45,1000,1,10,5,3,2, 1),
(56,'Kapstok','Wand kapstok kunststof wit - 90 cm',34,750,1,10,5,3,2, 5),
(57,'Kapstok','Wand kapstok kunststof zwart - 90 cm',34,750,1,10,5,3,2, 5),
(58,'Kapstok','Kapstokhaken - set van 3  zwart',19,250,1,10,5,3,5, 1),
(59,'Kapstok','Kapstokhaken - set van 6 zwart',35,500,1,10,5,3,5, 1),
(60,'Kapstok','Kapstokhaken - set van 10 zwart',60,1000,1,10,5,3,5, 1),
(61,'Kapstok','Kapstokhaken - set van 3 wit',19,250,1,10,5,3,5, 1),
(62,'Kapstok','Kapstokhaken - set van 10 wit',60,1000,1,10,5,3,5, 1),
(63,'Kapstok','Kapstokhaken - set van 6 wit',35,750,1,10,5,3,5, 1),
(64,'Staande lamp','Staande lamp - 1  - koper',149,2500,1,10,5,3,5, 1),
(65,'Staande lamp','Staande lamp - 1 - metaal',119,2500,1,10,5,3,5, 1),
(66,'Staande lamp','Staande lamp - 1 + leeslicht  - koper',179,3000,1,10,5,3,5, 1),
(67,'Staande lamp','Staande lamp - 1 + leeslicht  - metaal',139,3000,1,10,5,3,5, 1),
(68,'Hanglamp','Bronzen hanglamp met 3 glazen',119,2500,1,10,5,3,5, 4),
(69,'Hanglamp','Bronzen hanglamp met 6 glazen',149,3500,1,10,5,3,5, 4),
(70,'Hanglamp','Koperen hanglamp met 3 glazen',119,2500,1,10,5,3,5, 4),
(71,'Hanglamp','Koperen hanglamp met 6 glazen',149,3500,1,10,5,3,5, 4),
(72,'Hanglamp','Industriële metalen hanglamp 3 glazen',99,2500,1,10,5,3,5, 4),
(73,'Hanglamp','Industriële metalen hanglamp 6 glazen',115,3500,1,10,5,3,5, 4),
(74,'Boormachine 500W','Boormachine 500W geel',235,480,1,10,5,3,10, 4),
(75,'Boormachine 600W','Boormachine 600W rood',370,600,1,10,5,3,10, 4),
(76,'Boormachine 1000W','Boormachine 1000W blauw',680,750,1,10,5,3,10, 4),
(77,'Klopboormachine 400W','Klopboormachine 400W groen',240,520,1,10,5,3,10, 4),
(78,'Klopboormachine 500W','Klopboormachine 500W geel',360,630,1,10,5,3,10, 4),
(79,'Klopboormachine 600W','Klopboormachine 600W rood',480,830,1,10,5,3,10, 4),
(80,'Klopboormachine 1000W','klopboormachine 1000W blauw',850,1189,1,10,5,3,10, 4),
(81,'Elektrische schroevendraaier 400W','Elektrische schroevendraaier 400W groen',200,450,1,10,5,3,10, 4),
(82,'Elektrische schroevendraaier 500W','Elektrische schroevendraaier 500W geel',225,460,1,10,5,3,10, 4),
(83,'Elektrische schroevendraaier 600W','Elektrische schroevendraaier 600W rood',370,530,1,10,5,3,10, 4),
(84,'Decoupeerzaag 400W','Wipzaag 400W blauw',350,450,1,10,5,3,10, 4),
(85,'Decoupeerzaag 500W','Wipzaag 500W groen',370,460,1,10,5,3,10, 4),
(86,'Decoupeerzaag 600W','Wipzaag 600W geel',480,480,1,10,5,3,10, 4),
(87,'Schuurmachine 400W','Schuurmachine 400W rood',199,450,1,10,5,3,10, 4),
(88,'Schuurmachine 500W','Schuurmachine 500W blauw',270,460,1,10,5,3,10, 4),
(89,'Schuurmachine 600W','Schuurmachine 600W groen',390,480,1,10,5,3,10, 4),
(90,'Breekhamers 600W','Breekhamers 600W geel',680,1200,1,10,5,3,10, 4),
(91,'Breekhamers 800W','Breekhamers 800W rood',890,1250,1,10,5,3,10, 4),
(92,'Breekhamers 1000W','Breekhamers 1000W blauw',980,1480,1,10,5,3,10, 4),
(93,'Breekhamers 1200W','Breekhamers 1200W groen',1100,1760,1,10,5,3,10, 4),
(94,'Cirkelzaag 400W','Cirkelzaag 400W geel',450,1400,1,10,5,3,10, 4),
(95,'Cirkelzaag 600W','Cirkelzaag 600W rood',550,1680,1,10,5,3,10, 4),
(96,'Cirkelzaag 1000W','Cirkelzaag 1000W blauw',750,2400,1,10,5,3,10, 4),
(97,'Cirkelzaag 1500W','Cirkelzaag 1500W groen',989,2490,1,10,5,3,10, 4),
(98,'Afkortzaag 400W','Afkortzaag 400W geel',680,1900,1,10,5,3,10, 4),
(99,'Afkortzaag 600W','Afkortzaag 600W rood',870,2480,1,10,5,3,10, 4);

insert into Artikelen 
(artikelId, naam, beschrijving, prijs, gewichtingram, minimumvoorraad, maximumvoorraad, voorraad, bestelpeil, maxAantalInMagazijnPLaats, leveranciersId) 
values
(100,'Afkortzaag 800W','Afkortzaag 800W blauw',990,2690,1,10,5,3,10, 4),
(101,'Afkortzaag 1000W','Afkortzaag 1000W groen',1200,3197,1,10,5,3,10, 4),
(102,'Figuurzaag 250W','Figuurzaag 250W geel',250,1400,1,10,5,3,10, 4),
(103,'Figuurzaag 350W','Figuurzaag 350W rood',290,1500,1,10,5,3,10, 4),
(104,'Figuurzaag 450W','Figuurzaag 450W blauw',390,1680,1,10,5,3,10, 4),
(105,'Kolomboormachine 300W','Kolomboormachine 300W groen',480,14500,1,10,5,3,10, 4),
(106,'Kolomboormachine 600W','Kolomboormachine 600W geel',678,17815,1,10,5,3,10, 4),
(107,'Kolomboormachine 900W','Kolomboormachine 900W rood',1580,19851,1,10,5,3,10, 4),
(108,'Kolomboormachine 1500W','Kolomboormachine 1500W blauw',2180,26780,1,10,5,3,10, 4),
(109,'Schaafmachine 300W','Schaafmachine 300W groen',230,480,1,10,5,3,10, 4),
(110,'Schaafmachine 600W','Schaafmachine 600W geel',370,580,1,10,5,3,10, 4),
(111,'Schaafmachine 900W','Schaafmachine 900W rood',680,724,1,10,5,3,10, 4),
(112,'Schaafmachine 1500W','Schaafmachine 1500W blauw',990,860,1,10,5,3,10, 4),
(113,'Slijpmachine 600W','Slijpmachine 600W groen',199,1200,1,10,5,3,10, 4),
(114,'Slijpmachine 900W','Slijpmachine 900W geel',350,1580,1,10,5,3,10, 4),
(115,'Slijpmachine 1200W','Slijpmachine 1200W rood',650,1790,1,10,5,3,10, 4),
(116,'Multitool 250W','Multitool 250W blauw',299,378,1,10,5,3,10, 4),
(117,'Multitool 350W','Multitool 350W groen',369,456,1,10,5,3,10, 4),
(118,'Multitool 450W','Multitool 450W geel',429,512,1,10,5,3,10, 4),
(119,'Bovenfrees 450W','Bovenfrees 450W rood',560,650,1,10,5,3,10, 4),
(120,'Bovenfrees 600W','Bovenfrees 600W',720,946,1,10,5,3,10, 4),
(121,'Bovenfrees 900W','Bovenfrees 900W',840,1165,1,10,5,3,10, 4),
(122,'Hamer 100 gr','Hamer 100 gr staal',14,120,10,100,50,25,25, 4),
(123,'Hamer 250gr','Hamer 250gr staal',19,280,10,100,50,25,25, 4),
(124,'Hamer 400gr','Hamer 400gr staal',24,430,10,100,50,25,25, 4),
(125,'Hamer 1000gr','Hamer 1000gr staal',35,1120,10,100,50,25,25, 4),
(126,'Klauwhamer 250gr','Klauwhamer 250gr staal',24,280,10,100,50,25,25, 4),
(127,'Klauwhamer 400Gr','Klauwhamer 400gr staal',35,430,10,100,50,25,25, 4),
(128,'Hamer 250gr','Hamer 250gr rubber',14,280,10,100,50,25,25, 4),
(129,'Hamer 400gr','Hamer 400Gr rubber',19,430,10,100,50,25,25, 4),
(130,'Hamer 600gr','Hamer 600gr rubber',24,670,10,100,50,25,25, 4),
(131,'Hamer 400gr','Hamer 400gr hout',35,430,10,100,50,25,25, 4),
(132,'Hamer 750gr','Hamer 750gr hout',55,830,10,100,50,25,25, 4),
(133,'Universeelzaag 45cm','universeelzaag 45cm staal',12.9,420,10,100,50,25,25, 4),
(134,'Universeelzaag 50cm','universeelzaag 50cm staal',14.9,470,10,100,50,25,25, 4),
(135,'Universeelzaag 55cm','universeelzaag 55cm staal',18.9,520,10,100,50,25,25, 4),
(136,'Kapzaag 20cm','kapzaag 20cm staal',15.9,480,10,100,50,25,25, 4),
(137,'Kapzaag 30cm','kapzaag 30cm staal',24.8,560,10,100,50,25,25, 4),
(138,'Kapzaag 40cm','kapzaag 40cm staal',33.7,640,10,100,50,25,25, 4),
(139,'spade T-steel 95cm','spade T-steel 95cm hout',45,2000,10,100,50,25,25, 4),
(140,'spade bolsteel 95cm','spade bolsteel 95cm hout',44,2000,10,100,50,25,25, 4),
(141,'spade D-steel 95cm','spade D-steel 95cm hout',49,2000,10,100,50,25,25, 4),
(142,'spade kinderen 60cm','spade kinderen 60cm hout',19,700,10,100,50,25,25, 5),
(143,'spade ergonomisch 95cm','spade ergonomisch 95cm hout',54,2000,10,100,50,25,25, 4),
(144,'spade T-steel 95cm','spade T-steel 95cm epoxy',49,2000,10,100,50,25,25, 4),
(145,'spade bolsteel 95cm','spade bolsteel 95cm epoxy',48,2000,10,100,50,25,25, 4),
(146,'spade D-steel 95cm','spade D-steel 95cm epoxy',53,2000,10,100,50,25,25, 4),
(147,'spade kinderen 60cm','spade kinderen 60cm PVC',23,300,10,100,50,25,25, 5),
(148,'spade ergonomisch 95cm','spade ergonomisch 95cm epoxy',58,2000,10,100,50,25,25, 4),
(149,'gazonhark 35cm','gazonhark 35cm staal',35,4000,10,100,50,25,25, 4);

insert into Artikelen 
(artikelId, naam, beschrijving, prijs, gewichtingram, minimumvoorraad, maximumvoorraad, voorraad, bestelpeil, maxAantalInMagazijnPLaats, leveranciersId) 
values
(150,'gazonhark 50cm','gazonhark 50cm staal',42,5000,10,100,50,25,25, 4),
(151,'hark zonder steel 30cm','hark zonder steel 30cm staal',15,2500,10,100,50,25,25, 4),
(152,'hark zonder steel 35cm','hark zonder steel 35cm staal',19,3000,10,100,50,25,25, 4),
(153,'hark zonder steel 50cm','hark zonder steel 50cm staal',26,4000,10,100,50,25,25, 4),
(154,'hark zonder steel 60cm','hark zonder steel 60cm staal',35,4500,10,100,50,25,25, 4),
(155,'steel voor hark 100cm','steel voor hark 100cm staal',20,736,10,100,50,25,25, 4),
(156,'steel voor hark 120cm','steel voor hark 120cm staal',24,1000,10,100,50,25,25, 4),
(157,'bolsteel voor hark 100cm','bolsteel voor hark 100cm hout',22,700,10,100,50,25,25, 4),
(158,'bolsteel voor hark 120cm','bolsteel voor hark 120cm hout',26,840,10,100,50,25,25, 4),
(159,'T-steel voor hark 100cm','T-steel voor hark 100cm epoxy',28,700,10,100,50,25,25, 4),
(160,'T-steel voor hark 120cm','T-steel voor hark 120cm epoxy',34,840,10,100,50,25,25, 4),
(161,'steakmes','mat',8,50,10,100,50,25,50, 3),
(162,'tafelvork','mat',8,50,10,100,50,25,50, 3),
(163,'tafelmes','mat',8,50,10,100,50,25,50, 3),
(164,'eetlepel','mat',8,50,10,100,50,25,50, 3),
(165,'dinerlepel','mat',8,50,10,100,50,25,50, 3),
(166,'steakmes','staal',8,50,10,100,50,25,50, 3),
(167,'tafelvork','staal',14,50,10,100,50,25,50, 3),
(168,'tafelmes','staal',14,50,10,100,50,25,50, 3),
(169,'eetlepel','staal',14,50,10,100,50,25,50, 3),
(170,'dinerlepel','staal',14,50,10,100,50,25,50, 3),
(171,'steakmes 4-pack','staal',55,200,10,100,50,25,50, 3),
(172,'tafelvork 4-pack','staal',55,200,10,100,50,25,50, 3),
(173,'tafelmes 4-pack','staal',55,200,10,100,50,25,50, 3),
(174,'eetlepel 4-pack','staal',55,200,10,100,50,25,50, 3),
(175,'dinerlepel 4-pack','staal',55,200,10,100,50,25,50, 3),
(176,'steakmes 4-pack','mat',30,200,10,100,50,25,50, 3),
(177,'tafelvork 4-pack','mat',30,200,10,100,50,25,50, 3),
(178,'tafelmes 4-pack','mat',30,200,10,100,50,25,50, 3),
(179,'eetlepel 4-pack','mat',30,200,10,100,50,25,50, 3),
(180,'dinerlepel 4-pack','mat',30,200,10,100,50,25,50, 3),
(181,'steakmes 2-pack','mat',16,100,10,100,50,25,50, 3),
(182,'tafelvork 2-pack','mat',16,100,10,100,50,25,50, 3),
(183,'tafelmes 2-pack','mat',16,100,10,100,50,25,50, 3),
(184,'eetlepel 2-pack','mat',16,100,10,100,50,25,50, 3),
(185,'dinerlepel 2-pack','mat',16,100,10,100,50,25,50, 3),
(186,'steakmes 2-pack','staal',26,100,10,100,50,25,50, 3),
(187,'tafelvork 2-pack','staal',26,100,10,100,50,25,50, 3),
(188,'tafelmes 2-pack','staal',26,100,10,100,50,25,50, 3),
(189,'eetlepel 2-pack','staal',26,100,10,100,50,25,50, 3),
(190,'dinerlepel 2-pack','staal',26,100,10,100,50,25,50, 3),
(191,'steakmes 6-pack','mat',45,300,10,100,50,25,50, 3),
(192,'tafelvork 6-pack','mat',45,300,10,100,50,25,50, 3),
(193,'tafelmes 6-pack','mat',45,300,10,100,50,25,50, 3),
(194,'eetlepel 6-pack','mat',45,300,10,100,50,25,50, 3),
(195,'dinerlepel 6-pack','mat',45,300,10,100,50,25,50, 3),
(196,'steakmes 6-pack','staal',80,300,10,100,50,25,50, 3),
(197,'tafelvork 6-pack','staal',80,300,10,100,50,25,50, 3),
(198,'tafelmes 6-pack','staal',80,300,10,100,50,25,50, 3),
(199,'eetlepel 6-pack','staal',80,300,10,100,50,25,50, 3); 

insert into Artikelen 
(artikelId, naam, beschrijving, prijs, gewichtingram, minimumvoorraad, maximumvoorraad, voorraad, bestelpeil, maxAantalInMagazijnPLaats, leveranciersId) 
values
(200,'dinerlepel 6-pack','staal',80,300,10,100,50,25,50, 3),
(201,'groot plat bord 6-pack','wit porcelein',60,2160,10,100,50,25,50, 3),
(202,'wit soepbord 6-pack','wit porcelein',60,2160,10,100,50,25,50, 3),
(203,'wit dessertbord 6-pack','wit porcelein',50,1500,10,100,50,25,50, 3),
(204,'wit koffietas en onderzetter 6-pack','wit porcelein',50,1860,10,100,50,25,50, 3),
(205,'witte mok 300 ml 6-pack','wit porcelein',12,1800,10,100,50,25,50, 5),
(206,'waterglas op voet 6-pack','glas',30,1140,10,100,50,25,50, 3),
(207,'rode wijnglas 6-pack','glas',27,960,10,100,50,25,50, 3),
(208,'witte wijnglas 6-pack','glas',24,840,10,100,50,25,50, 3),
(209,'champagneglas 6-pack','glas',30,840,10,100,50,25,50, 3),
(210,'limonadeglas 6-pack','glas',12,1200,10,100,50,25,50, 5),
(211,'taartschotel 30 cm','wit porcelein',35,600,10,100,50,25,50, 3),
(212,'ovale schotel 30 x 20','wit porcelein',35,500,10,100,50,25,50, 3),
(213,'sauskom','wit porcelein',30,600,10,100,50,25,50, 3),
(214,'pollepel','staal',30,300,10,100,50,25,50, 3),
(215,'taartschep','staal',10,200,10,100,50,25,50, 3),
(216,'pollepel','mat',15,300,10,100,50,25,50, 3),
(217,'taartschep','mat',5,200,10,100,50,25,50, 3),
(218, 'bewaardoos 1,2 l rechthoekig - set van 3','plastiek',4.75, 75, 10, 100, 50, 25, 50, 2),
(219, 'bewaardoos 1,2 l rechthoekig - set van 6','plastiek',8.99, 150, 10, 100, 50, 25, 50, 2),
(220, 'bewaardoos 1,5 l rechthoekig - set van 3','plastiek',5.99, 105, 10, 100, 50, 25, 50, 2),
(221, 'bewaardoos 1,5 l rechthoekig - set van 6','plastiek',10.25, 210, 10, 100, 50, 25, 50, 2),
(222, 'bewaardoos 2 l rechthoekig - set van 3','plastiek',6.45, 135, 10, 100, 50, 25, 50, 2),
(223, 'bewaardoos 2 l rechthoekig - set van 6','plastiek',11.45, 270, 10, 100, 50, 25, 50, 2),
(224, 'bewaardoos 1,2 l rechthoekig','plastiek',1.19, 25, 10, 100, 50, 25, 50, 2),
(225, 'bewaardoos 1,5 l rechthoekig','plastiek',2.23, 25, 10, 100, 50, 25, 50, 2),
(226, 'bewaardoos 2 l rechthoekig','plastiek',2.75, 25, 10, 100, 50, 25, 50, 2),
(227, 'bewaardoos 1 l rechthoekig','plastiek',3, 20, 10, 100, 50, 25, 50, 2),
(228, 'bewaardoos 1 l rechthoekig - set van 3','plastiek',8.5, 60, 10, 100, 50, 25, 50, 2),
(229, 'bewaardoos 1 l rechthoekig - set van 6','plastiek',15, 120, 10, 100, 50, 25, 50, 2),
(230, 'bewaardoos 1,2 l rond - set van 3','plastiek',4.75, 75, 10, 100, 50, 25, 50, 2),
(231, 'bewaardoos 1,2 l rond - set van 6','plastiek',8.99, 150, 10, 100, 50, 25, 50, 2),
(232, 'bewaardoos 1,5 l rond - set van 3','plastiek',5.99, 105, 10, 100, 50, 25, 50, 2),
(233, 'bewaardoos 1,5 l rond - set van 6','plastiek',10.25, 210, 10, 100, 50, 25, 50, 2),
(234, 'bewaardoos 2 l rond - set van 3','plastiek',6.45, 135, 10, 100, 50, 25, 50, 2),
(235, 'bewaardoos 2 l rond - set van 6','plastiek',11.45, 270, 10, 100, 50, 25, 50, 2),
(236, 'bewaardoos 1,2 l rond','plastiek',1.19, 25, 10, 100, 50, 25, 50, 2),
(237, 'bewaardoos 1,5 l rond','plastiek',2.23, 25, 10, 100, 50, 25, 50, 2),
(238, 'bewaardoos 2 l rond','plastiek',2.75, 25, 10, 100, 50, 25, 50, 2),
(239, 'bewaardoos 1 l rond','plastiek',3, 20, 10, 100, 50, 25, 50, 2),
(240, 'bewaardoos 1 l rond - set van 3','plastiek',8.5, 60, 10, 100, 50, 25, 50, 2),
(241, 'bewaardoos 1 l rond - set van 6','plastiek',15, 120, 10, 100, 50, 25, 50, 2),
(242, 'steelpan 16 cm','rvs',20, 600, 5, 50, 25, 12, 10, 3),
(243, 'steelpan 18 cm','rvs',25, 750, 5, 50, 25, 12, 10, 3),
(244, 'braadpan 20 cm','rvs',25, 800, 5, 50, 25, 12, 10, 3),
(245, 'braadpan 24 cm','rvs',30, 900, 5, 50, 25, 12, 10, 3),
(246, 'braadpan 26 cm','rvs',35, 1200, 5, 50, 25, 12, 10, 3),
(247, 'kookpot 16 cm','rvs',25, 740, 5, 50, 25, 12, 10, 3),
(248, 'kookpot 20 cm','rvs',30, 900, 5, 50, 25, 12, 10, 3),
(249, 'kookpot 24 cm','rvs',35, 1200, 5, 50, 25, 12, 10, 3);

insert into Artikelen 
(artikelId, naam, beschrijving, prijs, gewichtingram, minimumvoorraad, maximumvoorraad, voorraad, bestelpeil, maxAantalInMagazijnPLaats, leveranciersId) 
values
(250, 'kookpot 26 cm','rvs',40, 1400, 5, 50, 25, 12, 10, 3),
(251, 'soepketel 26 cm - 8 l','rvs',60, 1850, 5, 50, 25, 12, 10, 3),
(252, 'soepketel 26 cm - 10 l','rvs',75, 2000, 5, 50, 25, 12, 10, 3),
(253, 'anti-kleefpan 20 cm','rvs - ptfe laag',30, 800, 5, 50, 25, 12, 10, 3),
(254, 'anti-kleefpan 24 cm','rvs - ptfe laag',35, 900, 5, 50, 25, 12, 10, 3),
(255, 'anti-kleefpan 26 cm','rvs - ptfe laag',40, 1200, 5, 50, 25, 12, 10, 3),
(256, 'taartshotel met deksel dia 34 cm hoogte 5 cm','plastiek',12, 460, 5, 50, 25, 12, 10, 3),
(257, 'taartshotel met deksel dia 34 cm hoogte 12 cm','plastiek',15, 670, 5, 50, 25, 12, 10, 3),
(258, 'wandbrievenbus', 'rechthoekige brievenbus, rvs', 27,  2200, 1,10,5, 3, 10, 4),
(259, 'wandbrievenbus donkergrijs', 'rechthoekige brievenbus, rvs', 29,  2200, 1,10,5, 3, 10, 4),
(260, 'wandbrievenbus grijs', 'rechthoekige brievenbus met afgeronde hoeken, staal', 35,  3300, 1,10,5, 3, 10, 4),
(261, 'wandbrievenbus zwart', 'rechthoekige brievenbus met afgeronde hoeken, staal', 40,  3300, 1,10,5, 3, 10, 4),
(262, 'pakketbrievenbus grijs', 'pakketopening 155 w 340mm, staal', 225,  18500, 1,10,5, 3, 10, 4),
(263, 'pakketbrievenbus zwart', 'pakketopening 155 w 340mm, staal', 225,  18500, 1,10,5, 3, 10, 4),
(264, 'staander voor wandbrievenbus grijs', 'staal, 1,5 m hoog', 35.5, 230, 1, 10, 5, 3, 10, 4),
(265, 'staander voor wandbrievenbus donkergrijs', 'staal, 1,5 m hoog', 35.5, 230, 1, 10, 5, 3, 10, 4),
(266, 'staander voor wandbrievenbus zwart', 'staal, 1,5 m hoog', 35.5, 230, 1, 10, 5, 3, 10, 4);

insert into ArtikelCategorieen (artikelid, categorieId) 
values 
(1,2),
(2,2),
(3,2),
(4,33),
(5,33),
(6,33),
(7,33),
(8,33),
(9,33),
(10,33),
(11,33),
(12,33),
(13,33),
(14,33),
(15,33),
(16,32),
(17,32),
(18,32),
(19,35),
(20,35),
(21,35),
(22,35),
(23,31),
(24,31),
(25,31),
(26,31),
(27,31),
(28,31),
(29,34),
(30,34),
(31,34),
(32,34),
(33,36),
(34,36),
(35,36),
(36,36),
(37,36),
(38,36),
(39,37),
(40,37),
(41,37),
(42,37),
(43,38),
(44,38),
(45,38),
(46,39),
(47,39),
(48,39),
(49,39);

insert into ArtikelCategorieen (artikelid, categorieId) 
values 
(50,40),
(51,40),
(52,40),
(53,40),
(54,41),
(55,41),
(56,41),
(57,41),
(58,41),
(59,41),
(60,41),
(61,41),
(62,41),
(63,41),
(64,42),
(65,42),
(66,42),
(67,42),
(68,43),
(69,43),
(70,43),
(71,43),
(72,43),
(73,43),
(74,24),
(75,24),
(76,24),
(77,24),
(78,24),
(79,24),
(80,24),
(81,24),
(82,24),
(83,24),
(84,24),
(85,24),
(86,24),
(87,24),
(88,24),
(89,24),
(90,24),
(91,24),
(92,24),
(93,24),
(94,24),
(95,24),
(96,24),
(97,24),
(98,24),
(99,24);

insert into ArtikelCategorieen (artikelid, categorieId) 
values 
(100,24),
(101,24),
(102,24),
(103,24),
(104,24),
(105,24),
(106,24),
(107,24),
(108,24),
(109,24),
(110,24),
(111,24),
(112,24),
(113,24),
(114,24),
(115,24),
(116,24),
(117,24),
(118,24),
(119,24),
(120,24),
(121,24),
(122,21),
(123,21),
(124,21),
(125,21),
(126,21),
(127,21),
(128,21),
(129,21),
(130,21),
(131,21),
(132,21),
(133,21),
(134,21),
(135,21),
(136,21),
(137,21),
(138,21),
(139,22),
(140,22),
(141,22),
(142,22),
(143,22),
(144,22),
(145,22),
(146,22),
(147,22),
(148,22),
(149,22);

insert into ArtikelCategorieen (artikelid, categorieId) 
values 
(150,22),
(151,22),
(152,22),
(153,22),
(154,22),
(155,22),
(156,22),
(157,22),
(158,22),
(159,22),
(160,22),
(161,6),
(162,6),
(163,6),
(164,6),
(165,6),
(166,6),
(167,6),
(168,6),
(169,6),
(170,6),
(171,6),
(172,6),
(173,6),
(174,6),
(175,6),
(176,6),
(177,6),
(178,6),
(179,6),
(180,6),
(181,6),
(182,6),
(183,6),
(184,6),
(185,6),
(186,6),
(187,6),
(188,6),
(189,6),
(190,6),
(191,6),
(192,6),
(193,6),
(194,6),
(195,6),
(196,6),
(197,6),
(198,6),
(199,6);

insert into ArtikelCategorieen (artikelid, categorieId) 
values 
(200,6),
(201,7),
(202,7),
(203,7),
(204,11),
(205,11),
(206,10),
(207,10),
(208,10),
(209,10),
(210,10),
(211,9),
(212,9),
(213,9),
(214,6),
(215,6),
(216,6),
(217,6),
(1,22),
(2,22),
(3,22),
(214,9),
(215,9),
(216,9),
(217,9);


insert into ArtikelCategorieen (artikelid, categorieId) 
values 
(218,5),
(219,5),
(220,5),
(221,5),
(222,5),
(223,5),
(224,5),
(225,5),
(226,5),
(227,5),
(228,5),
(229,5),
(230,5),
(231,5),
(232,5),
(233,5),
(234,5),
(235,5),
(236,5),
(237,5),
(238,5),
(239,5),
(240,5),
(241,5);


insert into ArtikelCategorieen (artikelid, categorieId) 
values 
(242,4),
(243,4),
(244,4),
(245,4),
(246,4),
(247,4),
(248,4),
(249,4),
(250,4),
(251,4),
(252,4),
(253,4),
(254,4),
(255,4),
(242,8),
(243,8),
(244,8),
(245,8),
(246,8),
(247,8),
(248,8),
(249,8),
(250,8),
(251,8),
(252,8),
(253,8),
(254,8),
(255,8),
(256,5),
(257,5),
(256,9),
(257,9);


insert into ArtikelCategorieen (artikelid, categorieId) 
values 
(55, 23), 
(258, 23),
(259, 23),
(260, 23),
(261, 23),
(262, 23),
(263, 23),
(264, 23),
(265, 23),
(266, 23);


insert into ArtikelLeveranciersInfoLijnen (artikelleveranciersinfolijnid, artikelid, vraag, antwoord) 
values 
(1,74, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(2,75, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(3,76, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(4,77, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(5,78, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(6,79, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(7,80, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(8,81, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(9,82, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(10,83, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(11,84, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(12,85, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(13,86, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(14,87, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(15,88, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(16,89, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(17,90, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(18,91, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(19,92, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(20,93, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(21,94, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(22,95, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(23,96, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(24,97, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(25,98, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(26,99, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(27,100, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(28,101, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(29,102, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(30,103, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(31,104, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(32,105, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(33,106, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(34,107, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(35,108, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(36,109, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(37,110, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(38,111, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(39,112, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(40,113, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(41,114, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(42,115, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(43,116, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(44,117, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(45,118, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(46,119, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(47,120, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.'),
(48,121, 'Wat is de garantieperiode?', 'De garantieperiode is 2 jaar. Hou de originele verpakking en factuur goed bij.');


insert into VeelgesteldeVragenArtikels (veelgesteldevragenartikelid, artikelid, vraag, antwoord) 
values 
(49,64, 'Welke lampen zijn geschikt?', 'Led lampen met E27 fitting'),
(50,65, 'Welke lampen zijn geschikt?', 'Led lampen met E27 fitting'),
(51,66, 'Welke lampen zijn geschikt?', 'Led lampen met E27 fitting'),
(52,67, 'Welke lampen zijn geschikt?', 'Led lampen met E27 fitting'),
(53,68, 'Welke lampen zijn geschikt?', 'Led lampen met E27 fitting'),
(54,69, 'Welke lampen zijn geschikt?', 'Led lampen met E27 fitting'),
(55,70, 'Welke lampen zijn geschikt?', 'Led lampen met E27 fitting'),
(56,71, 'Welke lampen zijn geschikt?', 'Led lampen met E27 fitting'),
(57,72, 'Welke lampen zijn geschikt?', 'Led lampen met E27 fitting'),
(58,73, 'Welke lampen zijn geschikt?', 'Led lampen met E27 fitting');

insert into VeelgesteldeVragenArtikels (veelgesteldevragenartikelid, artikelid, vraag, antwoord) 
values 
(59, 242, 'Voor welke vuren is het artikel geschikt?', 'Het artikel is geschikt voor gas, electrische, keramische, inductie en halogeen vuren.'),
(60, 243, 'Voor welke vuren is het artikel geschikt?', 'Het artikel is geschikt voor gas, electrische, keramische, inductie en halogeen vuren.'),
(61, 244, 'Voor welke vuren is het artikel geschikt?', 'Het artikel is geschikt voor gas, electrische, keramische, inductie en halogeen vuren.'),
(62, 245, 'Voor welke vuren is het artikel geschikt?', 'Het artikel is geschikt voor gas, electrische, keramische, inductie en halogeen vuren.'),
(63, 246, 'Voor welke vuren is het artikel geschikt?', 'Het artikel is geschikt voor gas, electrische, keramische, inductie en halogeen vuren.'),
(64, 247, 'Voor welke vuren is het artikel geschikt?', 'Het artikel is geschikt voor gas, electrische, keramische, inductie en halogeen vuren.'),
(65, 248, 'Voor welke vuren is het artikel geschikt?', 'Het artikel is geschikt voor gas, electrische, keramische, inductie en halogeen vuren.'),
(66, 249, 'Voor welke vuren is het artikel geschikt?', 'Het artikel is geschikt voor gas, electrische, keramische, inductie en halogeen vuren.'),
(67, 250, 'Voor welke vuren is het artikel geschikt?', 'Het artikel is geschikt voor gas, electrische, keramische, inductie en halogeen vuren.'),
(68, 251, 'Voor welke vuren is het artikel geschikt?', 'Het artikel is geschikt voor gas, electrische, keramische, inductie en halogeen vuren.'),
(69, 252, 'Voor welke vuren is het artikel geschikt?', 'Het artikel is geschikt voor gas, electrische, keramische, inductie en halogeen vuren.'),
(70, 242, 'Is het artikel vaatwasbestendig?', 'Het artikel is geschikt voor huishoud vaatwassers als industriële vaatwassers.'),
(71, 243, 'Is het artikel vaatwasbestendig?', 'Het artikel is geschikt voor huishoud vaatwassers als industriële vaatwassers.'),
(72, 244, 'Is het artikel vaatwasbestendig?', 'Het artikel is geschikt voor huishoud vaatwassers als industriële vaatwassers.'),
(73, 245, 'Is het artikel vaatwasbestendig?', 'Het artikel is geschikt voor huishoud vaatwassers als industriële vaatwassers.'),
(74, 246, 'Is het artikel vaatwasbestendig?', 'Het artikel is geschikt voor huishoud vaatwassers als industriële vaatwassers.'),
(75, 247, 'Is het artikel vaatwasbestendig?', 'Het artikel is geschikt voor huishoud vaatwassers als industriële vaatwassers.'),
(76, 248, 'Is het artikel vaatwasbestendig?', 'Het artikel is geschikt voor huishoud vaatwassers als industriële vaatwassers.'),
(77, 249, 'Is het artikel vaatwasbestendig?', 'Het artikel is geschikt voor huishoud vaatwassers als industriële vaatwassers.'),
(78, 250, 'Is het artikel vaatwasbestendig?', 'Het artikel is geschikt voor huishoud vaatwassers als industriële vaatwassers.'),
(79, 251, 'Is het artikel vaatwasbestendig?', 'Het artikel is geschikt voor huishoud vaatwassers als industriële vaatwassers.'),
(80, 252, 'Is het artikel vaatwasbestendig?', 'Het artikel is geschikt voor huishoud vaatwassers als industriële vaatwassers.');


-- artikelen in magazijnplaatsen zetten
drop procedure if exists vulMagazijnplaatsen;

delimiter |

create procedure vulMagazijnplaatsen()
begin
declare magazijnPlaatsIdValue int default 1;
declare artikelIdValue int default 1;
declare voorraadValue int default 0;
declare maxAantalInMagazijnPlaatsValue int default 0;
WHILE (magazijnPlaatsIdValue <= (select count(*) from MagazijnPlaatsen)) and 
      (artikelIdValue <= (select count(*) from Artikelen)) DO
	SET voorraadValue = (select voorraad from Artikelen where artikelId=artikelIdValue);
    SET maxAantalInMagazijnPlaatsValue  = (select maxAantalInMagazijnPlaats from Artikelen where artikelId=artikelIdValue);
	while (voorraadValue>0) and 
          (magazijnPlaatsIdValue <= (select count(*) from MagazijnPlaatsen)) and 
          (artikelIdValue <= (select count(*) from Artikelen)) do
			if (voorraadValue < maxAantalInMagazijnPlaatsValue) then
				update MagazijnPlaatsen set artikelId=artikelIdValue, aantal=voorraadValue 
                       where magazijnPlaatsId=magazijnPlaatsIdValue;
			    set voorraadValue = 0;
			else
				update MagazijnPlaatsen set artikelId=artikelIdValue, aantal=maxAantalInMagazijnPlaatsValue 
                       where magazijnPlaatsId=magazijnPlaatsIdValue;
			    set voorraadValue = voorraadValue - maxAantalInMagazijnPlaatsValue;            
            end if;
            set magazijnPlaatsIdValue = magazijnPlaatsIdValue + 1;
    end while;
	set artikelIdValue = artikelIdValue + 1;
END WHILE;
end |

delimiter ;

call vulMagazijnplaatsen;

drop procedure vulMagazijnplaatsen;

-- controle
/*
select mp.artikelid, sum(mp.aantal), a.voorraad
from MagazijnPlaatsen mp inner join Artikelen a
on mp.artikelId = a.artikelId 
group by mp.artikelid, a.voorraad;
*/

drop procedure if exists InkomendeLeveringElkeDagProcedure;

delimiter |

create procedure InkomendeLeveringElkeDagProcedure()
BEGIN
declare magazijnPlaatsIdValue int;
declare artikelIdValue int;
declare voorraadValue int;
declare maxAantalInMagazijnPlaatsValue int;
declare aantalInMagazijnPlaatsValue int;
insert into EventWachtrijArtikelen (artikelId, aantal, maxAantalInMagazijnPlaats) 
select artikelid, bestelpeil - voorraad, maxAantalInMagazijnPlaats 
from Artikelen 
where voorraad < minimumVoorraad and aantalBesteldLeverancier = 0;
insert into EventWachtrijArtikelen (artikelId, aantal, maxAantalInMagazijnPlaats) 
select artikelid, aantalBesteldLeverancier, maxAantalInMagazijnPlaats 
from Artikelen 
where voorraad < minimumVoorraad and aantalBesteldLeverancier > 0;
update Artikelen set voorraad = bestelpeil
where voorraad < minimumVoorraad and aantalBesteldLeverancier = 0 and artikelId>0;
update Artikelen set voorraad = voorraad + aantalBesteldLeverancier, aantalBesteldLeverancier = 0 
where voorraad < minimumVoorraad and aantalBesteldLeverancier > 0  and artikelId>0;
SET magazijnPlaatsIdValue = 1;
SET artikelIdValue=1;
WHILE ((magazijnPlaatsIdValue <= (select count(*) from MagazijnPlaatsen)) and (artikelIdValue <= (select count(*) from Artikelen))) DO
	SET voorraadValue = (select aantal from EventWachtrijArtikelen where artikelId=artikelIdValue);
	SET maxAantalInMagazijnPlaatsValue  = (select maxAantalInMagazijnPlaats from Artikelen where artikelId=artikelIdValue);
	WHILE (voorraadValue>0) and (magazijnPlaatsIdValue <= (select count(*) from MagazijnPlaatsen)) and 
          (artikelIdValue <= (select count(*) from Artikelen)) do
		  set aantalInMagazijnPlaatsValue = (select aantal from MagazijnPlaatsen where magazijnPlaatsId=magazijnPlaatsIdValue);
            if (aantalInMagazijnPlaatsValue=0) then
                select voorraadValue;
				if (voorraadValue < maxAantalInMagazijnPlaatsValue) then
					update MagazijnPlaatsen set artikelId=artikelIdValue, aantal=voorraadValue 
						where magazijnPlaatsId=magazijnPlaatsIdValue;
					set voorraadValue = 0;
				else
					update MagazijnPlaatsen set artikelId=artikelIdValue, aantal=maxAantalInMagazijnPlaatsValue 
                       where magazijnPlaatsId=magazijnPlaatsIdValue;
					set voorraadValue = voorraadValue - maxAantalInMagazijnPlaatsValue;            
				end if;
			end if;
            set  magazijnplaatsidValue = magazijnplaatsidValue + 1;          
        end while;
	set artikelidValue = artikelidValue + 1;
END WHILE;
delete from EventWachtrijArtikelen where artikelId>0;
END |

delimiter ;

-- paswoord is PersoneelVanPrularia
insert into PersoneelslidAccounts (personeelslidAccountId, emailadres, paswoord ) 
values 
(1, 'd.ceo@prularia.com','$2a$11$KThggo./izUkaugrYvPVueJB7Ib17f.mEFFrtfApfqk8O76AOtpE2'),
(2, 'k.klantendienst@prularia.com','$2a$11$KThggo./izUkaugrYvPVueJB7Ib17f.mEFFrtfApfqk8O76AOtpE2'),
(3, 'j.leveringen@prularia.com','$2a$11$KThggo./izUkaugrYvPVueJB7Ib17f.mEFFrtfApfqk8O76AOtpE2'),
(4, 'f.magazijn@prularia.com','$2a$11$KThggo./izUkaugrYvPVueJB7Ib17f.mEFFrtfApfqk8O76AOtpE2'),
(5, 'b.website@prularia.com','$2a$11$KThggo./izUkaugrYvPVueJB7Ib17f.mEFFrtfApfqk8O76AOtpE2'),
(6, 'i.artikelbeheer@prularia.com','$2a$11$KThggo./izUkaugrYvPVueJB7Ib17f.mEFFrtfApfqk8O76AOtpE2');


insert into GebruikersAccounts (gebruikersAccountId, emailadres, paswoord ) 
values 
(2, 'ad.ministrateur@vdab.be','KlantVanPrularia'),
(3, 'alpha.klant@bestaatniet.be','KlantVanPrularia'),
(4, 'beta.client@bestaatniet.be','KlantVanPrularia'),
(5, 'gamma.customer@bestaatniet.be','KlantVanPrularia'),
(6, 'delta.kunde@bestaatniet.be','KlantVanPrularia'),
(7, 'eta.cliente@bestaatniet.be','KlantVanPrularia'),
(8, 'in.koper@vdab.be','KlantVanPrularia'),
(9, 'de.baas@rva.be','KlantVanPrularia');


insert into Adressen (adresId, straat, huisNummer, bus, plaatsId) 
values
(1, 'Keizerslaan', '11', '', 381),
(2, 'Interleuvenlaan', '2', '', 1037),
(3, 'Somersstraat', '22', '', 62),
(4, 'T2 Campus, Thor Park', '11', '', 790),
(5, 'Vlamingenstraat', '10', '', 2657),
(6, 'Industrieweg', '50', '', 2701),
(7, 'Sterrekundelaan', '14', '', 2203),
(8, 'Keizerslaan','7','',381);


insert into Klanten (klantid, facturatieadresid, leveringsadresid) 
values 
(1,1,7),
(2,2,2),
(3,3,3),
(4,4,4),
(5,5,5),
(6,6,6),
(7,8,8);

insert into Rechtspersonen (klantId, naam, btwNummer) 
values 
(1, 'VDAB', '0887010362'),
(7, 'RVA', '0206737484');


insert into Contactpersonen (contactpersoonId, voornaam, familienaam, functie, klantid, gebruikersAccountId) 
values
(1, 'Ad', 'Ministrateur', 'CEO', 1, 2),
(2, 'In', 'Koper', 'Inkoper', 1, 8),
(3, 'De', 'Baas', 'De Baas', 7, 9);

insert into NatuurlijkePersonen (klantid, voornaam, familienaam, gebruikersAccountId) 
values 
(2, 'Alpha', 'Klant', 3),
(3, 'Beta', 'Client', 4),
(4, 'Gamma', 'Customer', 5),
(5, 'Delta', 'Kunde', 6),
(6, 'Eta', 'Cliente', 7);

insert into Personeelsleden (personeelslidId, voornaam, familienaam, personeelslidAccountId)
values
(1, 'D.','Ceo',1),
(2, 'B.','Klantendienst',2),
(3, 'J.','Leveringen',3),
(4, 'F.','Magazijn',4),
(5, 'B.','Website',5),
(6, 'I.','Artikelbeheer',6);

insert into PersoneelslidSecurityGroepen (personeelslidId, securityGroepId) 
values 
(1, 4),
(2, 2),
(3, 3),
(4, 3),
(5, 1),
(6, 2);

insert into Bestellingen 
(bestelId, besteldatum, klantId, betaald, betaalwijzeId, bestellingsStatusId, actiecodeGebruikt, bedrijfsnaam, btwNummer, voornaam, familienaam, facturatieAdresId, leveringsAdresId) 
values 
(1, adddate( adddate(current_date(), interval -7 day), interval + 10 hour), 1,1,1,6,0,'VDAB', '0887010362', 'Ad', 'Ministrateur', 1, 7),
(2, adddate( adddate(current_date(), interval -1 day), interval + 14 hour), 2,1,1,5,0,null, null, 'Eerste', 'Klant', 2, 2),
(3, adddate( adddate( adddate(current_date(), interval -1 day), interval + 14 hour), interval 30 minute), 3,1,1,4,0,null, null, 'Tweede', 'Klant', 3, 3),
(4, adddate( current_date(), interval + 7 hour), 4,1,1,5,0,null, null, 'Derde', 'Klant', 4, 4),
(5, adddate( adddate( current_date(), interval + 7 hour), interval + 20 minute), 5,1,1,2,1,null, null, 'Vierde', 'Klant', 5, 5);


insert into Bestellijnen (bestellijnId, bestelid, artikelId, aantalBesteld) 
values 
(1,1,2,2),
(2,1,80,2), 
(3,1,89,1),
(4,1,118,2),
(5,2,4,4),
(6,2,23,1),
(7,3,33,1),
(8,3,21,1),
(9,4,1,1),
(10,4,29,1),
(11,4,65,1),
(12,4,172,1),
(13,4,173,1),
(14,4,174,1),
(15,5,76,1),
(16,5,83,1),
(17,5,86,1),
(18,5,112,1),
(19,5,126,1),
(20,5,138,1);

insert into KlantenReviews (klantenReviewId, nickname, score, commentaar, datum, bestellijnid )
values
(1,'klant1',5,'goed artikel, correcte prijs', current_date(), 1),
(2,'klant1',1, 'luidruchtig', current_date(),2), 
(3,'klant1',4, 'kleine krachtpatser', current_date(),3),
(4,'klant1',5, 'goed artikel, correcte prijs', current_date(),4),
(5,'klant2',3, 'stevige stoel, afwerking kan beter', current_date(),5),
(6,'klant2',2, 'niet zo stevig, vijzen komen snel terug los', current_date(),6),
(7,'klant3',4, 'mooi', current_date(),7),
(8,'klant3',5, 'mooi artikel, goed afgewerkt', current_date(),7);

insert into UitgaandeLeveringen (uitgaandeLeveringsId, bestelid, vertrekdatum, aankomstdatum, klantid, uitgaandeleveringsstatusid) 
values 
(1,1, adddate(current_date(), interval -6 day), adddate(current_date(), interval -5 day), 1, 2),
(2, 2, current_date(), null, 2, 1);

insert into Actiecodes (naam, geldigVanDatum, geldigTotDatum, isEenmalig)
values
('Nieuwjaar', (select IF (makedate(year(current_date()), 364) > current_date(), makedate(year(current_date()), 364), makedate(year(current_date()) + 1, 364))),(select IF (makedate(year(current_date()), 364) > current_date(), makedate(year(current_date())+1, 5), makedate(year(current_date()) + 2, 3))) , 0),
('Wintersolden', (select IF (makedate(year(current_date()), 4) > current_date(), makedate(year(current_date()), 4), makedate(year(current_date()) + 1, 4))),(select IF (makedate(year(current_date()), 5) > current_date(), makedate(year(current_date()), 19), makedate(year(current_date()) + 1, 19))) , 0),
('ExtraWinterSolden',(select IF (makedate(year(current_date()), 20) > current_date(), makedate(year(current_date()), 20), makedate(year(current_date()) + 1, 20))),(select IF (makedate(year(current_date()), 20) > current_date(), makedate(year(current_date()), 30), makedate(year(current_date()) + 1, 30))),0),
('Valentijn', (select IF (makedate(year(current_date()), 42) > current_date(), makedate(year(current_date()), 42), makedate(year(current_date()) + 1, 42))),(select IF (makedate(year(current_date()), 42) > current_date(), makedate(year(current_date()), 49), makedate(year(current_date()) + 1, 49))), 0),
('Lentekoopjes', (select IF (makedate(year(current_date()), 20) > current_date(), makedate(year(current_date()), 20), makedate(year(current_date()) + 1, 20))),(select IF (makedate(year(current_date()), 20) > current_date(), makedate(year(current_date()), 30), makedate(year(current_date()) + 1, 30))) ,0), 
('VoorjaarsKoopjes', (select IF (makedate(year(current_date()), 121) > current_date(), makedate(year(current_date()), 121), makedate(year(current_date()) + 1, 121))),(select IF (makedate(year(current_date()), 121) > current_date(), makedate(year(current_date()), 135), makedate(year(current_date()) + 1, 135))) , 0),
('Zomersolden', (select IF (makedate(year(current_date()), 184) > current_date(), makedate(year(current_date()), 184), makedate(year(current_date()) + 1, 184))),(select IF (makedate(year(current_date()), 184) > current_date(), makedate(year(current_date()), 200), makedate(year(current_date()) + 1, 200))) , 0),
('ExtraZomersolden', (select IF (makedate(year(current_date()), 201) > current_date(), makedate(year(current_date()), 201), makedate(year(current_date()) + 1, 201))),(select IF (makedate(year(current_date()), 201) > current_date(), makedate(year(current_date()), 213), makedate(year(current_date()) + 1, 213))) , 0),
('NajaarsKoopjes',(select IF (makedate(year(current_date()), 305) > current_date(), makedate(year(current_date()), 305), makedate(year(current_date()) + 1, 305))),(select IF (makedate(year(current_date()), 305) > current_date(), makedate(year(current_date()), 319), makedate(year(current_date()) + 1, 319))) , 0),
('VerjaardagPrularia', (select IF (makedate(year(current_date()), 351) > current_date(), makedate(year(current_date()), 351), makedate(year(current_date()) + 1, 351))),(select IF (makedate(year(current_date()), 351) > current_date(), makedate(year(current_date()), 356), makedate(year(current_date()) + 1, 356))) , 0);

insert into InkomendeLeveringen (inkomendeLeveringsId, leveranciersId, leveringsbonNummer, leveringsbondatum, leverDatum, ontvangerPersoneelslidId) 
values
(1, 5, '2022/786', '2022-02-11', '2022-02-15', 4);

insert into InkomendeLeveringsLijnen (inkomendeLeveringsId, artikelId, aantalGoedgekeurd, aantalTeruggestuurd, magazijnPlaatsId)
values
(1, 1, 20, 0, 5),
(1, 2, 20, 0, 6),
(1, 3, 25, 0, 7),
(1, 3, 15, 0, 8),
(1, 205, 18, 2, 14),
(1, 210, 50, 0, 20),
(1, 210, 6, 4, 21);

delimiter ;

-- createNieuweBestellingen
drop procedure if exists createNieuweBestellingen;

delimiter |

create procedure createNieuweBestellingen()
begin
declare bestelIdValue int default 1;
declare bestellijnIdValue int default 1;
set bestelIdValue = (select max(bestelid) from Bestellingen);
set bestellijnIdValue = (select max(bestellijnId) from Bestellijnen);
insert into Bestellingen 
(bestelId, besteldatum, klantId, betaald, betaalwijzeId, bestellingsStatusId, actiecodeGebruikt, bedrijfsnaam, btwNummer, voornaam, familienaam, facturatieAdresId, leveringsAdresId) 
values 
(bestelIdValue + 1, adddate( adddate(current_date(), interval -1 day), interval + 8 hour), 1,1,1,2,0,'VDAB', '0887010362', 'Ad', 'Ministrateur', 1, 7);
insert into Bestellijnen (bestellijnId, bestelid, artikelId, aantalBesteld) 
values 
(bestellijnIdValue + 1,bestelIdValue + 1,2,2),
(bestellijnIdValue + 2,bestelIdValue + 1,80,2), 
(bestellijnIdValue + 3,bestelIdValue + 1,89,1),
(bestellijnIdValue + 4,bestelIdValue + 1,118,2);
insert into Bestellingen 
(bestelId, besteldatum, klantId, betaald, betaalwijzeId, bestellingsStatusId, actiecodeGebruikt, bedrijfsnaam, btwNummer, voornaam, familienaam, facturatieAdresId, leveringsAdresId) 
values 
(bestelIdValue + 2, adddate( adddate(current_date(), interval -1 day), interval + 9 hour), 2,1,1,2,0,null, null, 'Eerste', 'Klant', 2, 2);
insert into Bestellijnen (bestellijnId, bestelid, artikelId, aantalBesteld) 
values 
(bestellijnIdValue + 5,bestelIdValue + 2,4,4),
(bestellijnIdValue + 6,bestelIdValue + 2,23,1);
insert into Bestellingen 
(bestelId, besteldatum, klantId, betaald, betaalwijzeId, bestellingsStatusId, actiecodeGebruikt, bedrijfsnaam, btwNummer, voornaam, familienaam, facturatieAdresId, leveringsAdresId) 
values 
(bestelIdValue + 3, adddate( adddate(current_date(), interval -1 day), interval + 10 hour), 3,1,1,2,0,null, null, 'Tweede', 'Klant', 3, 3);
insert into Bestellijnen (bestellijnId, bestelid, artikelId, aantalBesteld) 
values 
(bestellijnIdValue + 7,bestelIdValue + 3,33,1),
(bestellijnIdValue + 8,bestelIdValue + 3,21,1);
insert into Bestellingen 
(bestelId, besteldatum, klantId, betaald, betaalwijzeId, bestellingsStatusId, actiecodeGebruikt, bedrijfsnaam, btwNummer, voornaam, familienaam, facturatieAdresId, leveringsAdresId) 
values 
(bestelIdValue + 4, adddate( adddate(current_date(), interval -1 day), interval + 11 hour), 4,0,2,1,0,null, null, 'Derde', 'Klant', 4, 4);
insert into Bestellijnen (bestellijnId, bestelid, artikelId, aantalBesteld) 
values 
(bestellijnIdValue + 9,bestelIdValue + 4,1,1),
(bestellijnIdValue + 10,bestelIdValue + 4,29,1),
(bestellijnIdValue + 11,bestelIdValue + 4,65,1),
(bestellijnIdValue + 12,bestelIdValue + 4,172,1),
(bestellijnIdValue + 13,bestelIdValue + 4,173,1),
(bestellijnIdValue + 14,bestelIdValue + 4,174,1);
insert into Bestellingen 
(bestelId, besteldatum, klantId, betaald, betaalwijzeId, bestellingsStatusId, actiecodeGebruikt, bedrijfsnaam, btwNummer, voornaam, familienaam, facturatieAdresId, leveringsAdresId) 
values 
(bestelIdValue + 5, adddate( adddate(current_date(), interval -1 day), interval + 12 hour), 5,0,2,1,1,null, null, 'Vierde', 'Klant', 5, 5);
insert into Bestellijnen (bestellijnId, bestelid, artikelId, aantalBesteld) 
values 
(bestellijnIdValue + 15,bestelIdValue + 5,76,1),
(bestellijnIdValue + 16,bestelIdValue + 5,83,1),
(bestellijnIdValue + 17,bestelIdValue + 5,86,1),
(bestellijnIdValue + 18,bestelIdValue + 5,112,1),
(bestellijnIdValue + 19,bestelIdValue + 5,126,1),
(bestellijnIdValue + 20,bestelIdValue + 5,138,1);
END |

delimiter ;
