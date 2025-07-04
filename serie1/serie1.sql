--3.1 -> 1 Afficher toutes les informations concernant les départements--
select id, name,region_id
from department ;

--3.1 -> 2 Afficher le nom, la date d'embauche, le numéro du supérieur, le numéro de département et le salaire de tous les employés.--
select last_name as "Nom", 
hiring_date as "Date d'embauche", 
superior_id as "Numéro du supérieur", 
department_id as "Numéro du département", salary as "Salaire" 
from employee ;

--3.2 -> 3 Afficher le titre de tous les employé.e.s--
select last_name as "Nom", title from employee;

--3.2 -> 4 Afficher les différentes valeurs des titres des employés --
select distinct title from employee ;

--3.3 -> 5 Afficher toutes les informations des salariés ayant un salaire supérieur à 25000.--
select * from employee where salary > 25000;

--3.3 -> 6 Afficher le nom, le numéro d'employé et le numéro du département des employés dont le titre est « Secrétaire ».--
select last_name as "Nom", id as "Numéro d'employé", department_id as "Numéro de département"
from employee
where title IN ('secrétaire');

--3.3 -> 7 Afficher le nom et le numéro de département dont le numéro de département est supérieur à 40.--
select last_name as "Nom", department_id as "Numéro de département"
from employee
where department_id > 40;

--3.4 -> 8 Afficher le nom et le prénom des employés dont le nom est alphabétiquement antérieur au prénom.--
select last_name as "Nom", first_name as "Prénom"
from employee 
where last_name < first_name;

--3.4 -> 9 Afficher le nom, le salaire et le numéro du département des employés dont le titre est « Représentant », le numéro de département est 35 et le salaire est supérieur à 20000--
select last_name as "Nom", salary as "Salaire", department_id as "Numéro de département"
from employee
where title in ('représentant') and department_id = 35 and salary > 20000;

--3.4 -> 10 Afficher le nom, le titre et le salaire des employés dont le titre est « Représentant » ou dont le titre est « Président ».--
select last_name as "Nom", title, salary
from employee
where title in ('représentant') or title in ('président');

--3.4 -> 11 Afficher le nom, le titre, le numéro de département, le salaire des employés du département 34, dont le titre est « Représentant » ou « Secrétaire ». --
select last_name as "Nom", title, department_id as "Numéro de départemennt", salary
from employee
where department_id = 34 and (title in ('président') or title in ('secrétaire'));

--3.4 -> 12 Afficher le nom, le titre, le numéro de département, le salaire des employés dont le titre est Représentant, ou dont le titre est « Secrétaire » dans le département numéro 34--
select last_name as "Nom", title, department_id as "Numéro de départemennt", salary
from employee
where department_id = 34 and (title in ('représentant') or title in ('secrétaire'));

--3.4 -> 13 Afficher le nom, et le salaire des employés dont le salaire est compris entre 20000 et 30000.--
select last_name as "Nom", salary 
from employee 
where salary between '20000' and '30000';

--3.5 -> 14 Afficher le nom des employés commençant par la lettre « H ».--
select last_name from employee 
where last_name like 'h%';

--3.5 -> 15 Afficher le nom des employés se terminant par la lettre « n ».--
select last_name from employee 
where last_name like '%n';

--3.5 -> 16 Afficher le nom des employés contenant la lettre « u » en 3ème
position.
--
select last_name from employee 
where last_name like '__u%';

--3.6 -> 17 Afficher le salaire et le nom des employés du service 41 classés par salaire croissant.--
select salary,last_name as "Nom" 
from employee
where department_id = 41
order by salary asc ;

--3.6 -> 18 Afficher le salaire et le nom des employés du service 41 classés par salaire décroissant.--
select salary, last_name as "Nom"
from employee
where department_id = 41
order by salary desc ;

--3.6 -> 19 Afficher le titre, le salaire et le nom des employés classés par titre croissant et par salaire décroissant.--
select title, salary, last_name as "Nom"
from employee
order by title asc, salary desc;

--3.7 -> 20 Afficher le taux de commission, le salaire et le nom des employés classés par taux de commission croissante.--
select commission_rate, salary, title 
from employee
where commission_rate is not null
order by commission_rate asc;

--3.7 -> 21 Afficher le nom, le salaire, le taux de commission et le titre des employés dont le taux de commission n'est pas renseigné.--
select last_name as "Nom", salary, commission_rate,title 
from employee
where commission_rate is null;

--3.7 -> 22 Afficher le nom, le salaire, le taux de commission et le titre des employés dont le taux de commission est renseigné.--
select last_name as "Nom",salary, commission_rate, title 
from employee
where commission_rate is not null;

--3.7 -> 23 Afficher le nom, le salaire, le taux de commission, le titre des employés dont le taux de commission est inférieur à 15.--
select last_name as "Nom", salary,commission_rate, title 
from employee
where commission_rate < 15;

--3.7 -> 24 Afficher le nom, le salaire, le taux de commission, le titre des employés dont le taux de commission est supérieur à 15.--
select last_name as "Nom", salary,commission_rate, title 
from employee
where commission_rate > 15;

--3.8 -> 25 Afficher le nom, le salaire, le taux de commission et la commission des employés dont le taux de commission n'est pas nul. (la commission est calculée en multipliant le salaire par le taux de commission).--
select last_name as "Nom", salary, commission_rate, salary*commission_rate as commission
from employee
where commission_rate is not null;

--3.8 -> 26 Afficher le nom, le salaire, le taux de commission, la commission des employés dont le taux de commission n'est pas nul, classé par taux de commission croissant.--
select last_name as "Nom", salary, commission_rate, salary*commission_rate as commission
from employee
where commission_rate is not null
order by commission_rate asc;

--3.9 -> 27 Afficher le nom et le prénom (concaténés) des employés. Renommer les colonnes.--
select id, concat(last_name , ' ', first_name ) as nom_prenom
from employee;

--3.10 -> 28 Afficher les 5 premières lettres du nom des employés--
select substring(last_name from 1 for 5)
from employee;

--3.10 -> 29 Afficher le nom et le rang de la lettre « r » dans le nom des employés--
select last_name,
position('r' in last_name) as position_r
from employee;

--3.10 -> 30 Afficher le nom, le nom en majuscule et le nom en minuscule de l 'employé dont le nom est « Vrante ».--
select id, last_name, upper('vrante') as nom_majuscule, lower('vrante') as nom_minuscule
from employee 
where last_name like 'vrante';

--3.10 -> 31 Afficher le nom et le nombre de caractères du nom des employés.--
select last_name, length('last_name') as nb_caracteres
from employee;









