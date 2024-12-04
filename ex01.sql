-- I learned how to get needed data based on sets constructions and simple JOINs.

-- SQL statement that returns the menu identifier and pizza names from the menu table and the person identifier 
-- and person name from the person table in one global list ordered by object_id and then by object_name columns.
SELECT id AS object_id,
    pizza_name AS object_name
FROM menu
UNION
SELECT id AS object_id,
    name AS object_name
FROM person
ORDER BY object_id,
    object_name;

-- SQL statement from previous statement by removing the object_id column. 
-- Then change the order by object_name for part of the data from the person table and then from the menu table.
SELECT pizza_name AS object_name
FROM menu
UNION ALL
SELECT name AS object_name
FROM person
ORDER BY object_name;

--  SQL statement that returns unique pizza names from the menu table and sorts them by the pizza_name column in descending order.
SELECT pizza_name
FROM menu
UNION
SELECT pizza_name
FROM menu
ORDER BY pizza_name DESC;

-- SQL statement that returns common rows for attributes order_date, person_id from the person_order table on one side 
-- and visit_date, person_id from the person_visits table on the other side. 
-- order by action_date in ascending mode and then by person_id in descending mode.
SELECT order_date AS action_date,
    person_id
FROM person_order
intersect
SELECT visit_date AS action_date,
    person_id
FROM person_visits
ORDER BY action_date ASC,
    person_id desc;

-- SQL statement that returns a difference (minus) of person_id column values while saving duplicates between person_order table and person_visits table 
-- for order_date and visit_date are for January 7, 2022.
SELECT person_id
FROM person_order
WHERE order_date = '2022-01-07'
except all
SELECT person_id
FROM person_visits
WHERE visit_date = '2022-01-07';

-- SQL statement that returns all possible combinations between person and pizzeria tables
-- the order of the person identifier columns and then the pizzeria identifier columns. 
SELECT person.id,
    person.name,
    age,
    gender,
    address,
    pizzeria.id,
    pizzeria.name,
    rating
FROM person,
    pizzeria
ORDER BY person.id,
    pizzeria.id;

-- SQL statement to return person names instead of person identifiers and
-- the order by action_date in ascending mode and then by person_name in descending mode. 
SELECT action_date,
    name AS person_name
FROM person,
    (
        SELECT order_date AS action_date,
            person_id
        FROM person_order
        INTERSECT
        SELECT visit_date AS action_date,
            person_id
        FROM person_visits
    ) AS t2
WHERE t2.person_id = person.id
ORDER BY action_date ASC,
    person_name desc;
-- SQL statement that returns the order date from the person_order table and the corresponding person name who made an order from the person table. 
-- a sort by both columns in ascending order.
SELECT o.order_date,
    CONCAT(p.name, ' (age:', p.age, ')') AS person_information
FROM person p
    JOIN person_order o ON p.id = o.person_id
ORDER BY o.order_date ASC,
    person_information ASC;

-- same SQL statement by using NATURAL JOIN construction.
SELECT o.order_date,
    CONCAT(p.name, ' (age:', p.age, ')') AS person_information
FROM person p
    NATURAL JOIN (
        SELECT person_id AS id,
            order_date
        FROM person_order
    ) AS o
ORDER BY o.order_date ASC,
    p.name ASC,
    p.age ASC;

-- 2 SQL statements that return a list of pizzerias that have not been visited by people using IN for the first and EXISTS for the second.
SELECT p.name
FROM pizzeria p
WHERE p.id NOT IN (
        SELECT v.pizzeria_id
        FROM person_visits v
    )
SELECT p.name
FROM pizzeria p
WHERE NOT EXISTS (
        SELECT v.pizzeria_id
        FROM person_visits v
        WHERE p.id = v.pizzeria_id
    );

-- SQL statement that returns a list of the names of the people who ordered pizza from the corresponding pizzeria.
SELECT p.name AS person_name,
    m.pizza_name AS pizza_name,
    pz.name AS pizzeria_name
FROM person_order o
    JOIN menu m ON o.menu_id = m.id
    JOIN pizzeria pz ON m.pizzeria_id = pz.id
    JOIN person p ON p.id = o.person_id
ORDER BY person_name ASC,
    pizza_name ASC,
    pizzeria_name ASC;