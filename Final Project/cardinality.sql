/*books*/

select count (bi.ISBN) as "ISBN" --271,360
,count (bi.title) as title --271,360
,count (bi.author) as author --271,359
,count (bi.publication_year) as "year" --271,360
,count (bi.publisher) as publisher --271,358
from book_recommendation.public.books bi;

select count (*) from book_recommendation.public.books bi; --271,360

select count (distinct bi.ISBN) as ISBN --271,360
,count (distinct bi.title) as title --242,131
,count (distinct bi.author) as author --102,022
,count (distinct bi.publication_year) as "year" --117
,count (distinct bi.publisher)as publisher --16,803
from book_recommendation.public.books bi;

/*ratings*/

select count(r.user_id) as user_id --1,149,780
,count (r.ISBN) as "ISBN" --1,149,780
,count (r.rating) as rating --1,149,780
from book_recommendation.public.ratings r;

select count (*) from book_recommendation.public.ratings r --1,149,780

select count(*) from (select distinct * from ratings) r; --1,149,780

select count (distinct r.user_id) as user_id --105,283
,count (distinct r.ISBN) as "ISBN" --340,556
,count (distinct r.rating) as rating --11
from book_recommendation.public.ratings r;

with cte as
(SELECT distinct r.user_id , r.isbn
FROM book_recommendation.public.ratings r)
SELECT COUNT(*) FROM cte; --1,149,780

/*users*/

select count(u.user_id) as user_id --278,858
,count(u.user_location) as "location" --278,858
,count(u.user_age) as age--168,096
from book_recommendation.public.users u;

select count (*) from book_recommendation.public.users u --278,858

select count (distinct u.user_id) as user_id --278,858
,count (distinct u.user_location) as "location" --57,339
,count (distinct u.user_age) as age  --165
from book_recommendation.public.users u;

select case when count(bi.ISBN) = count(distinct bi.ISBN) then true
	else false
	end  is_unique
from book_recommendation.public.books bi; --true so is unique

select case when count(r.ISBN) = count(distinct r.ISBN) then true
	else false
	end  is_unique
from book_recommendation.public.ratings r; --false

select case when count(r.user_id) = count(distinct r.user_id) then true
	else false
	end  is_unique
from book_recommendation.public.ratings r; --false

select case when count(u.user_id) = count(distinct u.user_id) then true
	else false
	end  is_unique
from book_recommendation.public.users u; --true

/*between tables cardinalities*/

select count(*) from book_recommendation.public.books bi
left outer join book_recommendation.public.ratings r
on bi.ISBN = r.ISBN ; --396,563

select count(*) from book_recommendation.public.books bi
left outer join book_recommendation.public.ratings r
on bi.ISBN = r.ISBN
where r.ISBN is null;--199,734 are in a that are not in b

select count(*) from book_recommendation.public.books b
right outer join book_recommendation.public.ratings r
on b.isbn  = b.isbn; ---1,149,780

select count(*) from book_recommendation.public.books b
right outer join book_recommendation.public.ratings r
on b.isbn  = r.isbn
where b.isbn is null; --952,951

select count(*) from book_recommendation.public.books bi
inner join book_recommendation.public.ratings r
on bi.isbn  = r.isbn; --196,826



select count(*) from book_recommendation.public.users u
left outer join book_recommendation.public.ratings r
on u.user_id = r.user_id; --1,323,355

select count(*) from book_recommendation.public.users u
left outer join book_recommendation.public.ratings r
on u.user_id = r.user_id
where r.user_id is null; --173,575

select count(*) from book_recommendation.public.users u
right outer join book_recommendation.public.ratings r
on u.user_id = r.user_id; --1,149,780

select count(*) from book_recommendation.public.users u
right outer join book_recommendation.public.ratings r
on u.user_id = r.user_id
where u.user_id is null;--0

select count(*) from book_recommendation.public.users u
inner join book_recommendation.public.ratings r
on u.user_id = r.user_id;--1,149,780