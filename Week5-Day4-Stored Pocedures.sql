-- STORED PROCEDURES!

select *
from customer c
where loyalty_member = true;


-- Reset all customers loyalty to FALSE

update customer
set loyalty_member = false;



-- CREATE a procedure that will set anyone who has spent >= $100 to loyalty members

--			query to get the cusotmers that have spend >= $100

select customer_id, sum(amount)
from payment
group by customer_id
having sum(amount) >= 100;

-- 			Update all customers who have spendt more than $100
update customer
set loyalty_member = true 
where customer_id in (
	select customer_id
	from payment
	group by customer_id
	having sum(amount) >= 100
);

-- 			Put into a stored procedure

create or replace procedure update_loyalty_status(loyalty_min numeric(5,2) default 100.00)
language plpgsql
as $$
begin 
	update customer
	set loyalty_member = true 
	where customer_id in (
		select customer_id
		from payment
		group by customer_id
		having sum(amount) >= loyalty_min
	);
end;
$$;


--  		Execute the procedure with CALL
call update_loyalty_status();


select *
from customer c
where loyalty_member = true;



-- 			Find a customer who is close to the minimum

select customer_id, sum(amount)
from payment p 
group by customer_id 
having sum(amount) between 95 and 100;

-- 			Choose a customer (#554) and push over threshold
-- 			by adding a payment of $4.99

insert into payment(customer_id, staff_id, rental_id, amount, payment_date)
values (554, 1, 1, 4.99, '2023-01-05 14:14:25')


call update_loyalty_status();

select *
from customer c
where customer_id = 554;


-- CREATE a procedure to add new rows to a table
select *
from actor;
-- 			this is how you'd have to do every time without procedure
insert into actor(first_name, last_name, last_update)
values ('Terry', 'Ryan', NOW());


-- 			CREATE a procedure that takes a full name and adds to actor table 
create or replace procedure add_actor(full_name VARCHAR)
language plpgsql
as $$
begin 
	insert into actor(first_name, last_name, last_update)
	values (SPLIT_PART(full_name, ' ', 1), SPLIT_PART(full_name, ' ', 2), NOW());
end;
$$;

call add_actor('Jeremy Renner');

select *
from actor
where last_name = 'Renner';

call add_actor('Isaac Kubalewski');

select *
from actor
where last_name = 'Kubalewski';


-- To delete a procedure, we use DROP
drop procedure if exists add_actor;

