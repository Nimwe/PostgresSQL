-- 2 Création d'un jeu de test --


-- Insérer au moins 2 stations --
SELECT setval('station_id_seq', (SELECT MAX(id) FROM station));

iNSERT INTO station ("name", altitude) VALUES ('Station test1', 1800);
INSERT INTO station ("name", altitude) VALUES ('Station test2', 2000);


-- Insérer au moins 2 hôtels --
SELECT setval('hotel_id_seq', (SELECT MAX(id) FROM hotel));

INSERT INTO hotel (station_id, "name", category, address, city)
VALUES (1, 'Hotel test1', 4, '12 rue de hotel1', 'Station test1');

INSERT INTO hotel (station_id, "name", category, address, city)
VALUES (2, 'Hotel test2', 3, '5 avenue du hotel2', 'Station test2');

-- Insérer au moins 2 chambres --
SELECT setval('room_id_seq', (SELECT MAX(id) FROM room));

INSERT INTO room ("number", hotel_id, capacity, "type")
VALUES ('001', 1, 12, 1);

INSERT INTO room ("number", hotel_id, capacity, "type")
VALUES ('002', 2, 20, 2);

-- Insérer au moins 1 client --
SELECT setval('client_id_seq', (SELECT MAX(id) FROM client));

INSERT INTO client (last_name, first_name, address, city)
VALUES ('Doe', 'John', '8 rue de nullepart', 'Ailleurs');

INSERT INTO client (last_name, first_name, address, city)
VALUES ('Does', 'Jane', '0 rue de pasici', 'jaipasenviedeledire');

-- 3 REQUETES A ECRIRE --

--3.1 -> 1 - Afficher la liste des hôtels : Le résultat doit faire apparaître le nom de l’hôtel et la ville --
select name, city
from hotel;

--3.1 -> 2 - Afficher la ville de résidence de Mr White : Le résultat doit faire apparaître le nom, le prénom, et l'adresse du client--
select last_name, first_name, city 
from client 
where last_name = 'White';

--3.1 -> 3 - Afficher la liste des stations dont l’altitude < 1000 : Le résultat doit faire apparaître le nom de la station et l'altitude--
select name, altitude
from station
where altitude < 1000 ;

--3.1 -> 4 - Afficher la liste des chambres ayant une capacité > 1 : Le résultat doit faire apparaître le numéro de la chambre ainsi que la capacité--
select number, capacity
from room
where 1 < capacity;

--3.1 -> 5 - Afficher les clients n’habitant pas à Londres : Le résultat doit faire apparaître le nom du client et la ville--
select first_name, city
from client 
where city != 'Londres';

--3.1 -> 6 - Afficher la liste des hôtels située sur la ville de Bretou et possédant une catégorie > 3 : Le résultat doit faire apparaître le nom de l'hôtel, ville et la catégorie --
select name, city, category
from hotel 
where city = 'Bretou'
and 3 < category; 

--3.2 -> 7 Afficher la liste des hôtels avec leur station : Le résultat doit faire apparaître le nom de la station, le nom de l’hôtel, la catégorie, la ville)--
select stat.name as "Nom de station", hot.name as "Nom de l'hôtel", hot.category, hot.city
from hotel hot
join station stat on hot.station_id = stat.id;

--3.2 -> 8 - Afficher la liste des chambres et leur hôtel : Le résultat doit faire apparaître le nom de l’hôtel, la catégorie, la ville, le numéro de la chambre)--
select hot.name as "Nom de l'hôtel", hot.category, hot.city, ro.number as "Numéro de chambre"
from room ro
join hotel hot on ro.hotel_id = hot.id

--3.2 -> 9 - Afficher la liste des chambres de plus d'une place dans des hôtels situés sur la ville de Bretou : Le résultat doit faire apparaître le nom de l’hôtel, la catégorie, la ville, le numéro de la chambre et sa capacité)--
select hot.name as "Nom de l'hôtel", hot.category, hot.city, ro.number as "Numéro de chambre", ro.capacity
from room ro
join hotel hot on ro.hotel_id = hot.id
where 1 < ro.capacity and hot.city = 'Bretou';

--3.2 -> 10 - Afficher la liste des réservations avec le nom des clients : Le résultat doit faire apparaître le nom du client, le nom de l’hôtel, la date de réservation--
select cli.last_name as "Nom" , cli.first_name as "Prénom", hot.name as "Nom de l'hôtel", bo.booking_date
from booking bo
join client cli on bo.client_id = cli.id
join room ro on bo.room_id = ro.id
join hotel hot on ro.hotel_id = hot.id;

--3.2 -> 11 - Afficher la liste des chambres avec le nom de l’hôtel et le nom de la station : Le résultat doit faire apparaître le nom de la station, le nom de l’hôtel, le numéro de la chambre et sa capacité)--
select stat.name as "Nom de Station", hot.name as "Nom de l'hôtel", ro.number as "Numéro de chambre", ro.capacity as "Capacité"
from room ro
join hotel hot on ro.hotel_id = hot.id
join station stat on hot.station_id = stat.id;

--3.2 -> 12 - Afficher les réservations avec le nom du client et le nom de l’hôtel : Le résultat doit faire apparaître le nom du client, le nom de l’hôtel, la date de début du séjour et la durée du séjour --
select 
cli.last_name as "Nom", cli.first_name as "Prénom", 
hot.name as "Nom de l'hôtel", 
bo.stay_start_date as "Date de  début de séjour",(bo.stay_end_date - bo.stay_start_date) as "Durée du séjour"
from booking bo
join client cli on bo.client_id = cli.id
join room ro on bo.room_id = ro.id
join hotel hot on ro.hotel_id = hot.id;

--3.2 -> 13 - Compter le nombre d’hôtel par station--
select stat.name as "Stations", COUNT(*) as "Nombre d'hôtels"
from hotel hot
join station stat on hot.station_id = stat.id
group by stat.name;

--3.2 -> 14 - Compter le nombre de chambre par station--
select stat.name as "Nom de la station", count(*) as "Nombre de chambres"
from room ro 
join hotel hot on ro.hotel_id = hot.id
join station stat on hot.station_id = stat.id
group by stat.name;

--3.2 -> 15 - Compter le nombre de chambre par station ayant une capacité > 1 --
select stat.name as "Nom de la Station", count(*) as "Nombre de chambre à la capacité supérieure à 1"
from room ro
JOIN hotel hot ON ro.hotel_id = hot.id
JOIN station stat ON hot.station_id = stat.id
WHERE 1 < ro.capacity
GROUP BY stat.name;

--3.2 -> 16 - Afficher la liste des hôtels pour lesquels Mr Squire a effectué une réservation--
SELECT DISTINCT cli.last_name as "Nom du client", hot.name AS "Nom de l'hôtel" 
FROM booking bo
JOIN room ro ON bo.room_id = ro.id
JOIN hotel hot ON ro.hotel_id = hot.id
JOIN client cli ON bo.client_id = cli.id
WHERE cli.last_name = 'Squire';

--3.2 -> 17 - Afficher la durée moyenne des réservations par station --
SELECT stat.name AS "Nom de la station", AVG(bo.stay_end_date - bo.stay_start_date) AS "Durée moyenne d'un séjour"
FROM booking bo
JOIN room ro ON bo.room_id = ro.id
JOIN hotel hot ON ro.hotel_id = hot.id
JOIN station stat ON hot.station_id = stat.id
GROUP BY stat.name;












