/* Title Length */

--does title length influence popularity?
with cte as (
	select (length(b.title) - length(replace(b.title, ' ',''))) + 1 as title_length,
		avg(r.rating) as avg_rating,
		count(r.rating)::numeric as cnt
	from books b
	left join ratings r on b.isbn = r.isbn 
	where r.rating is not null 
	group by title_length
), mean as (
	select avg(r.rating) as mean
	from ratings r
	where r.rating is not null
)
select cte.title_length,
	((cte.cnt / (cte.cnt + 100)) * cte.avg_rating) + ((100 / (cte.cnt + 100)) * mean.mean) as weighted_rating
from cte cross join mean
group by title_length, weighted_rating
order by weighted_rating desc
;

--does it change over time? 
with cte as (
	select (length(b.title) - length(replace(b.title, ' ',''))) + 1 as title_length,
		avg(r.rating) as avg_rating,
		count(r.rating)::numeric as cnt,
		b.publication_year as "year"
	from books b
	left join ratings r on b.isbn = r.isbn 
	where r.rating is not null 
	group by "year", title_length
), mean as (
	select avg(r.rating) as mean
	from ratings r
	where r.rating is not null
)
select cte."year",
	cte.title_length,
	((cte.cnt / (cte.cnt + 100)) * cte.avg_rating) + ((100 / (cte.cnt + 100)) * mean.mean) as weighted_rating
from cte cross join mean
where "year" != 0
group by "year", title_length, weighted_rating
order by "year" asc, weighted_rating desc
;


/* Age */

--avg rating per age
with cte as (
	select u.user_age,
		count(r.rating)::numeric as cnt,
		avg(r.rating) as avg_rating
	from ratings r
	inner join users u on r.user_id = u.user_id
	where u.user_age is not null
		and u.user_age >= 10 and u.user_age <= 100
	group by u.user_age
), mean as (
	select avg(r.rating) as mean
	from ratings r
	where r.rating is not null
)
select cte.user_age,
	((cte.cnt / (cte.cnt + 100)) * cte.avg_rating) + ((100 / (cte.cnt + 100)) * mean.mean) as weighted_rating
from cte
cross join mean
order by user_age asc;

--number of ratings per age
select u.user_age,
		count(r.rating) as cnt
from ratings r
inner join users u on r.user_id = u.user_id
where u.user_age is not null
		and u.user_age >= 10 and u.user_age <= 100
group by u.user_age
order by user_age asc
;

--using a case statement to group by age intervals
select case when u.user_age >= 10 and u.user_age <= 19 then '10s'
		when u.user_age >= 20 and u.user_age <= 29 then '20s'
		when u.user_age >= 30 and u.user_age <= 39 then '30s'
		when u.user_age >= 40 and u.user_age <= 49 then '40s'
		when u.user_age >= 50 and u.user_age <= 59 then '50s'
		when u.user_age >= 60 and u.user_age <= 69 then '60s'
		when u.user_age >= 70 and u.user_age <= 79 then '70s'
		when u.user_age >= 80 and u.user_age <= 89 then '80s'
		when u.user_age >= 90 and u.user_age <= 99 then '90s'
	end as age_interval,
	count(r.rating) as cnt,
	round(avg(r.rating), 2) as avg_rating
from ratings r
inner join users u on r.user_id = u.user_id
where u.user_age is not null
group by age_interval
order by age_interval asc;


/* Highest Rated */
--highest rated books based on weighted avg
with cte as (
	select b.title,
		avg(r.rating) as avg_rating,
		count(r.rating)::numeric as cnt
	from books b
	left join ratings r on b.isbn = r.isbn 
	where r.rating is not null 
	group by title
), mean as (
	select avg(r.rating) as mean
	from ratings r
	where r.rating is not null
)
select cte.title,
	round(((cte.cnt / (cte.cnt + 100)) * cte.avg_rating) + ((100 / (cte.cnt + 100)) * mean.mean), 2) as weighted_rating
from cte cross join mean
group by cte.title, weighted_rating
order by weighted_rating desc
limit 10
;

--10 highest rated books for users between ages 30-45
with cte as (
	select b.title,
		avg(r.rating) as avg_rating,
		count(r.rating)::numeric as cnt
	from books b
	left join ratings r on b.isbn = r.isbn 
	where r.rating is not null 
	group by title
), mean as (
	select avg(r.rating) as mean
	from ratings r
	where r.rating is not null
)
select cte.title,
	round(((cte.cnt / (cte.cnt + 100)) * cte.avg_rating) + ((100 / (cte.cnt + 100)) * mean.mean), 2) as weighted_rating
from cte cross join mean
where user_age >= 30 and user_age <= 45
group by cte.title, weighted_rating
order by weighted_rating desc
limit 10
;

--highest rated authors
with cte as (
	select b.author,
		avg(r.rating) as avg_rating,
		count(r.rating)::numeric as cnt
	from books b
	left join ratings r on b.isbn = r.isbn 
	where r.rating is not null 
	group by author
), mean as (
	select avg(r.rating) as mean
	from ratings r
	where r.rating is not null
)
select cte.author,
	round(((cte.cnt / (cte.cnt + 100)) * cte.avg_rating) + ((100 / (cte.cnt + 100)) * mean.mean), 2) as weighted_rating
from cte cross join mean
group by cte.author, weighted_rating
order by weighted_rating desc
limit 10
;

with CTE as (
select b.title,
count(r.rating) as cnt
from books b 
left join ratings r on b.isbn = r.isbn
where r.rating is not null 
group by title
)
select min(cte.cnt) as min_cnt,
	max(cte.cnt) as max_cnt
from cte;