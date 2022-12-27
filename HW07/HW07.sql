/* Exercise 1 */

/* Step 1 */
    
select table_name, column_name, data_type 
from information_schema.columns
where  table_schema = 'public' and table_name = 'title_basics';

/* Step 2-4 for each table in respective SQL files*/

/* Exercise 2 */

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