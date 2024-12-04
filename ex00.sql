-- In this task I learned how relational model works and how to get needed data based on basic constructions of SQL.

-- returns all person's names and person's ages from the city ‘Kazan’.
SELECT name, age 
FROM person
WHERE 
	address = 'Kazan'

-- statement which returns names, ages for all women from the city ‘Kazan’ sorted by name.
SELECT name, age 
FROM person
WHERE 
	address = 'Kazan' AND gender = 'female'
ORDER BY
	name ASC;

-- 2 syntax different select statements which return a list of pizzerias with rating between 3.5 and 5 points and ordered by pizzeria rating.
SELECT name, rating FROM pizzeria WHERE rating>=3.5 AND rating<=5 ORDER BY rating ASC;
SELECT name, rating FROM pizzeria WHERE rating BETWEEN 3.5 AND 5 ORDER BY rating ASC;

-- select statement that returns the person identifiers (without duplicates) who visited pizzerias in a period from January 6, 2022 to January 9, 2022 
-- or visited pizzerias with identifier 2, ordering clause by person identifier in descending mode.
SELECT DISTINCT person_id 
FROM person_visits
WHERE (visit_date >= '2022-01-06' AND visit_date <= '2022-01-09') OR (pizzeria_id = 2)
ORDER BY person_id DESC;

-- select statement which returns one calculated field with name ‘person_information’ in one string like described in the next sample:
-- Anna (age:16,gender:'female',address:'Moscow')
-- ordering clause by calculated column in ascending mode.
SELECT CONCAT(name, ' (', 'age:', age, ',gender:', '''', gender, '''', ',address:', '''', address, '''', ')') 
AS person_information
FROM person
ORDER BY person_information;

--  select statement that returns the names of people who placed orders for the menu with identifiers 13, 14, and 18, 
-- and the date of the orders should be January 7, 2022.
SELECT name
FROM person
WHERE id IN (SELECT person_id
			 FROM person_order
			 WHERE (menu_id = 13 OR menu_id = 14 OR menu_id = 18) AND (order_date = '2022-01-07'));

-- SQL construction from previous exercise and a new calculated column.
SELECT
(SELECT name FROM person WHERE id = person_order.person_id) AS person_name,
    CASE 
        WHEN (SELECT name FROM person WHERE id = person_order.person_id) = 'Denis' THEN TRUE 
        ELSE FALSE 
    END AS check_name
FROM person_order
WHERE (menu_id='13' OR menu_id='14' OR menu_id='18') AND order_date='2022-01-07';

-- SQL statement that returns the identifiers of a person, the person's names, and the interval of the person's ages.
SELECT id, name, 
CASE WHEN (age >= 10 AND age <= 20) THEN 'interval #1'
WHEN (age > 20 AND age < 24) THEN 'interval #2'
ELSE 'interval #3'
END AS interval_info
FROM person
ORDER BY interval_info;

-- SQL statement that returns all columns from the person_order table with rows whose identifier is an even number. The result is ordered by the returned identifier.
SELECT *
FROM person_order
WHERE (id % 2) = 0
ORDER BY id;

-- select statement that returns person names and pizzeria names based on the person_visits table with a visit date in a period from January 07 to January 09, 2022.
SELECT 
    (SELECT name FROM person WHERE id = pv.person_id) AS person_name,
    (SELECT name FROM pizzeria WHERE id = pv.pizzeria_id) AS pizzeria_name
FROM (SELECT * FROM person_visits WHERE visit_date BETWEEN '2022-01-07' AND '2022-01-09') AS pv
ORDER BY person_name, pizzeria_name DESC;