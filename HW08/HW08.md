# Homework 8

*Pictures:* https://docs.google.com/document/d/1iHDvZzNuyuHKAI8iOrgTzv7kypLueuKYypP4Q47LnvM/edit

**Question 1:** What is the total runtime of all movies in the IMDB database where Nicolas Cage appeared as an actor?

- For this question, I knew I would need the "runtimeminutes" column of the **xf_title_basics** relation and the "primaryName" column from **xf_name_basics**. However, since there is no column shared between them, I was not able to perform a join on the two tables. I noticed that **xf_title_principals** had both the "tconst" and "nconst" columns that are in **title_basics** and **name_basics** respectively. I therefore used a `full outer join` to combine the **xf_title_principals** and **xf_name_basics** relations and then I used a second `full outer join` to combine this with the **xf_title_basics** relation. 
- I used the `sum` function to add the number of "runtimeminutes" for my selection. 
- I filtered for "titleType" from **xf_title_basics** being only those titles listed as 'movie', "primaryName' from **xf_name_basics** as only 'Nicolas Cage", and "category" from **xf_title_principals** to show only those movies in which he was an actor. 
- *Answer:* The total runtime returned was **9,526** minutes. 

**Question 2:** Which actor had the most number of titles in 2012?

- For this question, I used the same `full outer joins` as in question 1, but I modified my filter and my select statement. 
- I used nb."primaryName" as the actor name and I used the `count` function to count the number of titles. 
- I filtered for when tb."startYear" was 2012 and for when tp."category" was 'actor'.
- I then grouped by the actor name and I used the `order by` clause to return the results in a descending count. I limited the count to return just the first row.
- *Answer:* Kinshuk Mahajan appeared in the most titles (502 titles). 

**Question 3:** What Nicolas Cage's move received the highest average rating?

- For this question, I used another `full outer join` to reference the "averagerating" column of the **xf_title_ratings** relation. 
- I used the same where clause from question 1 to filter for movies in which Nicolas Cage is an actor, but I added an "is not null" for "averagerating" since I initially recieved a null answer and, after checking the table, saw that some of the "averagerating" values were null. 
- I ordered by the average rating in descending order so the result would start off with the highest rated movie and I used a `limit` to only return the first row. 
- *Answer:* The Unbearable Weight of Massive Talent recieved the highest average rating from all Nicolas Cage movies (9.2 rating).

**Question 4:** Which short movie received the highest average rating in 2009?
- I first checked to see how the IMDb database referenced short movies and I saw that they were referred to as "short."
- Using the same joins as the previous question, I modified the `where` clause for where "titletype" is 'short', "startYear" is 2009, and "averagerating" is not null. 
- I used the same order and limit as in the previous question to return only the highest rated movie.
- *Answer:* The House of Dr. Death (rating of 10). 

**Question 5:** Return the top 10 actors with most movies where the runtime is between 45 and 60 minutes and the start year is between 2000 and 2010?

- I used the same join from question 1 and I used a `select` for "primaryName" and count(*). I filtered for when "runtimeminutes" was between 45 and 60 (inclusive) and when "startYear" was between 2000 and 2010 (inclusive). 
- I then grouped by "primaryName" and ordered by the descending count so that the result would return each actor with their movie count starting with the actor with the most movies.
- I used a `limit` to only return the first 10 rows from the result. 
- *Answer:*

    |actor|cnt|
    |--|--|
    |Jorge Aravena|539|
    |Christian Meier|530|
    |Victor Noriega|499|
    |Mario Cimarro|467|
    |Mauricio Islas|449|
    |Victor Gonzalez|449|
    |Ricardo Gonzaelez|381|
    |Jorge Luis Pila|339|
    |Gabriel Porras|314|
    |Jorge Reyes|311|

**Question 6:** What are the top 10 highly rated movies with only three words in their titles?

- For this question, I used a `full outer join` between the **xf_title_basics** and **xf_title_ratings** relations. 
- In order to count the number of words in each title, I used the following in my `where` clause:
    
        (length(tb."primaryTitle") - length(replace(tb."primaryTitle", ' ', ''))) = 2

    This counts the length of the string in "primaryTitle" and subtracts the length sans spaces (the `replace` function replaces all spaces with no space) and returns the number of spaces in the title. Since a three letter title would have two spaces, I filtered for all "primaryTitles" where the result of this code was = 2. 

    Another way of doing this problem:

        array_length(regexp_split_to_array("primaryTitle", ' '), 1) = 3

    The nested function turns the string into an array using the space as the delimiter. `array_length` then counts the length of the one dimensional array. This returns the number of words in the title so for this one would filter for when the result of this = 3. 

    Helful link: https://stackoverflow.com/questions/27827376/sql-count-number-of-words-in-field
 
 - *Answer:*

    |movie|rating|
    |--|--|
    |Esteghlalish Blue Vol.2|10|
    |The Great Gathering|10|
    |Oru Canadian Diary|10|
    |Girls Loving Girls|10|
    |Days of Geants|9.9|
    |Esteghlalish Blue Vol.1|9.9|
    |The Burmese Python|9.9|
    |Strangers to Peace|9.8|
    |Code Name Abdul|9.8|
    |Trenches of Rock|9.8|

**Question 7:** Extra credit: Are three-word movie titles more popular than two-word titles?

- For this question, I used a `full outer join` between the **xf_title_basics** and **xf_title_ratings** relations. 
- For this question, I used the "numVotes" and "averageRating" columns from the **xf_title_ratings** table. 
- I used the `array_length` function above to create a select statement for movie title length. I also used the `sum` function to add the number of votes and the `avg` function to calculate the average rating for each title length. 
- In my where clause, I used "or" to filter for only movies with two-word or three-word titles. 

    |titleLength|total_numVotes|avg_rating|
    |--|--|--|
    |2|304,882,724|6.1|
    |3|257,898,457|6.9|

    Based on these results, it seems movies with two-word titles are more popular than those with three-word title. However, movies with three-word titles are slightly higher rated than those with two-word titles. 

**Question 8:** Extra credit: Does this (see question 7) change over time?

- I used the same join and where clause as above. 
- I added the "startyear" column into the select statement and referenced it in the `group by` clause in order to see the popularity of movies with two and three word titles overtime. I first just used each individual year, but there was a lot of information and I could not clearly see whatver trend there may have been, so I then decided to use a case by case statement within the select to group the years by every 10 years. I noticed from the original code that there were no two-word movie titles produced before 1899, so I opted to leave out the years before then. I did a check to see the min and max dates to know where to start and end off in my case statement. 
- *Answer:* Based on the resultant table, I do not think that the result of question 7 does change over time, but not in a steadily increasing or decreasing direction. In some decades, two-word titles had significantly higher numVotes and/or higher ratings and some decades had significantly higher numVotes for three-word titles and/or higher ratings. 
- Based on this, I also decided to go back and change my code for number 7 to also limit for post-1890 movies (as I had done with the case statement). I got a similar result to my answer for question 7, with the total_numVotes for three-word titles decreasing slightly but the average rating staying the same. 
- Results of both can be seen in screenshots included in the google doc link above. 

*A note on questions 2 and 5:* Sachin had an excellent question of whether we should also include actresses in this query. As I had done the question prior to seeing his question and I did not see a response before posting this, I worked under the assumption that I should limit the search to just 'actor' as is stated in the question. 