-- I learned how to change data based on DML language.

-- 1
SELECT 
    m.pizza_name,
    m.price,
    pz.name as pizzeria_name,
    v.visit_date
from pizzeria pz
join person_visits v on v.pizzeria_id = pz.id
join menu m on m.pizzeria_id = pz.id
join person p on p.id = v.person_id
where (price between 800 and 1000) and (p.name like 'Kate')
order by pizza_name, price, pizzeria_name;

-- 2
select m.id
from menu m
where m.id not in (
    select m.id 
    from menu m 
    join person_order o on o.menu_id = m.id
    )
order by id;

-- 3
select m.pizza_name, m.price, pz.name
from menu m
join pizzeria pz on m.pizzeria_id = pz.id
where m.id not in (
    select m.id 
    from menu m 
    join person_order o on o.menu_id = m.id
    )

order by pizza_name, price;

-- 4
(select pz.name as pizzeria_name
from person_visits v
join person p on p.id = v.person_id
join pizzeria pz on pz.id = v.pizzeria_id
where (p.gender = 'female')
except all
select pz.name as pizzeria_name
from person_visits v
join person p on p.id = v.person_id
join pizzeria pz on pz.id = v.pizzeria_id
where (p.gender = 'male'))
union all
(select pz.name as pizzeria_name
from person_visits v
join person p on p.id = v.person_id
join pizzeria pz on pz.id = v.pizzeria_id
where (p.gender = 'male')
except all
select pz.name as pizzeria_name
from person_visits v
join person p on p.id = v.person_id
join pizzeria pz on pz.id = v.pizzeria_id
where (p.gender = 'female'))
order by pizzeria_name;

-- 5
(select pz.name as pizzeria_name
from menu m
join person_order o on o.menu_id = m.id
join person p on p.id = o.person_id
join pizzeria pz on m.pizzeria_id = pz.id
where (p.gender = 'female')
except all
select pz.name as pizzeria_name
from menu m
join person_order o on o.menu_id = m.id
join person p on p.id = o.person_id
join pizzeria pz on m.pizzeria_id = pz.id
where (p.gender = 'male'))
union
(select pz.name as pizzeria_name
from menu m
join person_order o on o.menu_id = m.id
join person p on p.id = o.person_id
join pizzeria pz on m.pizzeria_id = pz.id
where (p.gender = 'male')
except
select pz.name as pizzeria_name
from menu m
join person_order o on o.menu_id = m.id
join person p on p.id = o.person_id
join pizzeria pz on m.pizzeria_id = pz.id
where (p.gender = 'female'));

-- 6
select distinct pz.name as pizzeria_name
from person_visits v
join pizzeria pz on pz.id = v.pizzeria_id
join person p on p.id = v.person_id
join person_order o on o.person_id = p.id
where p.name like 'Andrey' and v.visit_date != o.order_date;

-- 7 
select m1.pizza_name, pz1.name as pizzeria_name_1, pz2.name as pizzeria_name_2, m1.price
from menu m1
join menu m2 on m1.price = m2.price and m1.id > m2.id and m1.pizza_name = m2.pizza_name and m1.pizzeria_id <> m2.pizzeria_id
join pizzeria pz1 on m1.pizzeria_id = pz1.id
join pizzeria pz2 on m2.pizzeria_id = pz2.id
order by m1.pizza_name;

-- 8
insert into menu values (19,2,'greek pizza', 800)

-- 9
insert into menu values
((select max(id) + 1 from menu),
(select id from pizzeria where name like 'Dominos'),
'sicilian pizza', 
900)

-- 10
insert into person_visits values
((select max(id) +1 from person_visits),
(select distinct person_id
from person_visits v
join person p on p.id = v.person_id
where p.name like 'Denis'),
(select distinct pizzeria_id from person_visits, pizzeria
                     where person_visits.pizzeria_id = pizzeria.id and pizzeria.name = 'Dominos'),
'2022-02-24');

insert into person_visits values
((select max(id) +1 from person_visits),
(select distinct person_id
from person_visits v
join person p on p.id = v.person_id
where p.name like 'Irina'),
(select distinct pizzeria_id from person_visits, pizzeria
                     where person_visits.pizzeria_id = pizzeria.id and pizzeria.name = 'Dominos'),
'2022-02-24');

-- 11
insert into person_order values
((select max(id) + 1 from person_order),
 (select distinct person_id
from person_visits v
join person p on p.id = v.person_id
where p.name like 'Denis'),
 (select m.id
  from menu m
  where m.pizza_name like 'sicilian pizza'),
'2022-02-24'
);

insert into person_order values
((select max(id) + 1 from person_order),
 (select distinct person_id
from person_visits v
join person p on p.id = v.person_id
where p.name like 'Irina'),
 (select m.id
  from menu m
  where m.pizza_name like 'sicilian pizza'),
'2022-02-24'
);

-- 12
update menu
set price = price * 0.9
where pizza_name like 'greek pizza';

-- 13
insert into person_order(id, person_id, menu_id, order_date)
select
    generate_series(
            (select max(id) + 1 from person_order),
            (select max(id) from person_order) + (select count(id) from person),
            1),
    generate_series(
            (select min(id) from person),
            (select max(id) from person),
            1),
 (select m.id
  from menu m
  where m.pizza_name like 'greek pizza'),
 '2022-02-25';

 -- 14
delete from person_order where order_date = '2022-02-25';
delete from menu where pizza_name like 'greek_pizza';
