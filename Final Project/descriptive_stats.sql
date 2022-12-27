--changed the name
with stats as(
select
	 count(u.user_age) as total_count --167,307
   ,min(u.user_age)--1
   ,percentile_cont(0.25) within group (order by u.user_age  asc) as p25--24
   ,percentile_cont(0.50) within group (order by u.user_age  asc) as median--32
   ,avg(u.user_age) as mean--34.651
   ,percentile_cont(0.75) within group (order by u.user_age  asc) as p75--44
   ,max(u.user_age)--99
   ,stddev(u.user_age)--13.7195
   ,variance(u.user_age) --188.22
from book_recommendation.public.users u
where u.user_age  >0
and u.user_age <100
and u.user_age is not null
)--skewness
select
  (3 * (mean - median))/stddev as pearson_coeff_skew
from stats;--0.5798113190126404


with stats as(
select
	 count(bi.publication_year) as total_count --266,670
   ,min(bi.publication_year)--1,376
   ,percentile_cont(0.25) within group (order by bi.publication_year  asc) as p25--1989
   ,percentile_cont(0.50) within group (order by bi.publication_year  asc) as median--1996
   ,avg(bi.publication_year) as mean--1993.685
   ,percentile_cont(0.75) within group (order by bi.publication_year  asc) as p75--2000
   ,max(bi.publication_year)--2004
   ,stddev(bi.publication_year)--8.3196
   ,variance(bi.publication_year) --69.21
from book_recommendation.public.books bi
where bi.publication_year<2005
and bi.publication_year != 0
)--skewness
select
  (3 * (mean - median))/stddev as pearson_coeff_skew
from stats;-- (-0.834749786956116)