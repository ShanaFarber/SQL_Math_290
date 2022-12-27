/* Exercise 1 */

--Step 2
create view imdb.public.etl_title_episode_v
as
	select 
	 tb."tconst"
	,tb."parentTconst"
	,cast(tb."seasonNumber" as integer) as seasonNumber
	,cast(tb."episodeNumber" as integer) as episodeNumber
from imdb.public.title_episode tb;

--Step 3
create table imdb.public.xf_title_episode
as
select * from imdb.public.etl_title_episode_v;

--Step 4
ALTER TABLE imdb.public.xf_title_episode ADD PRIMARY KEY ("tconst");

