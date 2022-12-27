/* Exercise 1 */

--Step 2
create view imdb.public.etl_title_crew_v
as
	select 
	 tb."tconst"
	,regexp_split_to_array(tb."directors",',')::varchar[] as "directors"
	,regexp_split_to_array(tb."writers",',')::varchar[] as "writers"
from imdb.public.title_crew tb;

--Step 3
create table imdb.public.xf_title_crew
as
select * from imdb.public.etl_title_crew_v;

--Step 4
ALTER TABLE imdb.public.xf_title_crew ADD PRIMARY KEY ("tconst");

