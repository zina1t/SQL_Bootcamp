set enable_seqscan to on;
explain analyze
    select m.pizza_name, pz.name
    from menu m
    join pizzeria pz on pz.id = m.pizzeria_id;

set enable_seqscan to off;
explain analyze
    select m.pizza_name, pz.name
    from menu m
    join pizzeria pz on pz.id = m.pizzeria_id;
