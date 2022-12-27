# Homework 9

*Link to screenshots*: https://docs.google.com/document/d/1Ze_PfXwelGfn7S3_tkE97zd0qdYzqot6bS72wW7lYGI/edit?usp=sharing

**Question 1**: Are movie ratings normally distributed? To answer this question, take the following steps.

- Visualize the data in a histogram and observe if the ratings adhere to a bell curve (use PowerBI to do this)

    Since I do not yet have access to PowerBI, I used the histogram that Amir sent to the group chat to visualize the data. According to this, the data is not normally distibuted and it seems to have a negative (left) skew. 

- Look at the descriptive statistics of the data (n, min, max, mean, variance, skewness, kurtosis)

    n = cnt = 1,226,100
    min = 1
    max = 10
    mean = 6.93
    variance = 1.94
    skewness = -0.38 ([found formula here](https://towardsdatascience.com/how-to-derive-summary-statistics-using-postgresql-742f3cdc0f44#:~:text=Skewness-,In%20PostgreSQL%2C%20there%20is%20no%20function%20to%20directly%20compute%20the,as%20a%20proxy%20to%20skewness.))
    *I could not figure out formula for kurtosis 

- Calculate the relative frequency distribution of movies ratings (here is a refresher on relative frequency)

    I was unable to figure out how to get the code to work properly. 

- Carry out the Shapiro-Wilk Test described here

**Question 2**: What are the first and last names of all the actors cast in the movie 'Lord of war'? What roles did they play in that production?

- For this question, I used `left join` to join the xf_title_basics, xf_name_basics, and xf_title_principals tables. xf_title_principals is the only table with both "nconst" and "tconst" so that needed to be used to join the other two tables together. 
- I referenced "primaryNames" from xf_name_basics to return the names of the actors and actresses and "characters" from xf_title_principals to return their role. I then filtered for where the "primaryTitle" from xf_title_basics was 'Lord of War' (had to capitalize "war" from the question) and where the "category" from xf_title_principals was included in the set {'actor', 'actress'} (meaning that the "catergory" was either 'actor' or 'actress'). 
- *Answer*:

    |actor|role|
    |--|--|
    |Nicolas Cage|Yuri Orlov|
    |Ethan Hawke|Jack Valentine|
    |Jared Leto|Vitaly Orlov|
    |Bridget Moynahan|Ava Fontaine|

**Question 3**: What are the highest-rated Comedy shorts between 2000 and 2010?

- For this question, I used 3 different methods: 
    
    **Method 1**: Initially I was unsure how to reference just one value from an array. So, I used the `unnest` function to unnest the array. Then, in my query, I referenced the CTE and used `left join` to join it with xf_title_ratings. 

    **Method 2**: For this method, I used `cross join unnest` instead of the CTE from method 1 to unnest the array.

    **Method 3**: After already doing both methods from above, I learned of a way to reference just one value from an array. The `@>` operator means "contains" so I was able to use `where xtb."genres" @> '{Comedy}'` to limit my query to only those shorts in which the "genres" array contains "Comedy" as a genre. 

- For all 3 methods, I used the same `select` statement to select the title name from xf_title_basics and its corresponding rating from xf_title_ratings. I also filtered for where the "titleType" is 'short', for where the "startyear" is between 2000 and 2010 (inclusive), and for when "averageRating" was not null. I ordered the result by descending rating to see the highest-rated comedy shorts. The result can be seen in the screenshot link above. 

**Question 4**: What is the average number of votes for movies rated between 0-1, 1-2, 2-3, 3-4, 4-5?

- For this question, I used a `case` statement to group each rating by its respective interval. I also used the `avg` function to calculate the average number of votes within eac interval. I used `left join` to join xf_title_ratings and xf_title_basics so that I could filter the result to only return ratings for movies. 
- *Answer*:

    |rating_interval|avg_votes|
    |--|--|
    |0-1|248|
    |1-2|1,307|
    |2-3|621|
    |3-4|542|
    |4-5|779|

- It should be noted that the intervals in the case statement are starting digit inclusive, ending digit exclusive (i.e. 0-1 is 0 inclusive and 1 exclusive). 