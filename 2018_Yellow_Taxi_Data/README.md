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

### Analysis

`analysis.sql` provides code for the following:

1: Calculate the number of trips by vendorID by hour(based on drop_off_date) in 2018.

- I used the `date_trunc` function to round the hours in the timestamps for **tpep_dropoff_datetime** in order to be able to group all of the hours together in the same interval so I would be able to count the amount of trips in each hour. When I first ran the code, some of the outputted values in the hr column had years that were not 2018 (I saw 1996, 2001, etc) so I added the `extract` function to apply the count only when the year is 2018. 

2: Using the previous query, what was the daily(based on drop_off_date) mean, median, minimum, and maximum number of trips by vendorID in 2018?

- Using the code created in part 1 as a CTE, I used the `WITH` function to reference the CTE and find the min, max, mean, and median of each day for each VendorID. I again used `date_trunc` to round to day intervals for the dropoff_date. 

3: What is the mean, median, minimum, and maximum trip_distance by vendor between 5:00 and 6:00 AM (not including 6:00 AM)?

- Using `date_part`, I filtered for only rows in the dataset in which the hour part of the timestamp was = 5. I used the same min, max, mean, and percentile_cont functions as in part 2, this time for the "Trip_distance" column of the dataset to calculate the min, max, mean, and median trip distance between the hours of 5:00 and 6:00 AM. I also used a `group by` to group the results by VendorID to see the min, max, mean, and median trip distance for each VendorID. 

|vendor_id|min_trip_dist|max_trip_dist|mean_trip_dist|median_dist|
|--|--|--|--|--|
|1|0|149.3|3.8795|1.9|
|2|0|198.19|4.2235|2.07|
|4|0|34.14|3.8175|1.755|

4: What day in 2018 had the least / most amount of unique trips?

- I created two separate select statements to check for the day with the most trips and the day with the least trips. I used `date_part` to select for day intervals and I used the count function to count for all trips within each day. For the least_trips count I used `order by` to order the results based on the count in an ascending order to start the output with the day with the least amount of trips. In the most_trips counts I ordered by the count in a descending order to start with the day with the most amount of trips. In both cases I used `limit` to only output the first row of the result, which was the days with the least and most trips. 
- After creating both least_day and most_day, I used the `UNION` operator to combine both sets in one output. At first I merely added "union" in between both select statements and I got a syntax error near "union." After googling, I realized that because of the `order by` clause, I needed to add parenthesis fully around both select statements so they would each run their own and then combine. 

|type_day|the_day|cnt|
|--|--|--|
|least_day|2018-01-04|123,015|
|most_day|2018-03-16|696,600|

5. What was the average tip percentage (tip_amount/total_amount) for unique trips in 2018?

- I used the `avg` function to calculate the average of "Tip_amount"/"Total_amount" for trips in 2018. Initially I had an error which stated that there was division by zero so I added a `where` clause to filter for only trips where the "Total_amount" was greater than 0. 
- The average tip percentage calculated was **0.66%**.

6. What was the average tip percentage by drop off hour for unique trips in 2018?

- I used the same `avg` function to calculate the average tip percentage but this time I also used the `extract` function to extract the hour from each timestamp and calculate the average tip percentage by the hour. 

### Views

`create_view.sql` creates a view called `daily_tip_percentage_by_distance`. I used `date_trunc` to get the date from each tpep_dropoff_datetime and I completed the `CASE` statement to calculate for each trip mileage and I used the `avg` function to calculate for the average tip percentage for each mileage. Once again, I had to add a `where` clause for when "Total_amount" > 0 so as not to run into an issue of dividing by zero in the `avg`. 