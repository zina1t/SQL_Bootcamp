alter table person_discounts rename column discount_percent to discount;
alter table person_discounts add constraint ch_nn_person_id check (person_id is not null);
alter table person_discounts add constraint ch_nn_pizzeria_id check (pizzeria_id is not null);
alter table person_discounts add constraint ch_nn_discount check (discount is not null);
alter table person_discounts alter column discount set default 0.00;
alter table person_discounts add constraint ch_range_discount check (discount between 0.00 and 100.00);