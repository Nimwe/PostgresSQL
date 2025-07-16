-- 2.2 Définition d'une Fonction --
-- Format --

-- create or replace function nom_fonction(parametres)
-- returns type_retour
-- language plpgsql => Language procédural utilisé 
-- as $$ => indique le début de définition de la fonction-- 
-- declare 
		-- nom_variable type variable ; => Déclaration de toutes les variables utilisées dans le bloc Begin-End
-- begin
		-- Code de la fonction => il doit retourner une valeur en accord avec le type de retour de la fonction 
		-- Return sortie_attendue
-- end ;
-- $$

-- 2.3 Création d'une fonction de formatage de date--
-- 2.3.2 Code à tester --
create or replace function  format_date (p_date date, p_separator varchar)
returns text
language plpgsql
AS $$
declare 
	format_string text; -- Pas obligatoire --
begin  
	format_string := 'DD' || p_separator || 'MM' || p_separator || 'YYYY'; -- || concétenation
	return to_char(p_date, format_string);
end;
$$;

-- Test de la fonction format_date--
select format_date('2023-02-01', '/');

-- Utilisation de la fonction format date dans une requete 
select "id", supplier_id, format_date(date,'-'), "comments" -- date qui est une colonne de la table devient un des prametres de la fonction 
from "order";

-- 2.4 => Fonction get_item_count --
-- Afficher et retourner le nombre d’articles total en base de données. Elle utilisera une requête SQL pour récupérer le nombre d’articles--
-- 2.4.2 Code à tester --
create or replace function get_items_count()
returns integer
language plpgsql
as $$
declare 
	items_count integer;
	time_now time := now();
begin
	select count(id)
	into items_count
	from item;

	raise notice '% articles à %', items_count, time_now;

	return items_count;
end;
$$;

-- 3 Creation de declencheurs (Triggers)--

-- 3.1 QU’EST-CE QU’UN DECLENCHEUR ?--
-- Un déclencheur (ou « trigger ») est une procédure stockée qui se déclenche automatiquement juste après ou avant les requêtes suivantes :
-- • « INSERT »
-- • « UPDATE »
-- • « DELETE »
-- Les déclencheurs permettent d’automatiser des actions au sein d’un SGBD

-- 3.2 DECLENCHEURS AFFICHANT DES MESSAGES--
-- Dans un premier temps, mise en place plusieurs déclencheurs simples affichant des messages lorsque des requêtes de plusieurs types sont effectuées.

-- 3.2.1 Message avant un « INSERT »
-- Pour créer un déclencheur pgsql, il faut proceder en 2 temps : --
-- 1. Création d’une fonction/procédure qui contient le code PL/pgSQL qui doit être exécuté ;
-- 2. Création du déclencheur qui appellera la fonction/procédure lors d’un évènement qu’on définira.

-- 3.2.1.2 Création de la fonction --
create or replace function display_message_on_supplier_insert()
returns trigger -- le fait de mettre trigger sur le returns est comme faire un adEventListener, la fonciton ne se déclenchera que lors de l'événement--
language plpgsql
as $$
begin 
	raise notice 'Un ajout de fournisseur va être fait. Le nouveau fournisseur est %', new.name;
	return new; -- Si return null -> ne fait pas l'action, return new -> accepte les changments 
end;
$$;

-- Règles à suivre --
-- Une fonction qui a pour objectif d’être déclenchée doit suivre ces règles :
-- • Elle ne doit pas avoir de paramètres ;
-- • Son type de retour doit être « trigger » ;
-- • Elle doit renvoyer soit « null », soit un enregistrement ayant exactement la même structure que la table concernée par la fonction

-- Création du déclencheur Pour INSERT--
create trigger before_insert_supplier -- Nom du trigger
before insert -- indique le type d'evenement qui va declencher le trigger
on public.supplier -- nom de la table concernée par le trigger
for each row -- quand il doit se declencher 
execute function display_message_on_supplier_insert(); -- appel de la fonction lorsque le declencheur s'active

-- before insert : indication sur le type d’évènement de déclenchement. Ici « avant insertion ». Vous
-- pouvez utiliser « before » ou « after » ainsi que les indicateurs sur les requêtes SQL « insert »,
-- « update » et « delete » (ainsi que le radical ordre « truncate »).
-- for each row : deux options sont disponibles ici, « for each row » et « for each statement ». « for
-- each row » indique que la fonction sera appelée à chaque fois qu’une ligne sera impactée par une
-- requête. « for each statement » indique que la fonction est appelée à chaque requête (le requête
-- peut avoir un impact sur plusieurs lignes)

-- Test de la fontion --
insert into supplier (name, address, postal_code, city, contact_name, satisfaction_index)
values ('New Fournisseur', '98 rue de par là', '29290','Au fond du Finistere', 'John doe',29);

-- Visualisation de l'ajout
select * from supplier;

