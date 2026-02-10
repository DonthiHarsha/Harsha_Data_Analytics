select * from film;

select title, release_year from film;

select count(*) as total_films from film;

select * from customer;

select distinct cu.customer_id, cu.first_name, cu.last_name from customer cu
join rental r
on cu.customer_id = r.customer_id;

select * from film_category;

select * from category;

select f.film_id, f.title from film f
join film_category fc
on f.film_id = fc.film_id
join category ca
on ca.category_id = fc.category_id
where ca.category_id = 1;

select ca.category_id, count(f.film_id) as num_of_films from film f
join film_category fc
on f.film_id = fc.film_id
join category ca 
on ca.category_id = fc.category_id
group by ca.category_id
order by ca.category_id ASC;

select title, length from film
order by length DESC
limit 5;

select * from rental;

select count(*) as num_of_rentals from rental
where rental_date >= '2006-01-01'
	and rental_date < '2006-02-01';

select film_id, title, release_year, length, rental_rate from film
where rental_rate > 3.00;

select * from city;

select * from customer;

select * from address;

select distinct c.city from city c
join address a
on a.city_id = c.city_id
join customer cu
on a.address_id = cu.address_id
order by c.city;

select s.staff_id, s.first_name, s.last_name, count(r.rental_id) as total_rentals from staff s
join rental r
on r.staff_id = s.staff_id
group by s.staff_id;

