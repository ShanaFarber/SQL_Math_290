--number of ratings per age
--avg rating per age
select bu.user_age,
	count(br.rating) as cnt,
	round(avg(br.rating), 2) as avg_rating
from ratings br
inner join users bu on br.user_id = bu.user_id
where bu.user_age is not null
	and bu.user_age >= 10 and bu.user_age <= 100
group by bu.user_age
order by bu.user_age asc;

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

--which books have the highest number of ratings
select b.title,
	count(r.rating) as cnt
from books b
left join ratings r on b.isbn = r.isbn
left join users u on r.user_id = u.user_id
where user_age >= 10 and user_age <= 100
group by b.title
order by cnt desc;

--highest rated books based on count
with cte as(
select b.title,
	count(r.rating) as cnt,
	round (avg(r.rating), 2) as avg_rating
from books b
left join ratings r on b.isbn = r.isbn
left join users u on r.user_id = u.user_id
where user_age >= 10 and user_age <= 100
group by b.title
order by avg_rating desc)
select * from cte
;
 --> maybe order by count instead?
with cte as(
select b.title,
	count(r.rating) as cnt,
	round (avg(r.rating), 2) as avg_rating
from books b
left join ratings r on b.isbn = r.isbn
left join users u on r.user_id = u.user_id
where user_age >= 10 and user_age <= 100
group by b.title
order by cnt desc)
select * from cte
;

--10 highest rated books for users between ages 30-45
with cte as(
select b.title,
	count(r.rating) as cnt,
	round (avg(r.rating), 2) as avg_rating
from books b
left join ratings r on b.isbn = r.isbn
left join users u on r.user_id = u.user_id
where user_age >= 30 and user_age <= 45
group by b.title
order by avg_rating desc)
select * from cte
where cnt > 50
limit 10
;

with cte as(
select b.title,
	count(r.rating) as cnt,
	round (avg(r.rating), 2) as avg_rating
from books b
left join ratings r on b.isbn = r.isbn
left join users u on r.user_id = u.user_id
where user_age >= 30 and user_age <= 45
group by b.title
order by avg_rating desc)
select * from cte
where cnt > 100 and cnt < 300
limit 10
;

--ratings count by country
with cte as (
select u.user_location [3] as country,
	count(r.rating) as cnt,
	round (avg(r.rating), 2) as avg_rating
from ratings r
left join  users u
on u.user_id = r.user_id
where user_age >= 10 and user_age <= 100
group by country)
select * from cte
order by cnt  desc
;

--user location, number of ratings by state
with cte as (
select u.user_location [2] as state,
	count(r.rating) as cnt,
	round (avg(r.rating), 2) as avg_rating
from ratings r
left join  users u
on u.user_id = r.user_id
where user_age >= 10 and user_age <= 100
group by state)
select * from cte
order by cnt  desc
;


--
select
	case
	when r.rating = 0 then 0
	when r.rating = 1 then 1
	when r.rating = 2 then 2
	when r.rating = 3 then 3
	when r.rating = 4 then 4
	when r.rating = 5 then 5
	when r.rating = 6 then 6
	when r.rating = 7 then 7
	when r.rating = 8 then 8
	when r.rating = 9 then 9
	when r.rating = 10 then 10
end as averageRating_band,
count (r.rating)
from ratings r
group by averageRating_band
;

-- Harry Potter books
select *
from books b
where regexp_split_to_array(b.title,' ') @> '{Harry,Potter}'

--10 highest rated books based on weighted average rating
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

--top 10 authors
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