-- I learned how to change data based ON DML language.

-- 
SELECT 
    m.pizza_name,
    m.price,
    pz.name AS pizzeria_name,
    v.visit_date
FROM pizzeria pz
JOIN person_visits v ON v.pizzeria_id = pz.id
JOIN menu m ON m.pizzeria_id = pz.id
JOIN person p ON p.id = v.person_id
WHERE (price BETWEEN 800 AND 1000) AND (p.name LIKE 'Kate')
ORDER BY pizza_name, price, pizzeria_name;

SELECT m.id
FROM menu m
WHERE m.id not in (
    SELECT m.id 
    FROM menu m 
    JOIN person_order o ON o.menu_id = m.id
    )
ORDER BY id;

SELECT m.pizza_name, m.price, pz.name
FROM menu m
JOIN pizzeria pz ON m.pizzeria_id = pz.id
WHERE m.id not in (
    SELECT m.id 
    FROM menu m 
    JOIN person_order o ON o.menu_id = m.id
    )

ORDER BY pizza_name, price;

(SELECT pz.name AS pizzeria_name
FROM person_visits v
JOIN person p ON p.id = v.person_id
JOIN pizzeria pz ON pz.id = v.pizzeria_id
WHERE (p.gender = 'female')
except all
SELECT pz.name AS pizzeria_name
FROM person_visits v
JOIN person p ON p.id = v.person_id
JOIN pizzeria pz ON pz.id = v.pizzeria_id
WHERE (p.gender = 'male'))
union all
(SELECT pz.name AS pizzeria_name
FROM person_visits v
JOIN person p ON p.id = v.person_id
JOIN pizzeria pz ON pz.id = v.pizzeria_id
WHERE (p.gender = 'male')
except all
SELECT pz.name AS pizzeria_name
FROM person_visits v
JOIN person p ON p.id = v.person_id
JOIN pizzeria pz ON pz.id = v.pizzeria_id
WHERE (p.gender = 'female'))
ORDER BY pizzeria_name;

-- 5
(SELECT pz.name AS pizzeria_name
FROM menu m
JOIN person_order o ON o.menu_id = m.id
JOIN person p ON p.id = o.person_id
JOIN pizzeria pz ON m.pizzeria_id = pz.id
WHERE (p.gender = 'female')
except all
SELECT pz.name AS pizzeria_name
FROM menu m
JOIN person_order o ON o.menu_id = m.id
JOIN person p ON p.id = o.person_id
JOIN pizzeria pz ON m.pizzeria_id = pz.id
WHERE (p.gender = 'male'))
union
(SELECT pz.name AS pizzeria_name
FROM menu m
JOIN person_order o ON o.menu_id = m.id
JOIN person p ON p.id = o.person_id
JOIN pizzeria pz ON m.pizzeria_id = pz.id
WHERE (p.gender = 'male')
except
SELECT pz.name AS pizzeria_name
FROM menu m
JOIN person_order o ON o.menu_id = m.id
JOIN person p ON p.id = o.person_id
JOIN pizzeria pz ON m.pizzeria_id = pz.id
WHERE (p.gender = 'female'));

-- 6
SELECT distinct pz.name AS pizzeria_name
FROM person_visits v
JOIN pizzeria pz ON pz.id = v.pizzeria_id
JOIN person p ON p.id = v.person_id
JOIN person_order o ON o.person_id = p.id
WHERE p.name LIKE 'ANDrey' AND v.visit_date != o.order_date;

-- 7 
SELECT m1.pizza_name, pz1.name AS pizzeria_name_1, pz2.name AS pizzeria_name_2, m1.price
FROM menu m1
JOIN menu m2 ON m1.price = m2.price AND m1.id > m2.id AND m1.pizza_name = m2.pizza_name AND m1.pizzeria_id <> m2.pizzeria_id
JOIN pizzeria pz1 ON m1.pizzeria_id = pz1.id
JOIN pizzeria pz2 ON m2.pizzeria_id = pz2.id
ORDER BY m1.pizza_name;

-- 8
INSERT INTO menu values (19,2,'greek pizza', 800)

-- 9
INSERT INTO menu values
((SELECT max(id) + 1 FROM menu),
(SELECT id FROM pizzeria WHERE name LIKE 'Dominos'),
'sicilian pizza', 
900)

-- 10
INSERT INTO person_visits values
((SELECT max(id) +1 FROM person_visits),
(SELECT distinct person_id
FROM person_visits v
JOIN person p ON p.id = v.person_id
WHERE p.name LIKE 'Denis'),
(SELECT distinct pizzeria_id FROM person_visits, pizzeria
                     WHERE person_visits.pizzeria_id = pizzeria.id AND pizzeria.name = 'Dominos'),
'2022-02-24');

INSERT INTO person_visits values
((SELECT max(id) +1 FROM person_visits),
(SELECT distinct person_id
FROM person_visits v
JOIN person p ON p.id = v.person_id
WHERE p.name LIKE 'Irina'),
(SELECT distinct pizzeria_id FROM person_visits, pizzeria
                     WHERE person_visits.pizzeria_id = pizzeria.id AND pizzeria.name = 'Dominos'),
'2022-02-24');

-- 11
INSERT INTO person_order values
((SELECT max(id) + 1 FROM person_order),
 (SELECT distinct person_id
FROM person_visits v
JOIN person p ON p.id = v.person_id
WHERE p.name LIKE 'Denis'),
 (SELECT m.id
  FROM menu m
  WHERE m.pizza_name LIKE 'sicilian pizza'),
'2022-02-24'
);

INSERT INTO person_order values
((SELECT max(id) + 1 FROM person_order),
 (SELECT distinct person_id
FROM person_visits v
JOIN person p ON p.id = v.person_id
WHERE p.name LIKE 'Irina'),
 (SELECT m.id
  FROM menu m
  WHERE m.pizza_name LIKE 'sicilian pizza'),
'2022-02-24'
);

-- 12
update menu
set price = price * 0.9
WHERE pizza_name LIKE 'greek pizza';

-- 13
INSERT INTO person_order(id, person_id, menu_id, order_date)
SELECT
    generate_series(
            (SELECT max(id) + 1 FROM person_order),
            (SELECT max(id) FROM person_order) + (SELECT count(id) FROM person),
            1),
    generate_series(
            (SELECT min(id) FROM person),
            (SELECT max(id) FROM person),
            1),
 (SELECT m.id
  FROM menu m
  WHERE m.pizza_name LIKE 'greek pizza'),
 '2022-02-25';

 -- 14
DELETE FROM person_order WHERE order_date = '2022-02-25';
DELETE FROM menu WHERE pizza_name LIKE 'greek_pizza';
