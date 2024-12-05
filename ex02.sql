-- I learned how to get needed data based ON different structures JOINs.

-- SQL statement that returns a list of pizzerias with the corresponding rating value that have not been visited by people.
SELECT name, rating
FROM pizzeria p
WHERE p.name NOT IN
(SELECT p.name
FROM pizzeria p
JOIN person_visits v ON p.id = v.pizzeria_id);

-- SQL statement that returns the missing days from January 1 through January 10, 2022 for visits by people with identifiers 1 or 2 (i.e., days missed by both). 
-- order by visit days in ascending mode.
SELECT DISTINCT dates.date AS  missing_date
FROM generate_series('2022-01-01', '2022-01-31', interval '1 day') AS  dates
JOIN person_visits p ON p.visit_date = dates.date
WHERE visit_date NOT IN (
    SELECT visit_date
    FROM person_visits
    WHERE person_id IN (1, 2)
)
ORDER BY missing_date;

-- SQL statement that will return the entire list of names of people who visited (or did not visit) pizzerias during the period from January 1 to January 3, 2022 on one side 
-- and the entire list of names of pizzerias that were visited (or did not visit) on the other side. 
SELECT 
    coalesce(p.name,'-') AS  person_name, 
    v.visit_date AS  visit_date, 
    coalesce(pz.name,'-') AS  pizzeria_name 
FROM 
    (SELECT * FROM person_visits WHERE visit_date BETWEEN '2022-01-01' AND '2022-01-03') AS  v
FULL JOIN person p ON v.person_id = p.id 
FULL JOIN pizzeria pz ON v.pizzeria_id = pz.id
ORDER BY person_name,visit_date,pizzeria_name;

-- SQL using the CTE (Common Table Expression) pattern.
with series as(
	SELECT dates.date AS  missing_date
	FROM GENERATE_SERIES('2022-01-01', '2022-01-10', interval '1 day') AS  dates)
SELECT DISTINCT missing_date
FROM series s
JOIN person_visits p ON p.visit_date = s.missing_date
WHERE visit_date NOT IN (
    SELECT visit_date
    FROM person_visits
    WHERE person_id IN (1, 2))
ORDER BY missing_date;

-- Complete information about all possible pizzeria names and prices to get mushroom or pepperoni pizza.
-- sort the result by pizza name and pizzeria name.
SELECT m.pizza_name, pz.name AS  pizzeria_name, m.price
FROM menu m
JOIN pizzeria pz ON pz.id = m.pizzeria_id 
WHERE pizza_name LIKE 'mushroom%' or  pizza_name LIKE 'pepperoni%'
ORDER BY m.pizza_name, pizzeria_name;

-- names of all females over the age of 25 and sort the result by name. 
SELECT name
FROM person
WHERE age > 25 AND gender = 'female'
ORDER BY name;

-- all pizza names (and corresponding pizzeria names using the menu table) ordered by Denis or Anna. 
SELECT m.pizza_name, pz.name AS  pizzeria_name
FROM person_order o
JOIN menu m ON m.id = o.menu_id
JOIN person p ON p.id = o.person_id
JOIN pizzeria pz ON pz.id = m.pizzeria_id
WHERE p.name = 'Denis' or p.name = 'Anna'
ORDER BY pizza_name, pizzeria_name;

-- find the name of the pizzeria Dmitriy visited on January 8, 2022 and could eat pizza for less than 800 rubles.
SELECT pz.name
FROM person_visits v
JOIN pizzeria pz ON pz.id = v.pizzeria_id
JOIN person p ON p.id = v.person_id
JOIN menu m ON pz.id = m.pizzeria_id
WHERE v.visit_date = '2022-01-08' AND p.name LIKE 'Dmitriy' AND m.price < 800;

-- find the names of all men from Moscow or Samara who order either pepperoni or mushroom pizza (or both). 
-- sort the result by person names in descending order.
SELECT p.name
FROM person_order o
JOIN person p ON p.id = o.person_id
JOIN menu m ON m.id = o.menu_id
WHERE p.gender = 'male' AND (address = 'Moscow' or address = 'Samara') AND 
	(m.pizza_name LIKE 'mushroom%' or  m.pizza_name LIKE 'pepperoni%')
ORDER BY p.name desc;

-- the names of all women who ordered both pepperoni and cheese pizzas (at any time and in any pizzerias). 
-- the result is ordered by person's name. 
SELECT DISTINCT p.name
FROM person_order o
JOIN person p ON p.id = o.person_id
JOIN menu m ON m.id = o.menu_id
WHERE p.gender = 'female' AND 
(m.pizza_name LIKE 'cheese%' or m.pizza_name LIKE 'pepperoni%')
GROUP BY p.name
HAVING sum(CASE WHEN m.pizza_name LIKE '%cheese%' THEN 1 ELSE 0 END) > 0
        AND sum(CASE WHEN m.pizza_name LIKE '%pepperoni%' THEN 1 ELSE 0 END) > 0
ORDER BY p.name;

-- the names of people who live at the same address. 
-- the result is sorted by 1st person's name, 2nd person's name, and shared address.
SELECT DISTINCT least(p1.name,p2.name) AS  person_name1, greatest(p1.name, p2.name) AS  person_name2, p1.address AS  common_address
FROM person p1, person p2
WHERE p1.address = p2.address AND p1.name != p2.name
ORDER BY person_name1, person_name2, common_address;