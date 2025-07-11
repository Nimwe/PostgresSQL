--2.3 -> Premiere vue --
--2.3 -> 1 Création d'une vue --
create or replace view hotel_station
as 
select 
hot.id as "Id de l'hôtel",
hot.station_id as "Id de la station de l'hôtel",
hot.name as "Nom de l'hôtel",
hot.category as "Categorie de l'hôtel",
hot.address as "Adresse de l'hôtel",
hot.city as "Ville de l'hôtel",
stat.name as "Nom de la station",
stat.altitude as "Altitude de la station"
from hotel hot
join station stat on hot.station_id = stat.id;

-- Requete de la vue créée --
select * from hotel_station;

--2.3 -> 2 Modifier une vue --
-- Requêtes pour modifier une vue --
--ALTER VIEW [ IF EXISTS ] nom ALTER [ COLUMN ] nom_colonne SET DEFAULT expression
--ALTER VIEW [ IF EXISTS ] nom ALTER [ COLUMN ] nom_colonne DROP DEFAULT
--ALTER VIEW [ IF EXISTS ] nom OWNER TO { nouveau_propriétaire | CURRENT_USER | SESSION_USER }
--ALTER VIEW [ IF EXISTS ] name RENAME [ COLUMN ] nom_colonne TO nouveau_nom_colonne
--ALTER VIEW [ IF EXISTS ] nom RENAME TO nouveau_nom
--ALTER VIEW [ IF EXISTS ] nom SET SCHEMA nouveau_schéma
--ALTER VIEW [ IF EXISTS ] nom SET ( nom_option [= valeur_option] [, ... ] )
--ALTER VIEW [ IF EXISTS ] nom RESET ( nom_option [, ... ] )
--Source : https://docs.postgresql.fr/13/sql-alterview.html --

--2.3 -> 3 Supprimer une vue --
--drop vieww [if exists] nom_vue;


--2.4 Création de cue à partir de la bdd hôtel--
--2.4 -> 1 Vue 1 : Afficher la liste des réservations avec le nom des clients--
create or replace view booking_client
as 
select
bo.id as "Id de réservation",
bo.booking_date as "Dates de réservations",
bo.stay_start_date as "Date de début du séjour",
bo.stay_end_date as "Date de fin du séjour",
cli.last_name as "Nom du client",
cli.first_name as "Prénom du client"
from booking bo
join client cli on bo.client_id = cli.id;

select * from booking_client;

--2.4 -> 2 Vue 2 : Afficher la liste des chambres avec le nom de l’hôtel et le nom de la station --
create or replace view room_hotel_station 
as 
select
ro.id as "Id de la chambre",
ro."number" as "Numéro de chambre",
hot.name as "Nom de l'hôtel",
stat."name" as "Nom de la station"
from room ro
join hotel hot on ro.hotel_id = hot.id
join station stat on hot.station_id = stat.id;

select * from room_hotel_station;

--2.4 -> 3 Vue 3 : Afficher les réservations avec le nom du client et le nom de l’hôtel--
create or replace view booking_client_hotel
as 
select
bo.id as "Id réservation",
bo.booking_date as "Dates de réservation",
bo.stay_start_date as "Date de début de séjour",
bo.stay_end_date as "Date de fin de séjour",
cli.last_name as "Nom du client",
cli.first_name as "Prénom du client",
hot."name" AS "Nom de l'hôtel"
FROM
  booking bo
JOIN
  client cli ON bo.client_id = cli.id
JOIN
  room ro ON bo.room_id = ro.id
JOIN
  hotel hot ON ro.hotel_id = hot.id;

SELECT * FROM booking_client_hotel;

--3 Restrictions d'accès à la bdd--
--3.1 les rôles--
select rolname from pg_roles; -- => voir les oôles existants

--3.2 Création de rôles--
--create role nom_du_role
--login => permet de préciser que le rôle crée correspond à un utilisateur de BDD pouvant se connecter
--password nom_du_mdp;

-- 3.2 -> 1 Créez un utilisateur « application_admin » pouvant se connecter au SBGD--
create role application_admin
login
password 'mdp';

-- 3.2 -> 2 Ajoutez une connexion à la base de données « hotel » en utilisant votre nouvel utilisateur dans votre client SQL--
grant connect on database hotel to application_admin;

--3.2 -> 3 Essayez d’effectuer un select sur une table, que se passe-t-il ?--
select * from client;
-- Ne focntionne pas car pas les privilèges necessaires

--3.3 Ajout des privilèges --
-- Un par un --
-- grant liste_privileges
-- on nom_table
-- to nom_role;

--Parmi les privilèges utilisables on retrouve :
-- • SELECT
-- • INSERT
-- • UPDATE
-- • DELETE
-- • TRUNCATE

-- Tous les privilèges --
-- grant all 
-- on nom_table
-- to nom_role;

-- Pour accorder des privilèges à l’ensemble des tables d’un schéma (par exemple, « public »), il est possible d’utiliser la requête suivante--
-- grant liste_privileges all
-- on table nom_table | all tables in schema nom_schema
-- from nom_role;

-- Pour supprimer des privilèges en utilisant la commande « REVOKE »--
-- revoke liste_privileges all
-- on table nom_table | all tables in schema nom_schema
-- from nom_role;

-- Pour toutes les tables existantes-- 
-- revoke liste_privileges all
-- on all tables in schema nom_schema
-- from nom_role;

--3.3 -> 4 Accordez les privilèges « SELECT », « INSERT », « UPDATE » et « DELETE » à l’utilisateur « application_admin » sur toutes les tables sauf « station ».--
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE hotel TO application_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE room TO application_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE client TO application_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE booking TO application_admin;

--3.3 -> 5 Essayez d’effectuer des requêtes.--
-- Table hotel--
-- Voir les hôtels
SELECT * FROM hotel;

-- Ajouter un hôtel
INSERT INTO hotel (station_id, "name", category, address, city)
VALUES (1, 'Hôtel Test', 3, '1 rue du test', 'Testville');

-- Mettre à jour un hôtel
UPDATE hotel SET category = 4 WHERE id = 1;

-- Supprimer un hôtel
DELETE FROM hotel WHERE id = 2;

-- => Elles fonctionnent sut hotel 

--Table Station--
SELECT * FROM station;

-- => Ne fonctionne pas car pas les droits 

--3.4 Privilèges sur une vue --
--3.4 -> 6 Créez un nouveau rôle « application_client » pouvant se connecter à votre base de données.--
create role application_client
LOGIN
password 'mdpclient';

--3.4 -> 7 Ajoutez les privilèges de lecture des données uniquement sur votre vue permettant de retrouver chambres avec le nom de l’hôtel et le nom de la station (vue 2).--
grant select on room_hotel_station
to application_client;

--3.4 -> 8 Testez vos permissions.--
select * from room_hotel_station;
-- => Fonctionne 

select * from room;
-- => Ne fonctionne pas






