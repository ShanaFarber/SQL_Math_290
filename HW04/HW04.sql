/* 17 UNIONed selected statements which output the distinct count in the desired format */
select 'VendorID' as column_name, count(*) as distinct_records
	from(
		select distinct "VendorID" 
		from "2018_Yellow_Taxi_Trip_Data" 
	)as vndr
union
select 'tpep_pickup_datetime', count(*)
	from(
		select distinct "tpep_pickup_datetime" 
		from "taxi_fares" 
	)as pkp
union
select 'tpep_dropoff_datetime', count(*)
	from(
		select distinct "tpep_dropoff_datetime" 
		from "taxi_fares" 
	)as dpf
union
select 'Passenger_count', count(*)
	from(
		select distinct "Passenger_count"
		from "taxi_fares" 
	)as pscnt
union
select 'Trip_distance', count(*)
	from(
		select distinct "Trip_distance" 
		from "taxi_fares" 
	)as tpd
union
select 'PULocationID', count(*)
	from(
		select distinct "PULocationID" 
		from "taxi_fares" 
	)as pulid
union
select 'DOLocationID', count(*)
	from(
		select distinct "DOLocationID" 
		from "taxi_fares" 
	)as dolid
union
select 'RateCodeID', count(*)
	from(
		select distinct "RateCodeID" 
		from "taxi_fares" 
	)as rcid
union
select 'Store_and_fwd_flag', count(*)
	from(
		select distinct "Store_and_fwd_flag" 
		from "taxi_fares" 
	)as sff
union
select 'Payment_type', count(*)
	from(
		select distinct "Payment_type" 
		from "taxi_fares" 
	)as pytp
union
select 'Fare_amount', count(*)
	from(
		select distinct "Fare_amount" 
		from "taxi_fares" 
	)as framt
union
select 'Extra', count(*)
	from(
		select distinct "Extra"
		from "taxi_fares" 
	)as ext
union
select 'MTA_tax', count(*)
	from(
		select distinct "MTA_tax" 
		from "taxi_fares" 
	)as mta
union
select 'improvement_surcharge', count(*)
	from(
		select distinct "Improvement_surcharge" 
		from "taxi_fares" 
	)as imp
union
select 'Tip_amount', count(*)
	from(
		select distinct "Tip_amount" 
		from "taxi_fares" 
	)as tip
union
select 'Tolls_amount', count(*)
	from(
		select distinct "Tolls_amount" 
		from "taxi_fares" 
	)as tolls
union
select 'Total_amount', count(*)
	from(
		select distinct "Total_amount" 
		from "taxi_fares" 
	)as ttl
;

/* Exercise 2 */

select count(*) as distinct_observation_count from (select distinct * from taxi_fares) as sub_query;

/* This returns a count of all of the distinct combinations of rows */

/* Exercise 3 */

/*1*/
select count(*) from taxi_fares where "Passenger_count" = 5;
/*2*/
select count(*) from (select distinct * from taxi_fares) x 
    where "Passenger_count" > 3;
/*3*/
select count(*) from taxi_fares 
    where "tpep_pickup_datetime" between '2018-04-01 00:00:00' and '2018-05-01 00:00:00';
/*4*/
select count(*) from (select distinct * from taxi_fares) x 
    where "tpep_pickup_datetime" between '2018-06-01 00:00:00' and '2018-06-30 23:59:59' 
    and "Tip_amount" >= 5; 
/*5*/
select count(*) from (select distinct * from taxi_fares) x 
    where "tpep_pickup_datetime" between '2018-05-01 00:00:00' and '2018-05-31 23:59:59' 
    and "Passenger_count" > 3 
    and "Tip_amount" between 2 and 5;
/*6*/
select sum("Tip_amount") from taxi_fares;

/* Exercise 4 */

select * from pg_catalog.pg_stat_database;  /* This returns a catalog of databases and their id's */

delete from taxi_fares where "VendorID" = 2;    /* This deletes all the rows in which VendorID is equal to 2 */

select count (*) from taxi_fares where "VendorID" = 2;  /* This counts all the rows in which "VendorID" = 2 */

/* Exercise 5 */

VACUUM FULL;

/* Exercise 6 */

TRUNCATE TABLE taxi_fares;

select * from taxi_fares; /* I used this to check that the TRUNCATE was successful */

copy taxi_fares (
    "VendorID", 
    "tpep_pickup_datetime", 
    "tpep_dropoff_datetime", 
    "Passenger_count", 
    "Trip_distance", 
    "RateCodeID", 
    "Store_and_fwd_flag", 
    "PULocationID", 
    "DOLocationID", 
    "Payment_type", 
    "Fare_amount", 
    "Extra", "MTA_tax", 
    "Improvement_surcharge", 
    "Tip_amount", 
    "Tolls_amount", 
    "Total_amount"
    )
from '/Library/PostgreSQL/14/2018_Yellow_Taxi_Trip_Data (1).csv' delimiter ',' csv header;

/* I used this COPY function to re-import the data into the taxi_fares table */
