-- Script à compléter
-- Plusieurs tables sont à ajouter, vous pouvez vous servir du modèle logique de données pour les retrouver

-- Attention : 
-- Pour les noms de table ou de colonne vous ne pourrez pas utiliser les mots-clefs utilisé par le langage SQL
-- Voici un liste des mots clefs interdits : https://www.postgresql.org/docs/current/sql-keywords-appendix.html
-- si toutefois vous souhaitez utiliser un mot clef considéré interdit vous pouvez utiliser des guillemets.

-- Ne pas oublier les contraintes d'intégrités suivantes :
-- * contraintes de clefs étrangères 
-- * contraintes de clefs primaires
-- * contraintes de domaine  (ou type)


CREATE TABLE station (
	id SERIAL PRIMARY KEY,
	"name" VARCHAR(50) NOT NULL,
	altitude INT
);

CREATE TABLE hotel (
	id 			SERIAL primary KEY,
	station_id 		INT NOT NULL,
	"name" 		VARCHAR(50) NOT NULL,
	category 	INT NOT NULL,
	address		VARCHAR(50) NOT NULL,
	city 		VARCHAR(50) NOT NULL, 
	FOREIGN KEY (station_id) REFERENCES station(id)
);

-- Tables à insérer ici

CREATE TABLE room (
	id SERIAL primary KEY,
	"number" VARCHAR(5) NOT NULL,
	hotel_id INT NOT NULL,
	capacity INT NOT NULL check (capacity> 0),
	"type" INT NOT NULL,
	FOREIGN KEY (hotel_id) REFERENCES hotel(id)
);

CREATE TABLE client (
	id SERIAL PRIMARY KEY,
	last_name VARCHAR(50) NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	address VARCHAR (250) NOT NULL,
	city VARCHAR(100) NOT NULL
);

CREATE TABLE booking (
	id SERIAL PRIMARY KEY,
	room_id INT NOT NULL,
	client_id INT NOT NULL,
	booking_date DATE NOT NULL,
	stay_start_date DATE NOT NULL,
	stay_end_date DATE NOT NULL,
	price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
	deposit NUMERIC(10,2) NOT NULL CHECK (deposit >= 0),
	FOREIGN KEY (room_id) REFERENCES room(id),
	FOREIGN KEY (client_id) REFERENCES client(id),
	CHECK (stay_end_date > stay_start_date)
);