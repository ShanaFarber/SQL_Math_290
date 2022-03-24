/* Exercise 2 */

/* Part 1*/
select "VendorID", date_trunc('hour', tpep_dropoff_datetime) as hr, count(*) as cnt   --counts the trips per hr per VendorID
  from taxi_fares
  where extract (year from tpep_dropoff_datetime) = 2018    --only counts where year = 2018
  /* where date_part('year', tpep_dropoff_datetime) = 2018 */   --also works here
  group by "VendorID", hr

  /* Part 2 */
with hourly_trip as(
  select "VendorID", date_trunc('hour', tpep_dropoff_datetime) as hr, count(*) as cnt
  from taxi_fares
  where extract (year from tpep_dropoff_datetime) = 2018
  group by "VendorID", hr
)
SELECT hourly_trip."VendorID" as vendor_id, date_trunc('day', hourly_trip.hr) as dropoff_date, 
  	min(hourly_trip.cnt) as min_trip_cnt, 
  	avg(hourly_trip.cnt) as mean_cnt_trip, 
  	max(hourly_trip.cnt) as max_cnt_trip, 
  	percentile_cont(0.5) within group (order by hourly_trip.cnt) as median 
  from hourly_trip
  group by hourly_trip."VendorID", date_trunc('day', hourly_trip.hr)
  order by dropoff_date , vendor_id;

/* Part 3 */ 
select 
	"VendorID" as vendor_id,
	min("Trip_distance") as min_trip_dist,
	max("Trip_distance") as max_trip_dist,
	avg("Trip_distance") as mean_trip_distance,
	percentile_cont(0.5) within group (order by "Trip_distance") as median_dist
from taxi_fares 
where extract (year from tpep_dropoff_datetime) = 2018 
	and date_part('hour', tpep_dropoff_datetime) = '5'
group by vendor_id;

/* Part 4 */

--day in 2018 with the least amount of trips
select date_trunc('day', tpep_dropoff_datetime) as least_day,
	count(*) as cnt
from taxi_fares
where extract (year from tpep_dropoff_datetime) = 2018  --filters only for where year is 2018
group by date_trunc('day', tpep_dropoff_datetime)   --groups the output by day so that the count function will count for each day 
order by cnt asc    --orders the count in ascending order so that the first row will be the lowest amount
limit 1;    --only outputs the first row which is the day with the least trips

--day in 2018 with most amount of trips
select date_trunc('day', tpep_dropoff_datetime) as most_day,
	count(*) as cnt
from taxi_fares
where extract (year from tpep_dropoff_datetime) = 2018
group by date_trunc('day', tpep_dropoff_datetime)
order by cnt desc    --orders the count in descending order so the first row will be the largest amount 
limit 1;

--using a UNION to combine the two to output the least_day and most_day in the same table
(select 'least_day' as type_day,
	date_trunc('day', tpep_dropoff_datetime) as the_day,
	count(*) as cnt
from taxi_fares
where extract (year from tpep_dropoff_datetime) = 2018
group by date_trunc('day', tpep_dropoff_datetime)
order by cnt asc
limit 1)
	union
(select 'most_day' as type_day,
	date_trunc('day', tpep_dropoff_datetime) as the_day,
	count(*) as cnt
from taxi_fares
where extract (year from tpep_dropoff_datetime) = 2018
group by date_trunc('day', tpep_dropoff_datetime)
order by cnt desc
limit 1);

/* Exercise 3 */

--average tip percentage
select (round(avg("Tip_amount" / "Total_amount") * 100, 2) || '%') as avg_tip_percent
	from taxi_fares
	where "Total_amount" > 0 and extract (year from tpep_dropoff_datetime) = 2018;

/*
select avg("Tip_amount" / "Total_amount") as avg_tip_percent 
	from taxi_fares
	where "Total_amount" > 0;
*/

--average tip percentage by dropoff hour
select extract (hour from tpep_dropoff_datetime) as dropoff_hr,
	(round(avg ("Tip_amount" / "Total_amount") * 100, 2) || '%') as avg_tip_percent
from taxi_fares
where "Total_amount" > 0 and extract (year from tpep_dropoff_datetime) = 2018
group by dropoff_hr;

/*
select extract (hour from tpep_dropoff_datetime) as dropoff_hr, --extracts the hour from the timestamp
	avg ("Tip_amount" / "Total_amount") as avg_tip_percent
from taxi_fares
where "Total_amount" > 0 and extract (year from tpep_dropoff_datetime) = 2018
group by dropoff_hr;    --groups the output by the hour extracted from the timestamp
*/

create view daily_tip_percentage_by_distance as (
	select date_trunc('day', tpep_dropoff_datetime) as the_date,
		case when "Trip_distance" >= 0 and "Trip_distance" < 1 then '0-1 mile'
				when "Trip_distance" >= 1 and "Trip_distance" < 2 then '1-2 mile'
				when "Trip_distance" >= 2 and "Trip_distance" < 3 then '2-3 mile'
				when "Trip_distance" >= 3 and "Trip_distance" < 4 then '3-4 mile'
				when "Trip_distance" >= 4 and "Trip_distance" < 5 then '4-5 mile'
				when "Trip_distance" >= 5 then '5+ mile'
		end as trip_mileage_band,
		(round(avg("Tip_amount"/"Total_amount") * 100, 2) || '%') as tip_percentage
	from taxi_fares
	where extract (year from tpep_dropoff_datetime) = 2018 and "Total_amount" > 0 --account for division by zero error
	group by the_date, trip_mileage_band);

    select * from daily_tip_percentage_by_distance; --outputs the view
