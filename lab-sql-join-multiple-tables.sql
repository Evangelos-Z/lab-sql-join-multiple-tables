use sakila;

# 1. Write a query to display for each store its store ID, city, and country.

select s.store_id, ci.city, co.country from store s
left join address a
using (address_id)
inner join city ci
using (city_id)
inner join country co
using (country_id);

# 2. Write a query to display how much business, in dollars, each store brought in.

select sr.store_id, sum(p.amount) as business from store sr
join staff as st
using (store_id)
join payment p
using (staff_id)
group by sr.store_id;	

# using this query (via table staff) we see that the store with id 1 has brought in 33489.47$ and the one with store id 2 has brought in 33927.04$ (total 67416.51)

SELECT s.store_id, SUM(p.amount) AS total_sales
FROM store s
JOIN customer c ON s.store_id = c.store_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY s.store_id;

# HOWEVER using this query (via table customer, solution copied from Nati's work) we see that the store with id 1 has brought in 36103.65$ and the one with store id 2 has brought in 29650.91$

select count(distinct customer_id) from payment;		# 599 customers in payment table
select count(distinct customer_id) from customer;		# 584 customers (we moved inactive users in deleted_users in lab 5)
select count(distinct customer_id) from deleted_users;		# 15 customers in deleted_users --> checks out with distinct customer ids in customer table

select s.store_id, SUM(p.amount) as total_sales
from store s
join deleted_users du on s.store_id = du.store_id
join payment p on du.customer_id = p.customer_id
group by s.store_id;									

# store 2: 764.08$, store 1: 897.87$. altogether the money collected amounts to 36103.65 + 29650.91 + 764.08 + 897.87 = 67416.51$

#### What if I joined store table with staff, payment and customer? ####

select sr.store_id, sum(p.amount) as business from store sr
join staff as st
using (store_id)
join payment p
using (staff_id)
join customer c
using (customer_id)
group by sr.store_id;

# in this case store 1: 32666.43$ and store 2: 33088.13$ for a total of 65754.56$

select sr.store_id, sum(p.amount) as business from store sr
join staff as st
using (store_id)
join payment p
using (staff_id)
join deleted_users du
using (customer_id)
group by sr.store_id;

# adding the amount gained from the deleted users, based on the output of the query above, total --> store 1: 33489.47$ and store 2: 33927,04$ for a grand total of 67416.51$

##### NOTE: total amount joining with the customers or the staff table or both is the same. 2 different outputs for each store for 3 different ways to join #####
### Potential errors in inserted data in regards to staff_id or store_id??? ###
##### VERDICT: I am inclined to consider the output joining with the customers table the most reliable out of the initial 2, since by joining all 4 tables we get the same output as in the case of joining with customers and in the case of all 4 tables the data is more thoroughly matched

select s.store_id, st.staff_id, st.first_name, st.last_name from store s
join staff st
using (store_id)
group by store_id, st.staff_id, st.first_name, st.last_name;			# staff_ids only have one appointed store_id that relates to them

select c.customer_id, count(distinct s.store_id) as both_stores from store s
join customer c
using (store_id)
group by c.customer_id
having both_stores > 1;			# customer_ids only have one appointed store_id that relates to them

### Note 2: up to this point, I could not identify where the issue lies and what is the matter with the first query joining payment with staff and store

# 3. What is the average running time of films by category?

select c.name, avg(f.length) as avg_run_time from category c
left join film_category fc			# making sure that all primary keys from the category table are included
using (category_id)
inner join film f			# only films with an input for catecory_id are included
using (film_id)
group by name;

# Action	111.6094
# Animation	111.0152
# Children	109.8000
# Classics	111.6667
# Comedy	115.8276
# Documentary	108.7500
# Drama		120.8387
# Family	114.7826
# Foreign	121.6986
# Games		127.8361
# Horror	112.4821
# Music		113.6471
# New		111.1270
# Sci-Fi	108.1967
# Sports	128.2027
# Travel	113.3158

# 4. Which film categories are longest?

select c.name, avg(f.length) as avg_run_time from category c
left join film_category fc			
using (category_id)
inner join film f			
using (film_id)
group by name
order by avg_run_time desc
limit 3;

# The 3 categories with the longest films in avg in desc order:
# Sports	128.2027
# Games		127.8361
# Foreign	121.6986

# 5. Display the most frequently rented movies in descending order.

select f.title, count(r.rental_id) as rental_frequency from rental r
join inventory i
using (inventory_id)
join film f
using (film_id)
group by title
order by rental_frequency desc
limit 5;

# 5 most frequently rented films (in times rented) in descending order:
# BUCKET BROTHERHOOD	34
# ROCKETEER MOTHER		33
# FORWARD TEMPLE		32
# ZORRO ARK				32
# GRIT CLOCKWORK		32


# 6. List the top five genres in gross revenue in descending order.

select c.name as genre, sum(p.amount) as gross_revenue from category c
join film_category fc
using (category_id)
join film f
using (film_id)
join inventory i
using (film_id)
join rental r
using (inventory_id)
join payment p
using (rental_id)
group by genre
order by gross_revenue desc
limit 5;

# top 5 genres by gross revenue in descending order:
# Sports	5314.21
# Sci-Fi	4756.98
# Animation	4656.30
# Drama		4587.39
# Comedy	4383.58

# 7. Is "Academy Dinosaur" available for rent from Store 1?

select f.title, r.rental_date as last_time_rented, r.return_date as last_time_returned from rental r
join customer c
using (customer_id)
join store s
using(store_id)
join inventory i
using (store_id)
join film f
using(film_id)
where f.title = "Academy Dinosaur" and store_id = 1
order by title, rental_date, return_date desc
limit 1;

# There is a return date that comes after the last rental date, thus the film is available for rent