# Homework 7

*Pictures:* https://docs.google.com/document/d/1a_hiZTa5Zc8Xi9R-H4ucG9tvY52AYE67GZ4e2yrwQU4/edit

### Exercise 1

- *Step 1:* All datatypes for **title_basics** table were **varchar**.
- *Step 2:* I created a view for each table using the same form as was given in the homework:

        create view imdb.public.etl_title_basic_v
        as
        select 
        tb.tconst
        ,tb.titletype
        ,tb.primarytitle
        ,tb.originaltitle
        ,cast(tb.isadult as boolean) as isadult
        ,cast(tb.startyear as integer) as startyear
        ,cast(tb.endyear as integer) as endyear
        ,cast(tb.runtimeminutes as integer) as runtimeminutes
        ,regexp_split_to_array(tb.genres,',')::varchar[] as genres       
        from imdb.public.title_basic tb;

    In my code, I added quotations around the column names to ensure I would not get any "column does not exist" errors. I used the `cast` function to change the datatypes of some of the columns to integer, boolean, or numeric datatypes based on the IMDb documentation. I used `split_to_array` for the columns which were listed as array datatypes to create an array of varchar values. 

    *A note on the commented out code:* In step 3 of the assignment, I recieved an error message when creating the physical table for xf_title_ratings indicating that there was a decimal value in a column with an integer datatype. I could not figure out how to alter the view to change the datatype so I dropped the initial view and created a new view with "averageRating" column cast as a numeric. 


### Exercise 2

Question 1: How many movies are in the xf_title_basic table with runtimes between 42 and 77 minutes?
- I used the `count` function to count the number of rows which had "runtimeminutes" between the specified amount of minutes. I chose to view this as inclusive of 42 and 77 minites so I used the greater than or equal and less than or equal operators to filter.  
- Answer: 593,439


Question 2: What is the average runtime of movies for adults?
- Since "isAdult" is a boolean, I used the `cast` function to cast it as an integer so that I could filter for all rows where "isAdult" had a value of 0 (true). 
- Answer: 42.56 minutes

Question 3: Without running the SQL below, what number should it return? In other words, what is the cartesian product of the xf_title_basic table with itself?

    select count(*) from (
    select xtb_a.runtimeminutes, xtb_b.runtimeminutes
    from imdb.public.xf_title_basic xtb_a, imdb.public.xf_title_basic xtb_b
    )x;

- The cartesian product of X x Y is the set of all pairs (x,y) from X = {x1, x2,...} and Y = {y1, y2,...}. The cartesian product of this query would therefore be all of the the set of all combinations of each runtimeminutes from xtb_a with all runtimemintes from xtb_b. 
- The number returned from this query would be the the number of tables rows x the number of table rows. This would be 8,783,379 x 8,783,379.

Why do you think it is advised against running the above query?
- Since there are so many rows in both tables, this query would first have to find the cartsian product of the table with itself and then also count all of the rows which would take an incredibly long time. 

Question 4: Calculate the average runtime (rounded to 0 decimals) of movies where the genre's first element is 'Action'. (Hint: the first element of an array in Postgres can be referenced like this: array_name[1]) How many of all movies in the xf_title_basic has the previously calculated average runtime?
- I used the `round` function to round to zero decimals. 
- Average runtime: 48 minutes
- Movies with this runtime: 13,795

Question 5: What is the relative frequency of each distinct genre array (combination of genres)?
- For this question, I was able to find the frequency of each genre array but I was not yet able to figure out how to find the relative frequency. I believe to do this I would need to create 2 CTEs for the individual and total counts and then reference a `cross join` of the two in the queury for relative frequency. 

Question 6: (optional): How many distinct genres are used to build the genres array? Hint: unnest the array first.
- I first used a CTE with the `unnest` function to unnest the "genres" array. I then used the `count` function to count the number of distinct genres from the unnested array.
- Answer: 28 genres

### Exercise 3

- *Step 1:* I used `full outer join` to join the two tables. 
- *Step 2:* Using the join as the table from which I am querying, I did a count for the "tconst" column of the title_crew table, grouping by the "tconst" column of the title_basics table. 
- *Step 3:* Using the previous query as a CTE, I used the `min` and `max` functions to caluclate the minimum and maximum counts. 
- *Step 4:* I repeated the previous steps for title_basics grouping by title_crew.

Based on these, what is the cardinality of the relationship between these two tables?
- Based on the min and max counts, there is  1:1 cardinality between the two tables. 

### Exercise 4 

I repeated the steps above for the title_episode, title_principals, and title_ratings tables

- Cardinality between title_basics and title_episode: 1 to many
- Cardinality between title_basics and title_principals: many to many 
- Cardinality between title_basics and title_ratings: many to many 

(Exact counts can be seen in the screenshots included in the google link above). 