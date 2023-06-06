/* Exercise 1 */

--Step 2
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

--Step 3
create table imdb.public.xf_name_basics
as
select * from imdb.public.etl_name_basics_v;

--Step 4
ALTER TABLE imdb.public.xf_name_basics ADD PRIMARY KEY ("nconst");

