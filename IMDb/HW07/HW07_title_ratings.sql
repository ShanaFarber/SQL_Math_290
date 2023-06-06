/* Exercise 1 */

--Step 2
/*
create view imdb.public.etl_title_ratings_v
as
	select 
	 tb."tconst"
	,cast(tb."averageRatings" as integer) as "averageRating"
	,cast(tb."numVotes" as integer) as "numVotes"
from imdb.public.title_ratings tb;
*/

drop view if exists imdb.public.etl_title_ratings_v
create view imdb.public.etl_title_ratings_v
as
	select 
	 tb."tconst"
	,cast(tb."averageRatings" as numeric) as "averageRating"
	,cast(tb."numVotes" as integer) as "numVotes"
from imdb.public.title_ratings tb;

--Step 3
create table imdb.public.xf_title_ratings
as
select * from imdb.public.etl_title_ratings_v;

--Step 4
ALTER TABLE imdb.public.xf_title_ratings ADD PRIMARY KEY ("tconst");