-- 3.2.2 Message après un "UPDATE" --
-- Suppression de l'ancien déclencheur s'il existe
drop trigger if exists after_update_supplier on public.supplier;

-- Suppression de l'ancienne fonction si elle existe
drop function if exists display_message_on_supplier_update();

-- Création de la fonction
create or replace function display_message_on_supplier_update()
returns trigger
language plpgsql
as $$
begin 
-- Message de confirmation
    raise notice 'Mise à jour de la table des Fournisseurs.';

-- Affichage des anciennes valeurs
    raise notice 'Ancienne ligne : id=%, name=%, address=%, postal_code=%, city=%, contact_name=%, satisfaction_index=%',
        old.id, old.name, old.address, old.postal_code, old.city, old.contact_name, old.satisfaction_index;

-- Affichage des nouvelles valeurs
    raise notice 'Nouvelle ligne : id=%, name=%, address=%, postal_code=%, city=%, contact_name=%, satisfaction_index=%',
        new.id, new.name, new.address, new.postal_code, new.city, new.contact_name, new.satisfaction_index;

    return new;  
end;
$$;

-- Création du déclencheur
create trigger after_update_supplier 
after update
on public.supplier 
for each row 
execute function display_message_on_supplier_update();

-- Test de la fonction
update supplier 
set 
    name = 'Newnew Fournisseur',
    address = '21 bd dans ce coin',
    postal_code = '29290',
    city = 'TuTrouveraJamais',
    contact_name = 'pfut',
    satisfaction_index = 79
where id = 11;

-- Visualisation des données
select * from supplier;

-- 3.3 Déclencheurs empéchants une requete --
-- Il est possible d’empêcher qu’une requête puisse se faire en utilisant un déclencheur. Pour se faire, il faut lever une exception dans la fonction déclenchée par un évènement. --

-- 3.3.1 Empêcher la suppression de l'administrateur principal --

-- Création d'une table User --
create table "user" (
    id serial primary key,
    name text not null,
    role text not null
);

-- Suite au soucis lié l'utilisation d'un mot réservé, renomage de la table en users --
alter table "user" rename to users;

-- Création de quelques users --
INSERT INTO users (name, role) 
VALUES
	('Ludo', 'MAIN_ADMIN'),
	('Robin', 'USER'),
	('Lulu', 'USER');

-- Vérification de la table user --
select * from users;

-- Suppression des users en trop suite à résolution des soucis avec le insert into --
delete from users
where id in (4 , 5 , 6 ) ;

-- Suppression de l'ancien déclencheur s'il existe
drop trigger if exists before_delete_users on users;

-- Suppression de l'ancienne fonction si elle existe
drop function if exists check_users_delete();

-- Création de la fonction --
create or replace  function check_users_delete()
returns trigger
language plpgsql
as $$
begin
	raise notice 'Tentative de suppression de l''utilisateur % (id = %, role = %)', old.name, old.id, old.role;
	if old.role = 'MAIN_ADMIN' then
		raise exception 'Impossible de supprimer l`''utilisateur %. Il s''agit de 	l''administrateur principal.', old.id;
	end if;
	return old;
end;
$$

-- Création du déclencheur --
create trigger before_delete_users 
before delete
on public.users
for each row 
execute function check_users_delete();

-- Test de suppression autorisée -
delete from users where id = 2;

-- Test de suppression npn autorisée -
delete from users where id = 1;

-- 3.3.1 -> 11 Créez un déclencheur de type « before delete » appelant cette nouvelle fonction --
drop trigger if exists before_delete_users on users;

create trigger before_delete_users
before delete
on users
for each row
execute function check_users_delete();

-- Test suppression user --
delete from users where id = 3;

-- Test suppresion admin --
delete from users where id = 1;

-- 3.3.2 Empêcher la suppression des commandes non livrées--
-- 3.3.1 -> 12 Implémentez une fonction ainsi que son déclencheur permettant d’empêcher ce type de suppression.--

drop trigger if exists before_delete_order_line on order_line;
drop function if exists check_orderline_delete();

-- Création de la fontion--
create or replace function check_orderline_delete()
returns trigger
language plpgsql
as $$
begin
	if old.delivered_quantity >= old.ordered_quantity then -- Vérification de la livraion qu'elle soit livrée entierement ou partiellement--
		raise exception 'Suppression interdite : la commande order_id = %, n''a pas encore été complétement livrée', old.order_id;
	end if;
	return old;
end;
$$;

-- Création du déclencheur --
create trigger before_delete_order_line
before delete
on order_line
for each row
execute function check_orderline_delete();

-- Test pour quantité livrée entierement -> delete autorisé --
delete from order_line where order_id = 70010 ;

select * from order_line ;

-- Test pour quantité non livrée entierement -> delete interdit --
delete from order_line where order_id = 70250 ;













