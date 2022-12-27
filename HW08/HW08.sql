--Q1: What is the total runtime of all movies in the IMDB database where Nicolas Cage appeared as an actor?

select "titleType" from xf_title_basics; --'movie'

select sum(tb."runtimeminutes") as totalRuntime
from xf_title_principals tp
full outer join xf_name_basics nb 
on tp."nconst" = nb."nconst"
full outer join xf_title_basics tb 
on tp."tconst" = tb."tconst"
where tb."titleType" = 'movie' 
	and nb."primaryName" = 'Nicolas Cage' 
	and tp."category" = 'actor'
;

--Q2: Which actor had the most number of titles in 2012?

select nb."primaryName" as "actor",
	count(*) as cnt
from xf_title_principals tp
full outer join xf_name_basics nb 
on tp."nconst" = nb."nconst"
full outer join xf_title_basics tb 
on tp."tconst" = tb."tconst"
where tb."startyear" = 2012 and tp."category" = 'actor'
group by nb."primaryName"
order by cnt desc 
limit 1
;

--Q3: What Nicolas Cage movie received the highest average rating?

select tb."primaryTitle" as movie_name,
	tr."averageRating" as highest_rating
from xf_title_principals tp
full outer join xf_name_basics nb 
on tp."nconst" = nb."nconst"
full outer join xf_title_ratings tr
on tp."tconst" = tr."tconst"
full outer join xf_title_basics tb 
on tp."tconst" = tb."tconst"
where tb."titleType" = 'movie' 
	and nb."primaryName" = 'Nicolas Cage' 
	and tp."category" = 'actor'
	and tr."averageRating" is not null
order by highest_rating desc 
limit 1
;

--Q4: Which short movie received the highest average rating in 2009?

select "titleType" from xf_title_basics; --'short'

select tb."primaryTitle" as movie_name,
	tr."averageRating" as highest_rating
from xf_title_principals tp
full outer join xf_name_basics nb 
on tp."nconst" = nb."nconst"
full outer join xf_title_ratings tr
on tp."tconst" = tr."tconst"
full outer join xf_title_basics tb 
on tp."tconst" = tb."tconst"
where tb."titleType" = 'short' 
	and tb."startyear" = 2009
	and tr."averageRating" is not null
order by highest_rating desc 
limit 1
;

--Q5: Return the top 10 actors with most movies where the runtime is between 45 and 60 minutes and the start year is between 2000 and 2010?

select nb."primaryName" as "actor",
	count(*) as cnt
from xf_title_principals tp
full outer join xf_name_basics nb 
on tp."nconst" = nb."nconst"
full outer join xf_title_basics tb 
on tp."tconst" = tb."tconst"
where tb."runtimeminutes" >= 45 and tb."runtimeminutes" <= 60
	and tb."startyear" >= 2000 and tb."startyear" <= 2010 
	and tp."category" = 'actor'
group by nb."primaryName"
order by cnt desc 
limit 10
;

--Q6: What are the top 10 highly rated movies with only three words in their titles?

select tb."primaryTitle" as movie,
	tr."averageRating" as rating
from xf_title_basics tb 
full outer join xf_title_ratings tr
on tb."tconst" = tr."tconst"
where tb."titleType" = 'movie' 
	and (length(tb."primaryTitle") - length(replace(tb."primaryTitle", ' ', ''))) = 2 --returns the amount of spaces in between words
	--can also use: array_length(regexp_split_to_array("primaryTitle", ' '), 1) = 3
    and tr."averageRating" is not null
order by rating desc 
limit 10
;

--Q7: Extra credit: Are three-word movie titles more popular than two-word titles?

select "averageRating", "numVotes" from xf_title_ratings;

select array_length(regexp_split_to_array(tb."primaryTitle", ' '), 1) as "titleLength",
	sum(tr."numVotes") as "total_numVotes",
	(round(avg(tr."averageRating"), 1)) as avg_rating
from xf_title_basics tb 
full outer join xf_title_ratings tr
on tb."tconst" = tr."tconst"
where tb."titleType" = 'movie' 
	and (length(tb."primaryTitle") - length(replace(tb."primaryTitle", ' ', ''))) = 1
	or (length(tb."primaryTitle") - length(replace(tb."primaryTitle", ' ', ''))) = 2
	and tr."averageRating" is not null
group by "titleLength"
;

--Q8: Extra credit: Does this (see question 7) change over time?

select tb."startyear" as "year",
	array_length(regexp_split_to_array(tb."primaryTitle", ' '), 1) as "titleLength",
	sum(tr."numVotes") as "total_numVotes",
	(round(avg(tr."averageRating"), 1)) as avg_rating
from xf_title_basics tb 
full outer join xf_title_ratings tr
on tb."tconst" = tr."tconst"
where tb."titleType" = 'movie' 
	and (length(tb."primaryTitle") - length(replace(tb."primaryTitle", ' ', ''))) = 1
	or (length(tb."primaryTitle") - length(replace(tb."primaryTitle", ' ', ''))) = 2
	and tr."averageRating" is not null
group by "year", "titleLength"
order by "year"
;

select min("startyear") as minYear, max("startyear") as maxYear from xf_title_basics;

select case when "startyear" >= 1890 and "startyear" < 1900 then '1890s'
		when "startyear" >= 1900 and "startyear" < 1910 then '1900s'
		when "startyear" >= 1910 and "startyear" < 1920 then '1910s'
		when "startyear" >= 1920 and "startyear" < 1930 then '1920s'
		when "startyear" >= 1930 and "startyear" < 1940 then '1930s'
		when "startyear" >= 1940 and "startyear" < 1950 then '1940s'
		when "startyear" >= 1950 and "startyear" < 1960 then '1950s'
		when "startyear" >= 1960 and "startyear" < 1970 then '1960s'
		when "startyear" >= 1970 and "startyear" < 1980 then '1970s'
		when "startyear" >= 1980 and "startyear" < 1990 then '1980s'
		when "startyear" >= 1990 and "startyear" < 2000 then '1990s'
		when "startyear" >= 2000 and "startyear" < 2010 then '2000s'
		when "startyear" >= 2010 and "startyear" < 2020 then '2010s'
		when "startyear" >= 2020 and "startyear" < 2030 then '2020s'
	end as year_interval,
	array_length(regexp_split_to_array(tb."primaryTitle", ' '), 1) as "titleLength",
	sum(tr."numVotes") as "total_numVotes",
	(round(avg(tr."averageRating"), 1)) as avg_rating
from xf_title_basics tb 
full outer join xf_title_ratings tr
on tb."tconst" = tr."tconst"
where tb."titleType" = 'movie' 
	and (length(tb."primaryTitle") - length(replace(tb."primaryTitle", ' ', ''))) = 1
	or (length(tb."primaryTitle") - length(replace(tb."primaryTitle", ' ', ''))) = 2
	and tr."averageRating" is not null
group by year_interval, "titleLength"
order by year_interval
;

--slight update to question 7
select array_length(regexp_split_to_array(tb."primaryTitle", ' '), 1) as "titleLength",
	sum(tr."numVotes") as "total_numVotes",
	(round(avg(tr."averageRating"), 1)) as avg_rating
from xf_title_basics tb 
full outer join xf_title_ratings tr
on tb."tconst" = tr."tconst"
where tb."titleType" = 'movie' 
	and (length(tb."primaryTitle") - length(replace(tb."primaryTitle", ' ', ''))) = 1
	or (length(tb."primaryTitle") - length(replace(tb."primaryTitle", ' ', ''))) = 2
	and "startyear" >= 1890
	and tr."averageRating" is not null
group by "titleLength"
;