select distinct p.name
from person_order o
join person p on o.person_id = p.id
order by p.name