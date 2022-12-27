/* Exercise 1 */

--Step 1
select table_name, column_name, data_type 
from information_schema.columns
where  table_schema = 'public' and table_name = 'title_basics';

--Step 2
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

--Step 3
create table imdb.public.xf_title_basics
as
select * from imdb.public.etl_title_basics_v;

--Step 4
ALTER TABLE imdb.public.xf_title_basics ADD PRIMARY KEY ("tconst");

