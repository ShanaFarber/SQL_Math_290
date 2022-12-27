/* Exercise 1 */

/* Step 1 */
    
select table_name, column_name, data_type 
from information_schema.columns
where  table_schema = 'public' and table_name = 'title_basics';

/* Step 2 */

--title_basics
create view imdb.public.etl_title_basics_v
as
	select 
	 tb."tconst"
	,tb."titleType"
	,tb."primaryTitle"
	,tb."originalTitle"
	,cast(tb."isAdult" as boolean) as isAdult
	,cast(tb."startYear" as integer) as startYear
	,cast(tb."endYear" as integer) as endYear
	,cast(tb."runtimeMinutes" as integer) as runTimeMinutes
	,regexp_split_to_array(tb."genres",',')::varchar[] as genres       
from imdb.public.title_basics tb;

--title_akas
create view imdb.public.etl_title_akas_v
as
	select 
	 tb."titleID"
	,cast(tb."ordering" as integer) as "ordering"
	,tb."title"
	,tb."region"
	,tb."language"
	,tb."types"
	,regexp_split_to_array(tb."attributes",',')::varchar[] as "attributes"
	,cast(tb."isOriginalTitle" as boolean) as isOriginalTitle
from imdb.public.title_akas tb;

--title_crew
create view imdb.public.etl_title_crew_v
as
	select 
	 tb."tconst"
	,regexp_split_to_array(tb."directors",',')::varchar[] as "directors"
	,regexp_split_to_array(tb."writers",',')::varchar[] as "writers"
from imdb.public.title_crew tb;

--title_episode
create view imdb.public.etl_title_episode_v
as
	select 
	 tb."tconst"
	,tb."parentTconst"
	,cast(tb."seasonNumber" as integer) as seasonNumber
	,cast(tb."episodeNumber" as integer) as episodeNumber
from imdb.public.title_episode tb;

--title_principals
create view imdb.public.etl_title_principals_v
as
	select 
	 tb."tconst"
	,cast(tb."ordering" as integer) as "ordering"
	,tb."nconst"
	,tb."category"
	,tb."job"
	,tb."characters"
from imdb.public.title_principals tb;

--title_ratings
create view imdb.public.etl_title_ratings_v
as
	select 
	 tb."tconst"
	,cast(tb."averageRatings" as integer) as "averageRating"
	,cast(tb."numVotes" as integer) as "numVotes"
from imdb.public.title_ratings tb;

--name_basics
create view imdb.public.etl_name_basics_v
as
	select 
	 tb."nconst"
	,tb."primaryName"
	,cast(tb."birthYear" as integer) as "birthYear"
	,cast(tb."deathYear" as integer) as "deathYear"
	,regexp_split_to_array(tb."primaryProfession",',')::varchar[] as "primaryProfession"
	,regexp_split_to_array(tb."knownForTitles",',')::varchar[] as "knownForTitles"
from imdb.public.name_basics tb;

/* Step 3 */

--title_basics
create table imdb.public.xf_title_basics
as
select * from imdb.public.etl_title_basics_v;

--title_akas
create table imdb.public.xf_title_akas
as
select * from imdb.public.etl_title_akas_v;

--title_crew
create table imdb.public.xf_title_crew
as
select * from imdb.public.etl_title_crew_v;

--title_episode
create table imdb.public.xf_title_episode
as
select * from imdb.public.etl_title_episode_v;

--title_principals
create table imdb.public.xf_title_principals
as
select * from imdb.public.etl_title_principals_v;

--title_ratings
create table imdb.public.xf_title_ratings
as
select * from imdb.public.etl_title_ratings_v;

--name_basics
create table imdb.public.xf_name_basics
as
select * from imdb.public.etl_name_basics_v;

/* Step 4 */

--title_akas
ALTER TABLE imdb.public.xf_title_akas ADD PRIMARY KEY ("titleID", "ordering");
--title_basics
ALTER TABLE imdb.public.xf_title_basics ADD PRIMARY KEY ("tconst");
--title_crew
ALTER TABLE imdb.public.xf_title_crew ADD PRIMARY KEY ("tconst");
--title_episode
ALTER TABLE imdb.public.xf_title_episode ADD PRIMARY KEY ("tconst");
--title_principals
ALTER TABLE imdb.public.xf_title_principals ADD PRIMARY KEY ("ordering", "tconst");
--title_ratings
ALTER TABLE imdb.public.xf_title_ratings ADD PRIMARY KEY ("tconst");
--name_basics
ALTER TABLE imdb.public.xf_name_basics ADD PRIMARY KEY ("nconst");

/* Exercuse 2 */

--Q1: How many movies are in the xf_title_basic table with runtimes between 42 and 77 minutes?
select count(*) as cnt 
from xf_title_basics
where "runtimeminutes" >= 42 and "runtimeminutes" <= 77;

--Q2: What is the average runtime of movies for adults?
select avg("runtimeminutes") as avg_runtime 
from xf_title_basics
where cast("isadult" as integer) = 0;   --casts the boolean as an integer datatype 

--Q3: What number would the query return?
select count(*) from (
    select xtb_a.runtimeminutes, xtb_b.runtimeminutes
    from imdb.public.xf_title_basics xtb_a, imdb.public.xf_title_basics xtb_b
    )x;

