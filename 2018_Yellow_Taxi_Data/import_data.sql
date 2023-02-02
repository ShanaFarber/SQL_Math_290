copy public."2018_Yellow_Taxi_Trip_Data"(
	"VendorID",
	"tpep_pickup_datetime",
	"tpep_dropoff_datetime",
	"passenger_count",
	"trip_distance",
	"ratecodeID",
	"store_and_fwd_flag",
	"PULocationID",
	"DOLocationID",
	"payment_type",
	"fare_amount",
	"extra",
	"mta_tax",
	"tip_amount",
	"tolls_amount",
	"improvement_surcharge",
	"total_amount"
) from 'C:\Temp\2018_Yellow_Taxi_Trip_Data.csv' delimiter ',' csv header;