create database book_recommendation

--ratings table
create table book_recommendation.public.ratings(
user_id numeric,
ISBN varchar,
rating numeric
);

copy ratings (
user_id, ISBN, rating
)
from 'C:\Users\eliez\Downloads\book_recommendation\Ratings.csv'
delimiter ','
csv header;

-- users table
create table book_recommendation.public.users (
"user_id" numeric ,
"user_location" varchar,
"user_age" numeric
);
copy users ( "user_id", "user_location", "user_age"
)
from 'C:\Users\eliez\Downloads\book_recommendation\Users.csv'
delimiter ','
csv header;



--books table
---there are 3 columns not needed so created temp table
create temporary table t(
ISBN varchar,
"title" varchar,
"author" varchar,
"publication_year" varchar ,
"publisher"  varchar,
"imagea" varchar,
"imageb" varchar,
"imagec" varchar
);
--imported all the data
copy t(ISBN, "title", "author", "publication_year", "publisher", "imagea", "imageb", "imagec")
from 'C:\Users\eliez\Downloads\Books.csv\Books.csv'
delimiter ','
csv header;
--created the real table
create table book_recommendation.public.bookst(
ISBN varchar,
"title" varchar,
"author" varchar,
"publication_year" varchar ,
"publisher" varchar
);
---then inserted into the real table from the temp table
insert into bookst(ISBN, "title", "author", "publication_year", "publisher")
select ISBN, "title", "author", "publication_year", "publisher"
from t;
---before changing the year to int, there are a few rows that are problematic
select * from bookst where publication_year= 'DK Publishing Inc';
---which by me returned a few rows, obviously a mistake

update bookst set title =  'Creating The X-men, How It All Began' where title = 'DK Readers: Creating the X-Men, How It All Began (Level 4: Proficient Readers)\";Michael Teitelbaum"';
update bookst set title = 'Creating the X-Men, How Comic Books Come to Life' where title = 'DK Readers: Creating the X-Men, How Comic Books Come to Life (Level 4: Proficient Readers)\";James Buckley"';
update bookst set author  = 'Michael Teitelbaum' where title =  'Creating The X-men, How It All Began';
update bookst set author = 'James Buckley' where title = 'Creating the X-Men, How Comic Books Come to Life';
update bookst set publisher = 'DK Publishing Inc' where publication_year = 'DK Publishing Inc';
update bookst set publication_year = '2000' where publication_year ='DK Publishing Inc';
--delete from bookst where publication_year ='DK Publishing Inc';
--also
select * from bookst where publication_year = 'Gallimard';
update bookst set title = 'Peuple du ciel, suivi de'where publication_year = 'Gallimard';
update bookst set author = 'Jean-Marie Gustave' where publication_year = 'Gallimard';
update bookst set publisher = 'Gallimard' where publication_year = 'Gallimard'
update bookst set publication_year = '2003' where publication_year = 'Gallimard';
--delete from bookst where publication_year = 'Gallimard';

--now i created a cd view
create or replace  view book_recommendation.public.booksts
as select
b.ISBN,
b.title,
b.author,
cast(b.publication_year as integer) as publication_year,
b.publisher
from bookst b;
--and made a new table from it
create table book_recommendation.public.books
as select * from book_recommendation.public.booksts;


--changing user.user_location to array
alter table users
 alter user_location  type varchar[] using regexp_split_to_array(user_location,',')