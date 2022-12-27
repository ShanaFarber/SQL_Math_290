/* Exercise 2 */

/* Part 2 */ 

create database imdb;

/* Part 3 */

--title_akas table
create table imdb.public.title_akas (
"titleID" varchar,
"ordering" varchar,
"title" varchar,
"region" varchar,
"language" varchar,
"types" varchar,
"attributes" varchar,
"isOriginalTitle" varchar
);

--title_basics table
create table imdb.public.title_basics (
"tconst" varchar,
"titleType" varchar,
"primaryTitle" varchar,
"originalTitle" varchar,
"isAdult" varchar,
"startYear" varchar,
"endYear" varchar,
"runtimeMinutes" varchar,
"genres" varchar
);

--title_crew table
create table imdb.public.title_crew (
"tconst" varchar,
"parentTconst" varchar,
"seasonNumber" varchar,
"episodeNumber" varchar
);

--title_episode table
create table imdb.public.title_episode (
"tconst" varchar,
"directors" varchar,
"writers" varchar
);

--title_principals table
create table imdb.public.title_principals (
"tconst" varchar,
"ordering" varchar,
"nconst" varchar,
"category" varchar,
"job" varchar,
"characters" varchar
);

--title_ratings table
create table imdb.public.title_ratings (
"tconst" varchar,
"averageRatings" varchar,
"numVotes" varchar
);

--name_basics table
create table imdb.public.name_basics (
"nconst" varchar,
"primaryName" varchar,
"birthYear" varchar,
"deathYear" varchar,
"primaryProfession" varchar,
"knownForTitles" varchar
);

/* Part 4 */

copy imdb.public.title_akas from '/Users/shoshanafarber/Downloads/title.akas.tsv' delimiter E'\t';
copy imdb.public.title_basics from '/Users/shoshanafarber/Downloads/title.basics.tsv' delimiter E'\t';
copy imdb.public.title_crew from '/Users/shoshanafarber/Downloads/title.crew 2.tsv' delimiter E'\t';
copy imdb.public.title_episode from '/Users/shoshanafarber/Downloads/title.episode 2.tsv' delimiter E'\t';
copy imdb.public.title_principals from '/Users/shoshanafarber/Downloads/title.principals.tsv' delimiter E'\t';
copy imdb.public.title_ratings from '/Users/shoshanafarber/Downloads/title.ratings 2.tsv' delimiter E'\t';
copy imdb.public.name_basics from '/Users/shoshanafarber/Downloads/name.basics.tsv' delimiter E'\t';

/* Part 5 */

--use a select statement to take a look at your tables
select * from title_akas;
select * from title_basics;
select * from title_crew;
select * from title_principals;
select * from title_episode;
select * from title_ratings;
select * from name_basics;

--use DELETE to delete unintended row

--title_akas
delete from title_akas where "titleID" = 'titleId';
--title_basics
delete from title_basics where "tconst" = 'tconst';
--title_crew
delete from title_crew where "tconst" = 'tconst';
--title_episode
delete from title_episode where "tconst" = 'tconst';
--title_principals
delete from title_principals where "tconst" = 'tconst';
--title_ratings
delete from title_ratings where "tconst" = 'tconst';
--name_basics
delete from name_basics where "nconst" = 'nconst';

/* Part 6 */

--title_akas
COPY title_akas("titleID", "ordering", "title", "region", "language", "types", "attributes", "isOriginalTitle") 
TO '/Users/shoshanafarber/Downloads/title_akas.csv' DELIMITER ',' CSV HEADER;
--title_basics
COPY title_basics("tconst", "titleType", "primaryTitle", "originalTitle", "isAdult", "startYear", "endYear", "runtimeMinutes", "genres") 
TO '/Users/shoshanafarber/Downloads/title_basics.csv' DELIMITER ',' CSV HEADER;
--title_crew
COPY title_crew("tconst", "directors", "writers") 
TO '/Users/shoshanafarber/Downloads/title_crew.csv' DELIMITER ',' CSV HEADER;
--title_episode
COPY title_episode("tconst", "parentTconst", "seasonNumber", "episodeNumber") 
TO '/Users/shoshanafarber/Downloads/title_episode.csv' DELIMITER ',' CSV HEADER;
--title_principals
COPY title_principals("tconst", "ordering", "nconst", "category", "job", "characters")
TO '/Users/shoshanafarber/Downloads/title_principals.csv' DELIMITER ',' CSV HEADER;
--title_ratings
COPY title_ratings("tconst", "averageRatings", "numVotes") 
TO '/Users/shoshanafarber/Downloads/title_ratings.csv' DELIMITER ',' CSV HEADER;
--name_basics
COPY name_basics("nconst", "primaryName", "birthYear", "deathYear", "primaryProfession", "knownForTitles") 
TO '/Users/shoshanafarber/Downloads/name_basics.csv' DELIMITER ',' CSV HEADER;

/* Exercise 3 */

--counting to see how many rows are in each table
select 'title_akas' as table_name, count(*) as cnt from title_akas 
	union
