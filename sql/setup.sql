-- IMPORTANTE: creare un database chiamato 'es_libri' in cui creare poi la tabella autori
-- oppure cambiare il nome del DB nel file db_conf.properties con uno a scelta


-- Creazione della tabella autori
CREATE TABLE `autori` (
  `codiceA` int NOT NULL,
  `nomeA` varchar(100) DEFAULT NULL,
  `cognomeA` varchar(100) DEFAULT NULL,
  `annoN` int DEFAULT NULL,
  `annoM` int DEFAULT NULL,
  `sesso` char(1) DEFAULT NULL,
  `nazione` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`codiceA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Inserimento dei dati
INSERT INTO `autori` (codiceA, nomeA, cognomeA, annoN, annoM, sesso, nazione) VALUES
(1, 'Alessandro', 'Manzoni', 1785, 1873, 'm', 'Italia'),
(2, 'Lev', 'Tolstoj', 1828, 1910, 'M', 'Russia'),
(3, 'Bruno', 'Vespa', 1944, NULL, 'M', 'Italia'),
(4, 'Stephen', 'King', 1947, NULL, 'M', 'Stati Uniti'),
(5, 'Ernest', 'Hemingway', 1899, 1961, 'M', 'Stati Uniti'),
(6, 'Umberto', 'Eco', 1932, 2016, 'M', 'Italia'),
(7, 'Susanna', 'Tamaro', 1957, NULL, 'F', 'Italia'),
(8, 'Virginia', 'Woolf', 1882, 1941, 'F', 'Regno Unito'),
(9, 'Agatha', 'Christie', 1890, 1976, 'F', 'Regno Unito');

-- crea funzione get_age_by_autore

DROP FUNCTION IF EXISTS get_age_by_autore;
CREATE FUNCTION get_age_by_autore(nome VARCHAR(255), cognome VARCHAR(255))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE eta INT;
    DECLARE anno_nascita INT;

    SELECT annoN INTO anno_nascita 
    FROM autori 
    WHERE nomeA= nome AND cognomeA =cognome;

    SET eta = YEAR(CURRENT_DATE) - anno_nascita;
    RETURN eta; 
END

-- procedura get_age_autori_nazione;

DROP PROCEDURE IF EXISTS get_age_autori_nazione;
DELIMITER //

CREATE PROCEDURE get_age_autori_nazione(IN in_nazione VARCHAR(255))
BEGIN
    DROP TABLE IF EXISTS autori_eta_temp;
    CREATE TABLE autori_eta_temp (
        nomeA VARCHAR(255),
        cognomeA VARCHAR(255),
        eta INT
    );

    INSERT INTO autori_eta_temp (nomeA, cognomeA, eta)
    SELECT nomeA, cognomeA, get_age_by_autore(nomeA, cognomeA)
    FROM autori
    WHERE nazione = in_nazione AND annoM IS NULL;

    SELECT * FROM autori_eta_temp;
END //

DELIMITER ;

-- procedura con cursore

DROP PROCEDURE IF EXISTS get_age_autori_nazione;
DELIMITER //

CREATE PROCEDURE get_age_autori_nazione(IN in_nazione VARCHAR(255))
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE aNomeA, aCognomeA VARCHAR(255);
    DECLARE cursore CURSOR FOR SELECT nomeA, cognomeA FROM autori WHERE nazione = in_nazione AND annoM IS NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    DROP TABLE IF EXISTS autori_eta_temp;
    CREATE TABLE autori_eta_temp (
        nomeA VARCHAR(255),
        cognomeA VARCHAR(255),
        eta INT
    );

    OPEN cursore;

    ciclo: LOOP
        FETCH cursore INTO aNomeA, aCognomeA;
        IF done THEN
            LEAVE ciclo;
        END IF;
        INSERT INTO autori_eta_temp(nomeA, cognomeA, eta)
        VALUES(aNomeA, aCognomeA, get_age_by_autore(aNomeA, aCognomeA));
    END LOOP ciclo;

    CLOSE cursore;

    SELECT * FROM autori_eta_temp;
END //

DELIMITER ;


