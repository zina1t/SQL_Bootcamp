select pz.name, count(o.id) as count_of_orders, round(avg(m.price), 2) as average_price,
       max(m.price) as max_price, min(m.price) as min_price
from menu m
join person_order o on m.id = o.menu_id
join pizzeria pz on pz.id = m.pizzeria_id
group by pz.name
order by pz.name;