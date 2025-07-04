--Série 2--

--3.1 -> 2 Rechercher le numéro du département, le nom du département, le nom des employés classés par numéro de département (utilisez des alias pour les tables).--
select e.department_id as "Numéro de département", d.name as "Nom du département", e.last_name as "Nom employé"
from employee e
join department d
on e.department_id = d.id
order by d.id ;

--3.1 -> 3 Rechercher le nom des employés du département « Distribution ».--
select d.id, d.name as "Nom du département", e.id, e.last_name as "Nom des employés"
from department d
join employee e
on d.id = e.department_id
where d.name like 'distribution';
--order by e.last_name asc; C'est plus propre classé :)--

--3.2 -> 4 Rechercher le nom et le salaire des employés qui gagnent plus que leur supérieur hiérarchique, et le nom et le salaire du supérieur.--
select e1.id, e1.last_name as "Nom supérieur", e1.salary as "Salaire supérieur", e2.id, e2.last_name as "Nom employé", e2.salary as "Salaire employé"
from employee e1
join employee e2
on e1.id = e2.superior_id
where e1.salary < e2.salary;
