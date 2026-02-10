select * from (
select f.title, count(r.rental_id) as rental_count, rank() over(order by count(r.rental_id) desc) as rental_rank from film f
join inventory i on i.film_id = f.film_id
join rental r on r.inventory_id = i.inventory_id
group by f.film_id) ranked_films
where rental_rank > 0;

select * from payment;

with monthly_revenue as (
select date_trunc('month', payment_date) as month, extract(YEAR from payment_date) as year, sum(amount) as total_revenue from payment
group by year, date_trunc('month', payment_date)
), ranked_months as(
select year, month, total_revenue, rank() over(partition by year order by total_revenue DESC) as revenue_rank from monthly_revenue
)
select year, month, total_revenue from ranked_months
where revenue_rank <= 3
order by year, revenue_rank;

with films_revenue as (
select f.film_id, f.title, sum(p.amount) as total_revenue from film f
join inventory i on i.film_id = f.film_id
join rental r on r.inventory_id = i.inventory_id
join payment p on p.rental_id = r.rental_id group by f.film_id)
select film_id, title, total_revenue from films_revenue
where total_revenue > (select avg(total_revenue) from films_revenue)
order by total_revenue DESC;

select c.customer_id, c.first_name, c.last_name, sum(p.amount) as customer_lifetime_value,
rank() over(order by sum(p.amount) desc) as customer_rank
from customer c
join payment p on p.customer_id = c.customer_id
group by c.customer_id, c.first_name, c.last_name
order by customer_lifetime_value desc;

with film_months as (
select distinct f.film_id, f.title, date_trunc('month', r.rental_date) as rental_month from rental r
join inventory i on i.inventory_id = r.inventory_id
join film f on i.film_id = f.film_id), monthly_sequence as(
select film_id, title, rental_month, lag(rental_month) over(partition by film_id order by rental_month) as prev_month 
from film_months)
select distinct title, to_char(prev_month, 'YYYY-MM') AS month_1, to_char(rental_month, 'YYYY-MM') as month_2 from monthly_sequence 
where rental_month = prev_month + interval '1 month'
order by title;

CREATE MATERIALIZED VIEW film_popularity_by_category AS
SELECT c.category_id, c.name AS category_name, f.film_id, f.title, COUNT(r.rental_id) AS rental_count FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.category_id,c.name,f.film_id,f.title;

refresh materialized view film_popularity_by_category;

select * from film_popularity_by_category
order by rental_count desc;

SELECT *
FROM film_popularity_by_category
ORDER BY category_name, rental_count desc
LIMIT 10;

SELECT * FROM (
SELECT *, RANK() OVER (PARTITION BY category_name ORDER BY rental_count DESC) AS rank_in_category FROM film_popularity_by_category
) ranked_films
WHERE rank_in_category = 1
ORDER BY category_name;

REFRESH MATERIALIZED VIEW film_popularity_by_category;

CREATE OR REPLACE PROCEDURE get_film_revenue(IN p_film_id INT)
LANGUAGE plpgsql
AS $proc$
DECLARE
    total_revenue NUMERIC := 0;
BEGIN
    -- Calculate total revenue
    SELECT COALESCE(SUM(p.amount), 0)
    INTO total_revenue
    FROM film f
    JOIN inventory i   ON f.film_id = i.film_id
    JOIN rental r      ON i.inventory_id = r.inventory_id
    JOIN payment p     ON r.rental_id = p.rental_id
    WHERE f.film_id = p_film_id;

    -- Display result
    RAISE NOTICE 'Total revenue for Film ID % is: %', p_film_id, total_revenue;
END;
$proc$;

call get_film_revenue(879);