select 'title_basics' as table_name, count(*) as cnt from title_basics 
	union
select 'title_crew' as table_name, count(*) as cnt from title_crew 
	union
select 'title_episode' as table_name, count(*) as cnt from title_episode
	union
select 'title_principals' as table_name, count(*) as cnt from title_principals
	union
select 'title_ratings' as table_name, count(*) as cnt from title_ratings 
	union
select 'name_basics' as table_name, count(*) as cnt from name_basics
order by table_name;

--title_akas
select
	count(distinct "titleID") as titleIdCnt,
	count(distinct "ordering") as orderingCnt,
	count(distinct "title") as titleCnt,
	count(distinct "region") as regionCnt,
	count(distinct "language") as languageCnt,
	count(distinct "types") as typesCnt,
	count(distinct "attributes") as attributesCnt,
	count(distinct "isOriginalTitle") as originalTitleCnt
from title_akas;

--title_basics
select 
	count(distinct "tconst") as tconstCnt,
	count(distinct "titleType") as titleTypeCnt,
	count(distinct "primaryTitle") as primaryTitleCnt,
	count(distinct "originalTitle") as originalTitleCnt,
	count(distinct "isAdult") as isAdultCnt,
	count(distinct "startYear") as startYearCnt,
	count(distinct "endYear") as endYearCnt,
	count(distinct "runtimeMinutes") as runtimeMinutesCnt,
	count(distinct "genres") as genresCnt
from title_basics;

--title_crew
select 
	count(distinct "tconst") as tconstCnt,
	count(distinct "directors") as directorsCnt,
	count(distinct "writers") as writersCnt
from title_crew;

--title_episode
select 
	count(distinct "tconst") as tconstCnt,
	count(distinct "parentTconst") as parentTconstCnt,
	count(distinct "seasonNumber") as seasonNumberCnt,
	count(distinct "episodeNumber") as episodeNumberCnt
from title_episode;

--title_principals
select 
	count(distinct "tconst") as tconstCnt,
	count(distinct "ordering") as orderingCnt,
	count(distinct "nconst") as nconstCnt,
	count(distinct "category") as categoryCnt,
	count(distinct "job") as jobCnt,
	count(distinct "characters") as charactersCnt
from title_principals;

--title_ratings
select 
	count(distinct "tconst") as tconstCnt,
	count(distinct "averageRatings") as averageRatingsCnt,
	count(distinct "numVotes") as numVotesCnt
from title_ratings;

--name_basics
select 
	count(distinct "nconst") as nconstCnt,
	count(distinct "primaryName") as primaryNameCnt,
	count(distinct "birthYear") as birthYearCnt,
	count(distinct "deathYear") as deathYearCnt,
	count(distinct "primaryProfession") as primaryProfessionCnt,
	count(distinct "knownForTitles") as knownForTitlesCnt
from name_basics;

--title_akas composite key check
with cte as (
	select distinct "titleID", "ordering"   --using CTE
	from title_akas)
select count(*) from cte;

select count(*) from (select distinct "titleID", "ordering" from title_akas) x;    --using subquery

--title_principals composite key check
with cte as (
	select distinct "tconst", "ordering"    --using CTE
	from title_principals)
select count(*) from cte;

select count(*) from (select distinct "tconst", "ordering" from title_principals) x;    --using subquery

/* adding pirmary keys to each relation */

--title_akas
ALTER TABLE imdb.public.title_akas ADD PRIMARY KEY ("titleID", "ordering");
--title_basics
ALTER TABLE imdb.public.title_basics ADD PRIMARY KEY ("tconst");
--title_crew
ALTER TABLE imdb.public.title_crew ADD PRIMARY KEY ("tconst");
--title_episode
ALTER TABLE imdb.public.title_episode ADD PRIMARY KEY ("tconst");
--title_principals
ALTER TABLE imdb.public.title_principals ADD PRIMARY KEY ("ordering", "tconst");
--title_ratings
ALTER TABLE imdb.public.title_ratings ADD PRIMARY KEY ("tconst");
--name_basics
ALTER TABLE imdb.public.name_basics ADD PRIMARY KEY ("nconst");

/* Exercise 4 */

--step 1: count rows of tconst present in title_ratings not in title_basics
with cnt as (
	select "tconst" from imdb.public.title_ratings 
		except 
	select "tconst" from imdb.public.title_basics
)
select count(*) from cnt;

--step 2: count rows of tconst present in title_basics not in title_ratings
with cnt as (
	select "tconst" from imdb.public.title_basics 
		except 
	select "tconst" from imdb.public.title_ratings
)
select count(*) from cnt;

--step 3: count intersection
with cnt as (
	select "tconst" from imdb.public.title_ratings 
		intersect
	select "tconst" from imdb.public.title_basics
)
select count(*) from cnt;

--step 5: attempt to add foreign key relationship
alter table imdb.public.title_ratings add constraint "fk_tcosnt" foreign key ("tconst") references title_basics("tconst");
alter table imdb.public.title_basics add constraint "fk_tcosnt" foreign key ("tconst") references title_ratings("tconst");
