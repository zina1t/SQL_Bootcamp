select p.name, count(v.id) as count
from person_visits v
join person p on p.id = v.person_id
group by p.name
having count(v.id) > 3