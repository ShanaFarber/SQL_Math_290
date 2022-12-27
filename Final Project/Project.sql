--joining number of ratings and average rating as a weighted average 
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
	((cte.cnt / (cte.cnt + 100)) * cte.avg_rating) + ((100 / (cte.cnt + 100)) * mean.mean) as weighted_rating
from cte cross join mean
group by cte.title, weighted_rating
order by weighted_rating desc
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
where year >= 1950 and year <= 2004
group by "year", title_length, weighted_rating
order by "year" asc, weighted_rating desc
;

--case statement 
with cte as (
	select (length(b.title) - length(replace(b.title, ' ',''))) + 1 as title_length,
		avg(r.rating) as avg_rating,
		count(r.rating)::numeric as cnt,
		case when b.publication_year < 1950 then 'pre-1950'
			when b.publication_year >= 1950 and b.publication_year < 1960 then '1950s'
			when b.publication_year >= 1960 and b.publication_year < 1970 then '1960s'
			when b.publication_year >= 1970 and b.publication_year < 1980 then '1970s'
			when b.publication_year >= 1980 and b.publication_year < 1990 then '1980s'
			when b.publication_year >= 1990 and b.publication_year < 2000 then '1990s'
			when b.publication_year >= 2000 and b.publication_year < 2010 then '2000s'
		end as year_interval
	from books b
	left join ratings r on b.isbn = r.isbn 
	where r.rating is not null 
	group by year_interval, title_length
), mean as (
	select avg(r.rating) as mean
	from ratings r
	where r.rating is not null
)
select cte.year_interval,
	cte.title_length,
	((cte.cnt / (cte.cnt + 100)) * cte.avg_rating) + ((100 / (cte.cnt + 100)) * mean.mean) as weighted_rating
from cte cross join mean
group by year_interval, title_length, weighted_rating
order by year_interval, weighted_rating desc
;