select count(*) from xf_title_basics; --row count for xf_title_basics

--Q4a: Calculate the average runtime (rounded to 0 decimals) of movies where the genre's first element is 'Action'. 
select round(avg("runtimeminutes"), 0) as avg_runtime
from xf_title_basics 
where "genres"[1] = 'Action';

--Q4b: How many of all movies in the xf_title_basic has the previously calculated average runtime?
select count(*) as cnt 
from xf_title_basics 
where round("runtimeminutes", 0) = 48;

--Q5: What is the relative frequency of each distinct genre array (combination of genres)?
select "genres" as "genres",
	count("genres") as "relative_frequency" --NOT FINISHED
from xf_title_basics 
group by "genres";

--Q6: (optional): How many distinct genres are used to build the genres array? 
with cte as (
	select unnest("genres") as "all_genres"
	from xf_title_basics
)
select count(distinct "all_genres")
from cte;

/* Exercise 3 */

--Part 1
select *
from title_basics tb
full outer join title_crew tc
on tb."tconst" = tc."tconst"
;

--Part 2
select tb."tconst" as "tconst",
	count(tc."tconst") as cnt
from title_basics tb
full outer join title_crew tc
on tb."tconst" = tc."tconst"
group by tb."tconst";

--Part 3
with cte as (
	select tb."tconst" as "tconst",
		count(tc."tconst") as cnt
	from title_basics tb
	full outer join title_crew tc
	on tb."tconst" = tc."tconst"
	group by tb."tconst"
)
select min(cte."cnt") as min_cnt,
	max(cte."cnt") as max_cnt
from cte;

--Step 4
select tc."tconst" as "tconst",
	count(tb."tconst") as cnt
from title_basics tb
full outer join title_crew tc
on tb."tconst" = tc."tconst"
group by tc."tconst";

with cte as (
	select tc."tconst" as "tconst",
		count(tb."tconst") as cnt
	from title_basics tb
	full outer join title_crew tc
	on tb."tconst" = tc."tconst"
	group by tc."tconst"
)
select min(cte."cnt") as min_cnt,
	max(cte."cnt") as max_cnt
from cte;

/* Exercise 4 */
--title_episode
select te."tconst" as "tconst",
	count(tb."tconst") as cnt
from title_basics tb
full outer join title_episode te
on tb."tconst" = te."tconst"
group by te."tconst";

with cte as (
	select te."tconst" as "tconst",
		count(tb."tconst") as cnt
	from title_basics tb
	full outer join title_episode te
	on tb."tconst" = te."tconst"
	group by te."tconst"
)
select min(cte."cnt") as min_cnt,
	max(cte."cnt") as max_cnt
from cte;

select tb."tconst" as "tconst",
	count(te."tconst") as cnt
from title_basics tb
full outer join title_episode te
on tb."tconst" = te."tconst"
group by tb."tconst";

with cte as (
	select tb."tconst" as "tconst",
		count(te."tconst") as cnt
	from title_basics tb
	full outer join title_episode te
	on tb."tconst" = te."tconst"
	group by tb."tconst"
)
select min(cte."cnt") as min_cnt,
	max(cte."cnt") as max_cnt
from cte;

--title_principals 
select tp."tconst" as "tconst",
	count(tb."tconst") as cnt
from title_basics tb
full outer join title_principals tp
on tb."tconst" = tp."tconst"
group by tp."tconst";

with cte as (
	select tp."tconst" as "tconst",
		count(tb."tconst") as cnt
	from title_basics tb
	full outer join title_principals tp
	on tb."tconst" = tp."tconst"
	group by tp."tconst"
)
select min(cte."cnt") as min_cnt,
	max(cte."cnt") as max_cnt
from cte;

select tb."tconst" as "tconst",
	count(tp."tconst") as cnt
from title_basics tb
full outer join title_principals tp
on tb."tconst" = tp."tconst"
group by tb."tconst";

with cte as (
	select tb."tconst" as "tconst",
		count(tp."tconst") as cnt
	from title_basics tb
	full outer join title_principals tp
	on tb."tconst" = tp."tconst"
	group by tb."tconst"
)
select min(cte."cnt") as min_cnt,
	max(cte."cnt") as max_cnt
from cte;

--title_ratings
select tr."tconst" as "tconst",
	count(tb."tconst") as cnt
from title_basics tb
full outer join title_ratings tr
on tb."tconst" = tr."tconst"
group by tr."tconst";

with cte as (
	select tr."tconst" as "tconst",
		count(tb."tconst") as cnt
	from title_basics tb
	full outer join title_ratings tr
	on tb."tconst" = tr."tconst"
	group by tr."tconst"
)
select min(cte."cnt") as min_cnt,
	max(cte."cnt") as max_cnt
from cte;

select tb."tconst" as "tconst",
	count(tr."tconst") as cnt
from title_basics tb
full outer join title_ratings tr
on tb."tconst" = tr."tconst"
group by tb."tconst";

with cte as (
	select tb."tconst" as "tconst",
		count(tr."tconst") as cnt
	from title_basics tb
	full outer join title_ratings tr
	on tb."tconst" = tr."tconst"
	group by tb."tconst"
)
select min(cte."cnt") as min_cnt,
	max(cte."cnt") as max_cnt
from cte;