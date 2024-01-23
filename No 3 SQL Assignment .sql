-- Active: 1700300664460@@127.0.0.1@3306;
use mavenmovies;
-- 1. **Join Practice:**
 --  Write a query to display the customer's first name, last name, email, and city they live in.
 
 select concat(first_name," ",last_name) as name, email,city from customer
 left join address on customer.address_id=address.address_id
 left join city on address.city_id=city.city_id;

-- 2. **Subquery Practice (Single Row):**
--  Retrieve the film title, description, and release year for the film that has the longest duration
select * from film;
select title, DESCRIPTION , release_year from film where rental_duration in(
  select max(rental_duration) from film
);
-- 3. *Join Practice (Multiple Joins):
-- List the customer name, rental date, and film title for each rental made. Include customers who have never
-- rented a film.

select concat(first_name," ",last_name) as name, rental_rate, 
rental_date, title from 
customer right join rental on customer.customer_id=rental.rental_id
right join film on rental.last_update=film.last_update

;
4. **Subquery Practice (Multiple Rows):**
Find the number of actors for each film. Display the film title and the number of actors for each film.

SELECT title, actor_id
FROM film
inner JOIN (
    SELECT film_id, actor_id, COUNT(actor_id) as total_actor
    FROM film_actor
    GROUP BY film_id, actor_id
) AS film_actor
ON film.film_id = film_actor.film_id;


-- 5. **Join Practice (Using Aliases):**
 --  Display the first name, last name, and email of customers along with the rental date, film title, and rental 
--  return date.

select c.first_name,c.last_name,c.email,
rental_date ,title,rental_rate from customer
c left join rental r on c.customer_id=r.customer_id
left join inventory inv on r.inventory_id=inv.inventory_id
left join film f on inv.film_id=f.film_id;

-- 6. **Subquery Practice (Conditional):**
--  Retrieve the film titles that are rented by customers whose email domain ends with '.net'.

select title from film where film_id in (select
film_id from inventory where inventory_id in(select inventory_id from rental where 
customer_id in (select customer_id from customer where email like "%.net")));

-- 7. **Join Practice (Aggregation):**
 --  Show the total number of rentals made by each customer, along with their first and last names.

 select concat(first_name," ",last_name) as Name,rental_rate
   from customer
 right join rental on customer.customer_id=rental.customer_id
 right join inventory on rental.inventory_id=inventory.inventory_id
 right join  film on inventory.film_id=film.film_id
 ;

 use mavenmovies;
-- 8. **Subquery Practice (Aggregation):**
--  List the customers who have made more rentals than the average number of rentals made by all 
--  customers.

SELECT first_name, last_name
FROM customer
WHERE (SELECT amount FROM payment WHERE amount > (SELECT AVG(amount) FROM payment));


-- 9. **Join Practice (Self Join):**
--  Display the customer first name, last name, and email along with the names of other customers living in 
-- the same city

select concat(first_name," ",last_name) as name ,city,email from customer
right join address on customer.address_id=address.address_id
right join city on address.city_id=city.city_id ;

-- 10. **Subquery Practice (Correlated Subquery):**
-- Retrieve the film titles with a rental rate higher than the average rental rate of films in the same category.

SELECT title
FROM film
WHERE rental_rate > (
    SELECT AVG(rental_rate)
    FROM film
    WHERE film_id IN (
        SELECT film_id
        FROM film_category
        WHERE category_id = (
            SELECT MAX(category_id)
            FROM category)));


-- 11. **Subquery Practice (Nested Subquery):**
-- Retrieve the film titles along with their descriptions and lengths that have a rental rate greater than the 
--average rental_rate of films released in the same year.
 
 select title,description,length from film  f where rental_rate > 
 (select avg(rental_rate) from film where release_year=f.release_year );

--  12. **Subquery Practice (IN Operator):**
--  List the first name, last name, and email of customers who have rented at least one film in the 
-- 'Documentary' category.
select first_name,last_name,email from customer where customer_id in(
  select customer_id from rental where rental_id in (select rental_id from payment
  where payment_id in(select last_update from film where film_id in (select 
  film_id from film_category where category_id =(select category_id from category where name=
  "Documentary"))))
);


-- 13. **Subquery Practice (Scalar Subquery):**
--  Show the title, rental rate, and difference from the average rental rate for each film. 
SELECT title,rental_rate, rental_rate - AVG(rental_rate) OVER () AS difference
FROM film;

-- 14. **Subquery Practice (Existence Check):**
--  Retrieve the titles of films that have never been rented.
select title from film where film_id in (select film_id from inventory where inventory_Id IN
(select inventory_id from rental where rental_id !=rental.rental_id));


-- 15. **Subquery Practice (Correlated Subquery - Multiple Conditions):**
--  List the titles of films whose rental rate is higher than the average rental rate of films released in the same 
--  year and belong to the 'Sci-Fi' category.

select title,rental_rate from film where rental_rate >(select avg(rental_rate)
from film where film_id in(select film_id from film_category where category_id =(SELECT
category_id from category where name = "Sci-Fi")));

-- 16. **Subquery Practice (Conditional Aggregation):**
--  Find the number of films rented by each customer, excluding customers who have rented fewer than five 
--  films.
select customer_id,count(rental_id) as film_count
from rental group by customer_id having count(rental_id)>=5;

