DROP table if exists detail_table;
create table detail_table (
	customer_id integer,
	first_name varchar(50),
	last_name varchar(50),
	email varchar(60),
	payment_id integer,
	amount numeric
);

DROP table if exists summary_table;
CREATE table summary_table 
	(
	customer_name varchar(70),
	total_amount numeric,
	email varchar(80)
);

insert into detail_table (
	customer_id,
	first_name,
	last_name,
	email,
	payment_id,
	amount
)
select
	c.customer_id, c.first_name, c.last_name, c.email,
	p.payment_id, p.amount
FROM payment as p
INNER JOIN customer AS c ON c.customer_id = p.customer_id;

create function summary_update_function()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN 

DELETE FROM summary_table;
INSERT INTO summary_table (
	SELECT 
		concat_ws (',', first_name, last_name) AS customer_name,
		sum(amount) AS total_amount,
		email
		
	FROM detail_table
	GROUP BY customer_id, customer_name, email
	HAVING sum(amount) > 30
	ORDER BY count(customer_id)DESC
	limit 50
);

RETURN NEW;
END;$$;

CREATE TRIGGER summary_update_trigger
AFTER INSERT ON detail_table
FOR EACH STATEMENT
EXECUTE PROCEDURE summary_update_function();

CREATE PROCEDURE update_all_table()
LANGUAGE plpgsql
AS $$
BEGIN

DELETE FROM detail_table;

INSERT INTO detail_table(
	customer_id,
	first_name,
	last_name,
	email,
	payment_id,
	amount
)
select
	c.customer_id, c.first_name, c.last_name, c.email,
	p.payment_id, p.amount
FROM payment as p
INNER JOIN customer AS c ON c.customer_id = p.customer_id;
END;$$;

CALL update_all_table();
select * from summary_table;

