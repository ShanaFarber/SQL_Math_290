/* Homework 9 */

--Q1: Are movie ratings normally distributed? To answer this question, take the following steps.

--Visualize the data in a histogram and observe if the ratings adhere to a bell curve (use PowerBI to do this)
	
--Look at the descriptive statistics of the data (n, min, max, mean, variance, skewness, kurtosis)

with cte as(
	select count(*) as cnt, 
		min("averageRating") as min_rating, 
		max("averageRating") as max_rating,
		round(variance("averageRating"), 2) as rating_variance,
		round(stddev("averageRating"), 2) as standard_deviation,
		avg("averageRating") as avg_avgRating,
		percentile_cont(0.5) within group (order by"averageRating") as median_rating
	from xf_title_ratings tr 
)
select cte."cnt",
	cte."min_rating",
	cte."max_rating",
	round(cte."avg_avgrating", 2) as mean,
	cte."rating_variance",
	round(3 * (cte."avg_avgrating" - cte."median_rating")::numeric / cte."standard_deviation", 2) as "skewness"
from cte
;
	
--Calculate the relative frequency distribution of movies ratings (here is a refresher on relative frequency )

with cnt as(
	select count(*)::numeric as total
	from xf_title_ratings tr
	), 
	freq as (
	select "averageRating" as rating,
	count("averageRating")::numeric as frequency
	from xf_title_ratings 
	group by rating
	)	
select freq."rating",
	freq."frequency" / "total" as relative_frequency 
from freq
cross join cnt as "total"
group by "rating", relative_frequency
order by "rating"
;

--I am unsure why the above code is not functioning properly as the below code shows that my freq cross join total works 
select * from freq
cross join cnt as "total";


--Carry out the Shapiro-Wilk Test described here

--Q2: What are the first and last names of all the actors cast in the movie 'Lord of war'? What roles did they play in that production?

select nb."primaryName" as "actor", tp."characters" as "role"
from xf_title_basics tb
left join xf_title_principals tp on tb."tconst" = tp."tconst"
left join xf_name_basics nb on nb."nconst" = tp."nconst"
where tb."primaryTitle" = 'Lord of War' and tp."category" in ('actor', 'actress') --assumption that "actors" in the question refers to both actors and actresses
;

--Q3: What are the highest-rated Comedy shorts between 2000 and 2010?

select "titleType" from xf_title_basics; --there is no 'comedy short'

select "primaryTitle" as "title", unnest("genres") as "genres" --testing using the unnest function
	from xf_title_basics;

with cte as (select "tconst", "primaryTitle" as "title", "titleType", "startyear", unnest("genres") as "genre"
	from xf_title_basics)
select cte."title" as "title", tr."averageRating" as "rating"
from cte 
full outer join xf_title_ratings tr on cte."tconst" = tr."tconst"
where cte."titleType" = 'short' and cte."genre" = 'Comedy'
	and cte."startyear" >= 2000 and cte."startyear" <= 2010
	and tr."averageRating" is not null
order by "rating" desc
;	

select tb."primaryTitle" as "title", tr."averageRating" as "rating"
from xf_title_basics tb
full outer join xf_title_ratings tr on tb."tconst" = tr."tconst"
cross join unnest(tb."genres") as "genre"
where tb."titleType" = 'short' and "genre" = 'Comedy'
	and tb."startyear" >= 2000 and tb."startyear" <= 2010
	and tr."averageRating" is not null
order by "rating" desc
;	

--checking if the above 2 codes are equal 
with cte as (select "tconst", "primaryTitle" as "title", "titleType", "startyear", unnest("genres") as "genre"
	from xf_title_basics)
select count(*) as cnt, tr."averageRating" as "rating"
from cte 
full outer join xf_title_ratings tr on cte."tconst" = tr."tconst"
where cte."titleType" = 'short' and cte."genre" = 'Comedy'
	and cte."startyear" >= 2000 and cte."startyear" <= 2010
	and tr."averageRating" is not null
group by "rating"
order by "rating" desc
;	

select count(*) as cnt, tr."averageRating" as "rating"
from xf_title_basics tb
full outer join xf_title_ratings tr on tb."tconst" = tr."tconst"
cross join unnest(tb."genres") as "genre"
where tb."titleType" = 'short' and "genre" = 'Comedy'
	and tb."startyear" >= 2000 and tb."startyear" <= 2010
	and tr."averageRating" is not null
group by "rating"
order by "rating" desc
;

--a third (and possible better) option
select xtb."primaryTitle" as "title", xtr."averageRating" as "rating"
from xf_title_basics xtb 
left join xf_title_ratings xtr on xtb."tconst" = xtr."tconst"
where xtb."titleType" = 'short' and xtb."genres" @> '{Comedy}'
	and xtb."startyear" >= 2000 and xtb."startyear" <= 2010
	and xtr."averageRating" is not null
order by "rating" desc;

--Q4: What is the average number of votes for movies rated between 0-1, 1-2, 2-3, 3-4, 4-5?

select case when tr."averageRating" >= 0 and tr."averageRating" < 1 then '0-1'
		when tr."averageRating" >= 1 and tr."averageRating" < 2 then '1-2'
		when tr."averageRating" >= 2 and tr."averageRating" < 3 then '2-3'
		when tr."averageRating" >= 3 and tr."averageRating" < 4 then '3-4'
		when tr."averageRating" >= 4 and tr."averageRating" < 5 then '4-5'
	end as rating_interval,
	round(avg(tr."numVotes"), 0) as avg_votes
from xf_title_basics tb
left join xf_title_ratings tr on tb."tconst" = tr."tconst"
where tb."titleType" = 'movie'
group by rating_interval
order by rating_interval
;
