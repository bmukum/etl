DROP table if exists detail_table;
create table detail_table (
	customer_id integer,
	first_name varchar(50),
	last_name varchar(50),
	email varchar(60),
	payment_id integer,
	amount integer
);

DROP table if exists summary_table;
CREATE table summary_table 
	(
	customer_name varchar(70),
	total_amount integer
)

