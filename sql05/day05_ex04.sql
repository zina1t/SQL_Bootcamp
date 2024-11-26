create index idx_menu_unique on menu (pizzeria_id, pizza_name)

set enable_seqscan to off;
explain analyze
    select menu.pizzeria_id, menu.pizza_name
    from menu
    where pizzeria_id = 4;

set enable_seqscan to on;
explain analyze
    select menu.pizzeria_id, menu.pizza_name
    from menu
    where pizzeria_id = 4;
