# Homework 6

Link to pictures: https://docs.google.com/document/d/1fJhcdHTVEliO4HWzY4d3sc_pyZIxXkM4OAJZQG3rZOM/edit?usp=sharing 

### Exercise 1

I emailed the IT department for access to PBI. 

### Exercise 2

I created the imdb database and created the seven tables using the column names from the imdb website. I used the `copy` function to insert the data from the TSV files into the tables. 

Using a `select` statement to check the contents of my tables (`select * from table_name`), I noticed that the values of the first row of each table were the column names. In order to delete this extra row, I used a `delete` statement for each table using a `where` clause to delete all rows where `"column1_name" = 'column1_name'`. This got rid of the extra row in each table. 

I then modified the `copy to` function to include my own filepath. Each statement was of the form below:

    COPY table_name("column1", "column2", "column3", ...) 
    TO '/Users/shoshanafarber/Downloads/table_name.csv' DELIMITER ',' CSV HEADER;

### Exercise 3

Before evaluating the cardinality of each column for each table, I first used `select count(*)` to count the number of rows in each table. 

|table_name|cnt|
|--|--|
|title_akas|31,426,218|
|title_basics|8,783,379|
|title_crew|8,783,379|
|title_episode|6,580,601|
|title_principals|49,466,030|
|title_ratings|1,226,100|
|name_basics|11,496,547|

I then did a distinct count for every column in each table to see the cardinality of each column. Based on the inital distinct count, "tconst" works as a primary key for the **title_basics**, **title_crew**, **"title_episode**, and **title_ratings** tables, and "nconst" works as a primary key for the **name_basics** table. Neither **title_akas** nor **title_principals** have one singular attribute that can be used as a primary key. These tables require a composite primary key. 

I checked for composite primary keys for title_akas and title_principals. I first used a CTE to check for ditinct rows with combined column titles and then did a count for those values (I also later figured out how to do this as a subquery). 

Checking for a composite key for title_akas using "titleID" and "ordering" yielded a value of **32,426,218** which is the same as the count for the amount of rows in the title_akas table, so the composite primary key for the title_akas relation is "titleID", "ordering". 

Checking for a composite key for title_principals using "ordering" and "tconst" yielded a value of **49,466,030** which is the same as the number of rows in the title_principals relation so "ordering", "tconst" is the composite primary key for title_principals. 

|table_name|primary_key|
|--|--|
|title_akas|"titleID", "ordering"|
|title_basics|"tconst"|
|title_crew|"tconst"|
|title_episode|"tconst"|
|title_principals|"ordering", "tconst"|
|title_ratings|"tcosnt"|
|name_basics|"nconst"|

Then, using the form `ALTER TABLE imdb.public.table_name ADD PRIMARY KEY ("primaryKeyCol_name");` I added primary keys to each of the imdb relations. 

### Exercise 4

- *Step 1:* There are 3 "tconst" records in title_ratings that are not present in title_basics.
- *Step 2:* There are 7,557,282 "tconst" records in title_basics that are not present in title_ratings.
- *Step 3:* There are 1,226,097 records that contain the same "tconst" values in title_basics and title_ratings.
- *Step 4:* Based on this, neither table is the parent table nor the child table. 
- *Step 5:* I anyways attempted to establsh a foreign key relationship between the two tables using an alter statement to add a foreign key. I tested using both tables as a foreign key in the other to confirm my suspicions from step 4. 
- *Step 6:* My attempts in step 5 failed. I recieved an error message: 
        
        SQL Error[23503]: ERROR: insert or update on table "title_ratings" violates foreign key constraint "fk_tcosnt" 
        Detail: Key (tconst)=(tt10028954) is not present in table "title_basics".

    I receieved the same error message for both attempts to create a foreign key. This is because neither table has all of the "tconst" values present in the other table so neither can be used as a parent table, since all the values in the child table of he foreign key relationship have to be present in the foreign key column of the parent table. 

### Exercise 5

I have not received an answer from the IT department and I have still not been granted access to app.powerbi.com so I could not complete this exercise. 

### Exercise 6

As I am working with MacOS operating system I was unable to download Microsoft Power BI and I was unable to complete this portion. 
