select * from film;

select * from rental;

select f.film_id, f.title, count(r.rental_id) as num_of_rentals from film as f
join inventory i on i.film_id = f.film_id
join rental r on i.inventory_id = r.inventory_id
group by f.film_id
order by num_of_rentals DESC
limit 10;


select * from payment;


select f.film_id, f.title, sum(p.payment_id) as revenue from film as f
join inventory as i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by f.film_id
order by revenue desc;

select * from customer;

select c.customer_id, c.first_name, c.last_name, count(r.rental_id) from customer c
join rental r on c.customer_id = r.customer_id
group by c.customer_id
having count(r.rental_id) > 20
order by count(r.rental_id) DESC;

select * from film_category;

select * from category;

select ca.category_id, ca.name, avg(f.rental_duration) as avg_duration from category as ca
join film_category as fc on ca.category_id = fc.category_id
join film as f on fc.film_id = f.film_id
group by ca.category_id
order by avg_duration desc;

select f.film_id, f.title, f.rental_duration from film f
join inventory i on i.film_id = f.film_id
join rental r on r.inventory_id = i.inventory_id
group by f.film_id, f.title
having count(*) filter(
	where r.return_date > r.rental_date + (f.rental_duration || 'days')::interval) = 0;

select ca.category_id, ca.name, count(r.rental_id) as rental_count from category ca
join film_category fc on fc.category_id = ca.category_id
join film f on f.film_id = fc.film_id
join inventory i on i.film_id = f.film_id
join rental r on r.inventory_id = i.inventory_id
group by ca.category_id
order by rental_count DESC
limit 1;