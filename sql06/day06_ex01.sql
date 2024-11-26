insert into person_discounts(id, person_id, pizzeria_id, discount_percent)
(
    select row_number() over () as id,
           o.person_id, m.pizzeria_id,
           (case
                when count(person_id) = 1 then 10.5
                when count(person_id) = 2 then 22
                else 30
            end) as discount
    from person_order o
    join menu m on m.id = o.menu_id
    group by o.person_id, m.pizzeria_id
    order by o.person_id
);