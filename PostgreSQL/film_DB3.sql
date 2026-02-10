select * from category;

select * from rental;

select * from customer;

select * from film_category;

select * from inventory;

select ca.category_id, ca.name, count(r.rental_id) as most_popular from category ca
join film_category fc on ca.category_id = fc.category_id
join inventory i on fc.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
group by ca.category_id
order by most_popular desc
limit 1;

select extract(year from rental_date) as rental_year, extract(month from rental_date) as rental_month,
count(*) as monthly_rental_count from rental
where rental_date >= '2005-01-01'
	and rental_date < '2007-01-01'
group by rental_year, rental_month
order by rental_year, rental_month;

select c.customer_id, c.first_name, c.last_name, count(distinct ca.category_id) as most_category from customer c
join rental r on r.customer_id = c.customer_id
join inventory i on i.inventory_id = r.inventory_id
join film_category fc on fc.film_id = i.film_id
join category ca on ca.category_id = fc.category_id
group by c.customer_id, c.first_name, c.last_name
having count(distinct ca.category_id) > 5
order by most_category DESC;

select * from city;

select * from country;

select f.film_id, f.title, co.country from film as f
join inventory i on i.film_id = f.film_id
join rental r on r.inventory_id = i.inventory_id
join customer c on r.customer_id = c.customer_id
join address a on a.address_id = c.address_id
join city ci on ci.city_id = a.city_id
join country co on co.country_id = ci.country_id
where co.country = 'Canada'
group by f.film_id, f.title, co.country;

select * from payment;

select distinct c.customer_id, c.first_name, c.last_name, sum(amount) as total_payment from customer c
join payment p on p.customer_id = c.customer_id
group by c.customer_id, c.first_name, c.last_name
order by total_payment DESC
limit 5;

