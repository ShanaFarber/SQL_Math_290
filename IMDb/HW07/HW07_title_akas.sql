/* Exercise 1 */

--Step 2
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

--Step 3
create table imdb.public.xf_title_akas
as
select * from imdb.public.etl_title_akas_v;

--Step 4
ALTER TABLE imdb.public.xf_title_akas ADD PRIMARY KEY ("titleID", "ordering");

