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

--3.3 -> 5 Rechercher les employés du département « finance » en utilisant une sous-requête.--
SELECT *
FROM employee
WHERE department_id = 
(SELECT id FROM department WHERE name = 'finance');

--3.3 -> 6 Rechercher le nom et le titre des employés qui ont le même titre que « Amartakaldire » --
select last_name as "Name", title as "Titre" 
from employee
where title = (select title from employee where last_name = 'amartakaldire');

--3.3 -> 7 Rechercher le nom, le salaire et le numéro de département des employés qui gagnent plus qu'un seul employé du département 31, classés par numéro de département et salaire.--
select last_name as "Name", salary as "Salaire", department_id as "Numéro de département"
from employee 
where salary > any(select department_id from employee where department_id = 31)
order by department_id , salary ;

--3.3 -> 8 Rechercher le nom, le salaire et le numéro de département des employés qui gagnent plus que tous les employés du département 31, classés par numéro de département et salaire.--
select last_name as "Name", salary as "Salaire", department_id as "Numéro de département"
from employee
where salary > all(select department_id from employee where department_id = 31)
order by last_name;

--3.3 -> 9 Rechercher le nom et le titre des employés du service 31 qui ont un titre que l'on trouve dans le département 32.--
select last_name as "Name", title as "Titre"
from employee
where department_id = 32 
and title in (select title from employee where department_id = 32);

--3.3 -> 10 Rechercher le nom et le titre des employés du service 31 qui ont un titre que l'on ne trouve pas dans le département 32--
select last_name as "Name", title as "Titre"
from employee
where department_id = 31
and title not in ( select title from employee where department_id = 32);

--3.3 -> 11  Rechercher le nom, le titre et le salaire des employés qui ont le même titre et le même salaire que « Fairant ».--
select last_name as "Name", title as "Titre", salary as "Salaire"
from employee
where (title, salary) = (select title, salary from employee where last_name = 'fairent');

--3.4 -> 12 Rechercher le numéro de département, le nom du département, le nom des employés, en affichant aussi les départements dans lesquels il n'y a personne,classés par numéro de département.--
select dep.id as "Numéro de département", dep.name as "Nom du département", emp.last_name as "Nome employé"
from department dep
left join employee emp
on dep.id = emp.department_id
order by dep.id

--3.5 -> 13  Calculer la moyenne des salaires des secrétaires --
select last_name as "Name", salary as "Salaire"
from employee
where salary = (select max(salary) from employee);

--3.6 -> 14 Calculer le nombre d’employé de chaque titre.--
select title as "Titre",
count(*) as Nombre_employés
from employee
group by title
order by count(*) desc;

--3.6 -> 15 Calculer la moyenne des salaires et leur somme, par région.--
select dep.region_id,
avg(emp.salary) as "Moyenne des salaires",
sum(emp.salary) as "Somme des salaires"
from employee emp
join department dep on emp.department_id = dep.id
group by dep.region_id
order by dep.region_id;

--3.7 -> 16 Afficher les numéros des départements ayant au moins 3 employés.--
select department_id,
count(*) as "Nombre d'employés"
from employee
group by department_id
having count(*) >=3
order by department_id;

--3.7 -> 17 Afficher les lettres qui sont l'initiale d'au moins trois employés.--
select left(last_name, 1) as "Initiale",
count(*) as "Nombre d'employés"
from employee
group by "Initiale" 
having count(*) >= 3
order by "Initiale";

--3.7 -> 18 Rechercher le salaire maximum et le salaire minimum parmi tous les salariés et l'écart entre les deux--
select max(salary)as "Salaire Max", min(salary) as "Salaire Min", max(salary) - min(salary) as "Ecart de salaire"
from employee;

--3.7 -> 19 Rechercher le nombre de titres différents.--
select count(distinct title) as "Nombre de titre différents"
from employee;

--3.7 -> 20 Pour chaque titre, compter le nombre d'employés possédant ce titre.--
select title as "Titre",
count(*) as "Nombre d'employés par titre"
from employee
group by title   
order by title asc;

--3.7 -> 21 Pour chaque nom de département, afficher le nom du département et le nombre d'employés.--
select dep.name as "Nom de service",
count(emp.id) as "Nombre d'employés"
from department dep
left join employee emp on emp.department_id = dep.id
group by dep.name 
order by dep.name asc;

--3.7 -> 22 Rechercher les titres et la moyenne des salaires par titre dont la moyenne est supérieure à la moyenne des salaires des « Représentant ».--
select title, avg(salary) as "Moyenne des salaires"
from employee
group by title   
having avg(salary) > (select avg(salary) from employee where title = 'représentant')
order by "Moyenne des salaires" asc;

--3.7 -> 23 Rechercher le nombre de salaires renseignés et le nombre de taux de commission renseignés.--
select 
count(salary) as "Nombre de salaires renseignés",
count(commission_rate)as "Nombre de commissions renseignées"
from employee







