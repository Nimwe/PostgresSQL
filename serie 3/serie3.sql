--A correspond la table « order_line »--
-- Se sont les details d'une commande - Cela représente chaque articles individuel commandé dans une commande--

--A quoi sert la colonne « order_id » --
-- C'est une foreign key qui relie la table order_line et la table customer_order - Associe chaque ligne de sommaned à sa commande globale et permet de retrouver toutes les lignes associées à une commande--

-- Activation de l'extension pgcrypto --
create extension if not exists pgcrypto ;

-- Test de la valeur du hash pour récuperer la chaine qu'on doit retrouver dans la base--
select encode(digest('test11', 'sha1'), 'hex');

-- 2 -> 1 Récupérer l’utilisateur ayant le prénom “Muriel” et le mot de passe “test11”, sachant que l’encodage du mot de passe est effectué avec l’algorithme Sha1.--
select * 
from client 
where first_name='Muriel'
and password = encode(digest('test11', 'sha1'), 'hex');

-- 2 -> 2 Récupérer la liste de tous les produits qui sont présents sur plusieurs commandes--
select ordlin.last_name, count(distinct ordlin.order_id) as nb_commandes
from order_line ordlin
group by ordlin.last_name
having count(distinct ordlin.order_id) > 1;






