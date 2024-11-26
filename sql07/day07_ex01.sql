select p.name, count(v.id) as count_of_visits
from person_visits v
join person p on v.person_id = p.id
group by p.name
order by count_of_visits desc, p.name asc
limit 4;