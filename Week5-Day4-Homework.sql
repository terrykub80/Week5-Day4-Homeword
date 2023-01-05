-- 1. Create a Stored Procedure that will insert a new film into the film table with the
-- following arguments: title, description, release_year, language_id, rental_duration,
-- rental_rate, length, replace_cost, rating


create or replace procedure add_film(title VARCHAR, description TEXT, release_year YEAR, language_id INTEGER, rental_duration INTEGER, rental_rate numeric(4,2), length integer, replacement_cost numeric(5,2), rating mpaa_rating)
language plpgsql
as $$
begin 
	insert into film(title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating)
	values(title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating);
end;
$$;


call add_film('Hold My Beer', 'The Harrowing Journey of Two Bar Stools Fighting To Make The National Gymnastics Team', 2002, 1, 4, 4.99, 142, 21.99, 'R');


select *
from film
order by film_id desc
limit 5;




-- 2. Create a Stored Function that will take in a category_id and return the number of
-- films in that category


create or replace function get_film_count(num INTEGER)
returns integer
language plpgsql
as $$
	declare film_count INTEGER;
begin
	select count(fc.film_id) into film_count
	from film_category fc
	group by fc.category_id
	having fc.category_id = num; 
	return film_count;
end;
$$;

select get_film_count(5);