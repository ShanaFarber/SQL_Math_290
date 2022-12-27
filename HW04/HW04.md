# Homework 4

Screenshots with explanation of the results of my SQL code: https://docs.google.com/document/d/1-CIp64NsmzZhRB78KF-3Rxg5hqWgLJ7H4LSToG9jOyI/edit?usp=sharing

### Exercise 1:

I started off with a single SELECT statement to count all of the distinct values for each column.While this was able to run successfully to output the distinct values in each column, it was not formatted in the desired way. Instead I had an outputted table with 17 columns for each distinct count.  

I could not figure out a statement to combine all the distinct counts and output a table in the desired format. Instead, I used 17 different select stataments generating temp tables for each distinct count and I used the UNION operator to combine all of the results. 

- I did not have enough space for the query to run for the entire dataset, and it was also taking a really long time for the code to run, so I instead chose to run the query on the relation *after* having completed exercise 5 (deleting the data where "VendorID" = 2 and then shrinking the size of the database allowed for a much faster run). This worked to output the distinct values in the format requested.

*From the original distinct count above*, none of the resultant values came even close to the 112+ million rows that are in the dataset so there is not one singular attribute that can be used as a primary key for this dataset as there are not enought distinct values for the set. 

### Exercise 2: 

The outputted result of this query was **102,804,099**. Based on the return of this query in comparison to the 112+ million rows in the complete dataset, there is no combination of columns that can be used as a primary key because there are not enough distinct combinations for the entire set. 


### Exercise 3

- How many rows have a "passenger_count" equal to 5?

        select count(*) from taxi_fares where "Passenger_count" = 5;

    This returns a count of all of the rows in which the value of "Passenger_count" is equal to 5. The = operator checks to see all instances in the column specified by the WHERE clause. 
    The outputted value is **5,040,905** rows in which "Passenger_count" = 5. 

- How many distinct trips have a "passenger_count" greater than 3?

        select count(*) from (select distinct * from taxi_fares) x where "Passenger_count" > 3;
    
    I used a subquery to check the distinct combination of rows and then return all of the distinct rows in which "Passenger_count was greater than 3. 
    The output value was **9,415,989** distinct rows in which "Passenger_count" was greater than 3. 


- How many rows have a tpep_pickup_datetime between '2018-04-01 00:00:00' and '2018-05-01 00:00:00'?

        select count(*) from taxi_fares where "tpep_pickup_datetime" between '2018-04-01 00:00:00' and '2018-05-01 00:00:00';

    I used the BETWEEN operator to check for all times where "tpep_pickup_datetime" was between the two datetimes. 
    The outputted value is **9,305,362** rows between the two specified datetimes. 

- How many distinct trips occurred in June where the tip_amount was greater than equal to $5.00?

       select count(*) from (select distinct * from taxi_fares) x where "tpep_pickup_datetime" between '2018-06-01 00:00:00' and '2018-06-30 23:59:59' and "Tip_amount" >= 5; 
    
    I used a subquery to count all of the distinct combinations of rows and then check for all rows between the datetimes for the first and last of June in which the tip amount was greater than or equal to 5. The BETWEEN operator is inclusive of the given values so I had to use the datetimes for the very beginning and very end of June rather than using the first of June and the first of July, as that would also record trips on the first of July. 
    The outputted value is **500,269** distinct rows in June where the tip amount was greater than or equal to $5.00. 

- How many distinct trips occurred in May where the passenger_count was greater than three and tip_amount was between $2.00 and $5.00?

        select count(*) from (select distinct * from taxi_fares) x where "tpep_pickup_datetime" between '2018-05-01 00:00:00' and '2018-05-31 23:59:59' and "Passenger_count" > 3 and "Tip_amount" between 2 and 5;

    I used a subquery to check for all distinct combinations of rows and and then check for all rows between the first and last dates of May where "Passenger_count" was greater than 3, "Tip_amount" was greater than or equal to 2, and "Tip_amount" was less than or equal to 5. 
    The outputted value is **622** distinct rows in the month of May where "Passenger_count"  is greater than 3, "Tip_amount" is between $2.00 and $5.00. 

- What is the sum of tip_amount in the 2018_Yellow_Taxi_Trip_Data dataset? (Hint: use the SUM() function to find the answer)

        select sum("Tip_amount") from taxi_fares;

    I used a SUM() function to add all of the values in the "Tip_amount" column.
    The outputted value is **38,728,657.77**. 

    *Can you assume that the answer to your previous question is equivalent to the question of "How much tip did taxi drivers collected in total in 2018?" Explain your answer.*

    You cannot conclude that this sum is the total amount of tips ecrued by taxi drivers in 2018 because it does not factor in for cash tips that people may have given. 

### Exercise 4

Using the command `select * from pg_catalog.pg_stat_database;` I was able to find the database id which was 16412.

|folder_name|size|
|--|--|
|base | 13.87 GB|
|16412 | 13.83 GB|

### Exercise 5

I used a DELETE statement to remove all of the rows where "VendorID" was equal to 2. 

I then used a SELECT COUNT to count all of the rows in which "VendorID" was equal to 2. This returned a value of 0 so it was confirmed that all rows with "VendorID" = 2 were deleted. 

After checking the sizes of the base and databaseid folders, the size of my database remained the same. After searching this a bit, I read that the database does not automatically shrink when you delete data. This is because, when you create the database, you allot a certain amount of space to be in that database and ideally there should be lots of free space for the database to be able to grow. Therefore, deleting data does not decrease the size of the database so that there is room for the database to grow again. In order to decrease the size of the database, one would have to manually shrink the database (https://dba.stackexchange.com/questions/28360/sql-server-database-size-didnt-decrease-after-deleting-large-number-of-rows). 


 After running `VACUUM FULL;`, the size of the base folder decreased to **5.88 GB** and the size of the databaseid folder (16412) decreased to **5.85 GB**. 

 The reason for this decrease in space is because the command copies all of the information in the table as a new table without any extra space (https://www.postgresql.org/docs/9.1/sql-vacuum.html#:~:text=VACUUM%20FULL%20rewrites%20the%20entire,while%20it%20is%20being%20processed). Therefore, all of the empty space that was left after the DELETE statement is no longer part of the database. 

### Exercise 6

The TRUNCATE function removed all of the data from the taxi_fares table. I then used a SELECT statement to view the contents of the table to make sure all of the data was removed and it outputted a blank table.

I then used the same code from HW's 2/3 to re-import the data into the table. 