select pz.name, count(v.id) as count, 'visit' as action_type
from person_visits v
join pizzeria pz on v.pizzeria_id = pz.id
group by pz.name
union
select pz.name, count(o.id) as count, 'order' as action_type
from person_order o
join menu m on m.id = o.menu_id
join pizzeria pz on m.pizzeria_id = pz.id
group by pz.name
order by action_type asc, count desc;