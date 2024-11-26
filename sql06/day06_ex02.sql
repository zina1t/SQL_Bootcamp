select p.name, m.pizza_name, m.price, (m.price - m.price * discount_percent/100) as discount_price, pz.name
from menu m
join pizzeria pz on pz.id = m.pizzeria_id
join person_discounts d on pz.id = d.pizzeria_id
join person p on d.person_id = p.id
order by p.name, m.pizza_name