-- returns count of distinct values for each column
select 'VendorID' as column_name, count(distinct "VendorID") as distinct_records from "2018_Yellow_Taxi_Trip_Data"
	union
select 'tpep_pickup_datetime' as column_name, count(distinct "tpep_pickup_datetime") as distinct_records from "2018_Yellow_Taxi_Trip_Data"
	union
select 'tpep_dropoff_datetime' as column_name, count(distinct "tpep_dropoff_datetime") as distinct_records from "2018_Yellow_Taxi_Trip_Data"
	union
select 'Passenger_count' as column_name, count(distinct "passenger_count") as distinct_records from "2018_Yellow_Taxi_Trip_Data"
	union
select 'Trip_distance' as column_name, count(distinct "trip_distance") as distinct_records from "2018_Yellow_Taxi_Trip_Data"
	union
select 'PULocationID' as column_name, count(distinct "PULocationID") as distinct_records from "2018_Yellow_Taxi_Trip_Data"
	union
select 'DOLocationID' as column_name, count(distinct "DOLocationID") as distinct_records from "2018_Yellow_Taxi_Trip_Data"
	union
select 'RateCodeID' as column_name, count(distinct "ratecodeID" ) as distinct_records from "2018_Yellow_Taxi_Trip_Data"
	union
select 'Store_and_fwd_flag' as column_name, count(distinct "store_and_fwd_flag") as distinct_records from "2018_Yellow_Taxi_Trip_Data"
	union
select 'Payment_type' as column_name, count(distinct "payment_type") as distinct_records from "2018_Yellow_Taxi_Trip_Data"
	union
select 'Fare_amount' as column_name, count(distinct "fare_amount" ) as distinct_records from "2018_Yellow_Taxi_Trip_Data"
	union
select 'Extra' as column_name, count(distinct "extra")  as distinct_records from "2018_Yellow_Taxi_Trip_Data"
	union
select 'MTA_tax' as column_name, count(distinct "mta_tax") as distinct_records from "2018_Yellow_Taxi_Trip_Data"
	union
select 'improvement_surcharge' as column_name, count(distinct "improvement_surcharge") as distinct_records from "2018_Yellow_Taxi_Trip_Data"
	union
select 'Tip_amount' as column_name, count(distinct "tip_amount") as distinct_records from "2018_Yellow_Taxi_Trip_Data"
	union
select 'Tolls_amount' as column_name, count(distinct "tolls_amount") as distinct_records from "2018_Yellow_Taxi_Trip_Data"
	union
select 'Total_amount' as column_name, count(distinct "total_amount") as distinct_records from "2018_Yellow_Taxi_Trip_Data";

-- returns count of all the distinct combinations of rows 
select count(*) as distinct_observation_count from (select distinct * from "2018_Yellow_Taxi_Trip_Data") as sub_query;