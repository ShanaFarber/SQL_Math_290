# 2018 Yellow Taxi Data

Source and documentation: [NYC Open Data](https://data.cityofnewyork.us/Transportation/2018-Yellow-Taxi-Trip-Data/t29m-gskq) (export as CSV and use data dictionary PDF to define columns).

## SQL Scripts

### Creating the Schema

1. `create_table.sql` uses the documentation from the NYC Open Data page to create a schema for the taxi data using the defined column names.
2. `import_data.sql` uses COPY to import the data from the 2018 taxi csv into the **2018_Yellow_Taxi_Trip_Data** table. Taxi data CSV stored in "Temp" file so that Postgres server can access.

### Counting the Values

1. `count_checks.sql` counts the number of rows in the dataset, the number of distinct VendorIDs, as well as any NULL values.
    - There are **112,234,626** rows in the dataset. This matches with the NYC Open Data website which states there are 112M rows. 
    - There are **3** values for VendorID.
    - There are no NULL values in the dataset. 
2. The first query in `distinct_count.sql` counts the number of distinct values of each column and outputs the results in a readable table format. The query unions 17 separate select statements so it takes some time to finish the query. The results are as follows:

    |column_name|distinct_records|
    |--|--|
    |total_amount|22,606|
    |mta_tax|65|
    |tip_amount|6,483|
    |PULocationID|264|
    |passenger_count|12|
    |DOLocationID|264|
    |tolls_amount|3,100|
    |tpep_dropoff_datetime|27,456,644|
    |extra|114|
    |trip_distance|7,181|
    |tpep_pickup_datetime|27,427,746|
    |VendorID|3|
    |improvement_surcharge|21|
    |payment_type|5|
    |fare_amount|9,839|
    |store_and_fwd_flag|2|
    |ratecodeID|7|

    Based on these results, none of the columns are candidates for being a primary key for this dataset. 

    The second query in `distinct_count.sql` attempts to see if a primary key can be established by any combination of rows. The resultant count is **102,804,099**. Comparing this to the 112M+ rows in the dataset, no combination of rows would be a candidate for being a primary key. 

### Questions

`questions.sql` queries the answers to the following questions:

1. How many rows have a "passenger_count" equal to 5? 
    - **Answer**: 5,040,905

2. How many distinct trips have a "passenfer_count" greater than 3? 
    - **Answer**: 9,415,989

3. How many rows have a "tpep_pickup_datetime" between '2018-04-01 00:00:00' and '2018-05-01 00:00:00'?
    - **Answer**: 9,305,362

4. How many distinct trips occured in June where the "tip_amount" was greater than or equal to $5.00? 
    - **Answer**: 713,388

5. How many distinct trips occured in May where the "passenger_count" was greater than 3 and the "tip_amount" was between $2.00 and $5.00? 
    - **Answer**: 236,457
    
6. What is the sum of "tip_amount" in the "2018_Yellow_Taxi_Trip_Data" dataset? 
    - **Answer**: $210,156,392.48
    - This does not account for all tips that drivers receieved as it does not include cash tips that passengers may have given. 