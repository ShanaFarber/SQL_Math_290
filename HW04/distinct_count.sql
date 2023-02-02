select 'VendorID' as column_name, count(*) as distinct_records
	from(
		select distinct "VendorID" 
		from "2018_Yellow_Taxi_Trip_Data"  
	)as temp1
union
select 'tpep_pickup_datetime', count(*)
	from(
		select distinct "tpep_pickup_datetime" 
		from "2018_Yellow_Taxi_Trip_Data" 
	)as temp2
union
select 'tpep_dropoff_datetime', count(*)
	from(
		select distinct "tpep_dropoff_datetime" 
		from "2018_Yellow_Taxi_Trip_Data"  
	)as temp3
union
select 'passenger_count', count(*)
	from(
		select distinct "passenger_count"
		from "2018_Yellow_Taxi_Trip_Data" 
	)as temp4
union
select 'trip_distance', count(*)
	from(
		select distinct "trip_distance" 
		from "2018_Yellow_Taxi_Trip_Data" 
	)as temp5
union
select 'PULocationID', count(*)
	from(
		select distinct "PULocationID" 
		from "2018_Yellow_Taxi_Trip_Data"  
	)as temp6
union
select 'DOLocationID', count(*)
	from(
		select distinct "DOLocationID" 
		from "2018_Yellow_Taxi_Trip_Data" 
	)as temp7
union
select 'ratecodeID', count(*)
	from(
		select distinct "ratecodeID" 
		from "2018_Yellow_Taxi_Trip_Data"  
	)as temp8
union
select 'store_and_fwd_flag', count(*)
	from(
		select distinct "store_and_fwd_flag" 
		from "2018_Yellow_Taxi_Trip_Data"  
	)as temp9
union
select 'payment_type', count(*)
	from(
		select distinct "payment_type" 
		from "2018_Yellow_Taxi_Trip_Data"  
	)as temp10
union
select 'fare_amount', count(*)
	from(
		select distinct "fare_amount" 
		from "2018_Yellow_Taxi_Trip_Data"  
	)as temp11
union
select 'extra', count(*)
	from(
		select distinct "extra"
		from "2018_Yellow_Taxi_Trip_Data" 
	)as temp12
union
select 'mta_tax', count(*)
	from(
		select distinct "mta_tax" 
		from "2018_Yellow_Taxi_Trip_Data"  
	)as temp13
union
select 'improvement_surcharge', count(*)
	from(
		select distinct "improvement_surcharge" 
		from "2018_Yellow_Taxi_Trip_Data" 
	)as temp14
union
select 'tip_amount', count(*)
	from(
		select distinct "tip_amount" 
		from "2018_Yellow_Taxi_Trip_Data" 
	)as temp15
union
select 'tolls_amount', count(*)
	from(
		select distinct "tolls_amount" 
		from "2018_Yellow_Taxi_Trip_Data" 
	)as temp16
union
select 'total_amount', count(*)
	from(
		select distinct "total_amount" 
		from "2018_Yellow_Taxi_Trip_Data"  
	)as temp17
;