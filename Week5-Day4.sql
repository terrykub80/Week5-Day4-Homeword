-- Stored Functions!

select *
from actor;

select count(*)
from actor 
where last_name like 'S%';

select count(*)
from actor 
where last_name like 'T%';




-- CREATE a Stored Function that will give us the count of actors with a last name
-- that begins with *letter

create or replace function get_actor_count(letter VARCHAR(1))
returns integer
language plpgsql
as $$
	declare actor_count INTEGER;
begin
	select count(*) into actor_count
	from actor a
	where a.last_name like concat(letter, '%');
	return actor_count;
end;
$$;


-- EXECUTE FUNCTION
-- use select 
select get_actor_count('S')


-- CREATE a function that will return the employee with the most transactions
-- (based on payment table)

select *
from payment;

select concat(first_name, ' ', last_name) as employee
from staff s where staff_id = (
	select staff_id
	from payment p 
	group by staff_id 
	order by count(*) desc
	limit 1
);


--- STORE above as function

create or replace function employee_with_most_transactions()
returns VARCHAR
language plpgsql
as $$
	declare employee VARCHAR;
begin
	select concat(first_name, ' ', last_name) into employee
	from staff s 
	where staff_id = (
		select staff_id
		from payment p 
		group by staff_id 
		order by count(*) desc
		limit 1
	);
	return employee;
end;
$$;


select employee_with_most_transactions();



-- CREATE a function that will return a TABLE with customer info (first and last)
-- and full address (address, city, district, country)


select c.first_name, c.last_name, a.address, ci.city, a.district, co.country
from customer c 
join address a 
on c.address_id = a.address_id
join city ci
on a.city_id = ci.city_id 
join country co 
on ci.country_id = co.country_id 
where co.country = 'United States';


create or replace function customers_in_country(country_name VARCHAR)
returns table (
	first_name VARCHAR(45),
	last_name VARCHAR(45),
	address VARCHAR(50),
	city VARCHAR(50),
	district VARCHAR(20),
	country VARCHAR(50)
)
language plpgsql
as $$
begin
	return QUERY
	select c.first_name, c.last_name, a.address, ci.city, a.district, co.country
	from customer c 
	join address a 
	on c.address_id = a.address_id
	join city ci
	on a.city_id = ci.city_id 
	join country co 
	on ci.country_id = co.country_id 
	where co.country = country_name;
end;
$$;

-- EXECUTE a funtion that returns a TABLE

select * from customers_in_country('Peru');


-- Use the function and pull specific info
select * from customers_in_country('United States')
where district = 'Illinois'


select district, count(*)
from customers_in_country('Canada')
group by district;


-- To DELETE a function use DROP

drop function get_actor_count;


