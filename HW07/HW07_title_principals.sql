/* Exercise 1 */

--Step 2
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

--Step 3
create table imdb.public.xf_title_principals
as
select * from imdb.public.etl_title_principals_v;

--Step 4
ALTER TABLE imdb.public.xf_title_principals ADD PRIMARY KEY ("ordering", "tconst");


