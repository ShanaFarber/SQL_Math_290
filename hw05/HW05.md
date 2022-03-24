# Homework 5

*Link to pictures of outputs*: https://docs.google.com/document/d/1kI8j2dtB2kwGDT7U8Q1nznXKhVz-aTWnu81Y5IqySu0/edit

### Exercise 1

- As my operating system is Mac OS, I am unable to download Microsoft Power BI.
- I created an AWS account.


### Exercise 2

Part 1: Calculate the number of trips by vendorID by hour(based on drop_off_date) in 2018.

- I used the `date_trunc` function to round the hours in the timestamps for **tpep_dropoff_datetime** in order to be able to group all of the hours together in the same interval so I would be able to count the amount of trips in each hour. When I first ran the code, some of the outputted values in the hr column had years that were not 2018 (I saw 1996, 2001, etc) so I added the `extract` function to apply the count only when the year is 2018. 
- Helpful link: https://mode.com/blog/postgres-sql-date-functions/ 

Part 2: Using the previous query, what was the daily(based on drop_off_date) mean, median, minimum, and maximum number of trips by vendorID in 2018?

- Using the code created in part 1 as a CTE, I used the `WITH` function to reference the CTE and find the min, max, mean, and median of each day for each VendorID. I again used `date_trunc` to round to day intervals for the dropoff_date. 

Part 3: What is the mean, median, minimum, and maximum trip_distance by vendor between 5:00 and 6:00 AM (not including 6:00 AM)?

- Using `date_part`, I filtered for only rows in the dataset in which the hour part of the timestamp was = 5. I used the same min, max, mean, and percentile_cont functions as in part 2, this time for the "Trip_distance" column of the dataset to calculate the min, max, mean, and median trip distance between the hours of 5:00 and 6:00 AM. I also used a `group by` to group the results by VendorID to see the min, max, mean, and median trip distance for each VendorID. 

|vendor_id|min_trip_dist|max_trip_dist|mean_trip_dist|median_dist|
|--|--|--|--|--|
|1|0|149.3|3.8795|1.9|
|2|0|198.19|4.2235|2.07|
|4|0|34.14|3.8175|1.755|


Part 4: What day in 2018 had the least / most amount of unique trips?

- I created two separate select statements to check for the day with the most trips and the day with the least trips. I used `date_part` to select for day intervals and I used the count function to count for all trips within each day. For the least_trips count I used `order by` to order the results based on the count in an ascending order to start the output with the day with the least amount of trips. In the most_trips counts I ordered by the count in a descending order to start with the day with the most amount of trips. In both cases I used `limit` to only output the first row of the result, which was the days with the least and most trips. 
- After creating both least_day and most_day, I used the `UNION` operator to combine both sets in one output. At first I merely added "union" in between both select statements and I got a syntax error near "union." After googling, I realized that because of the `order by` clause, I needed to add parenthesis fully around both select statements so they would each run their own and then combine. 

|type_day|the_day|cnt|
|--|--|--|
|least_day|2018-01-04|123,015|
|most_day|2018-03-16|696,600|

### Exercise 3

What was the average tip percentage (tip_amount/total_amount) for unique trips in 2018?

- I used the `avg` function to calculate the average of "Tip_amount"/"Total_amount" for trips in 2018. Initially I had an error which stated that there was division by zero so I added a `where` clause to filter for only trips where the "Total_amount" was greater than 0. 
- The average tip percentage calculated was **0.66%**.

What was the average tip percentage by drop off hour for unique trips in 2018?

- I used the same `avg` function to calculate the average tip percentage but this time I also used the `extract` function to extract the hour from each timestamp and calculate the average tip percentage by the hour. 

*A note on the commented out code:* I came up with this initially but then I saw a `round` function online ([linked here](https://www.sisense.com/blog/weighted-vs-unweighted-averages/)) and I added that to the code to round the result to the proper format for percentage.  

### Exercise 4

I created a view called `daily_tip_percentage_by_distance`. I used `date_trunc` to get the date from each tpep_dropoff_datetime and I completed the `CASE` statement to calculate for each trip mileage and I used the `avg` function to calculate for the average tip percentage for each mileage. Once again, I had to add a `where` clause for when "Total_amount" > 0 so as not to run into an issue of dividing by zero in the `avg`. 

