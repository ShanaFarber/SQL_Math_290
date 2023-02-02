select count(*) from "2018_Yellow_Taxi_Trip_Data"; --112,234,626

select count(distinct "VendorID") from "2018_Yellow_Taxi_Trip_Data"; --3

select count(*)
from "2018_Yellow_Taxi_Trip_Data"
where "VendorID" is null; --0

select count(*)
from "2018_Yellow_Taxi_Trip_Data"
where "tpep_pickup_datetime" is null
	or "tpep_dropoff_datetime" is null 
	or "passenger_count" is null
	or "trip_distance" is null
	or "PULocationID" is null 
	or "DOLocationID" is null 
	or "ratecodeID" is null 
	or "store_and_fwd_flag" is null 
	or "payment_type" is null 
	or "fare_amount" is null 
	or "extra" is null 
	or "mta_tax" is null
	or "improvement_surcharge" is null
	or "tip_amount" is null
	or "tolls_amount" is null
	or "total_amount" is null; --0