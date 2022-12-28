# Final Project

This is the final project for the MATH 290 course. 

In this project, we analyzed a dataset of book ratings to answer questions such as "which books are most popular" and "amongst which ages." We first used code to test the cardinality of each table in the dataset to see which columns were candidates for being primary keys and to understand which columns to use for joins. Once we knew this, we came up with our questions (seen below) and we started work on code to test the limitations or our data, as well as to answer our questions. 

The dataset can be found [here](https://www.kaggle.com/datasets/arashnic/book-recommendation-dataset?select=Books.csv).

[Link to project dashboard](https://www.canva.com/design/DAFBFgLzyAo/OMxdrLJ1__NteYFUeU9Fwg/view?utm_content=DA%5B%E2%80%A6%5Dm_campaign=designshare&utm_medium=link2&utm_source=sharebutton).

*A note on the dataset: There seem to be outliers in the dataset. A few hundred values in the user_age column of the **users** relation seem to be innacurate, as they are either too young (0) or too old (244) to be plausible. However, the rest of the dataset seems to be ok and we think there are still insights to be made from the data. Given that the age column is the only one with issue, we decided to filter age-based queries to between the ages of 10 and 100, as we think these are plausible.*

### Cardinality

**books** relation: 
- The row count for the books relation is 271,360. The distinct count of rows is also 271,360, so all rows are unique. 
- We also did a count and distinct count for each column to see if any were candidates for a primary key. Based on the results, the ISBN are all unique. 

**ratings** relation:
- The count and distinct count for rows both returned 1,149,780 so every row is unique.
- The count and distinct count for each column shows none of the values are candidates for primary keys alone. This makes sense, as the ratings tables can have one user_id listed multiple times for different ratings, or multiple users rating one ISBN. Therefore, user_id and ISBN can be listed multiple times and they will not all be unique. The combination of user_id and ISBN will, however, be unique, as each user rates each book only once. 

**users** relation:
- The count and distinct count for rows both returned 278,858, so all rows are unique.
- The count and distinct counts for each columns show that the user_id column is unique. 

*Cardinality between tables:*
- For some reason we are getting different numbers from the same code we used to analyze cardinalities between tables. Further analysis is needed to understand why this is happening and what is the correct cardinalities.
- We assume there to be a 1 to many relationship between ISBN of the books table to ISBN of the ratings table. We also assume there to be 1 to many relationship between user_id from the users table to user_id of the ratings table. 

### Analyzing the Data

**Questions**: What do people rate based on age? What age is most likely to rate? 

We wanted to see if people were more likely to rate based on age (i.e. if specific age groups tended to rate more than others) and also how people rated based on age. We first used a query to output the user age, rating count, and average rating, grouping by user_age to see the number of ratings of each age and the average rating of that age. There was a lot of information from this query and it was hard to see a clear trend, so we decided to modify the code to use a `case` statement to group the ages by tens. 

    case when u.user_age >= 10 and u.user_age <= 19 then '10s'
		when u.user_age >= 20 and u.user_age <= 29 then '20s'
            ...
    end as age_interval

Based on this query, it seems that younger readers (10-teens) and older readers (70-90s) seem to rate books higher than readers aged in between. However, it can also be noted that people in their 20s-50s have a much higher rating count (i.e. more people in these ages have rated books than those younger or older). Therefore, it seems that people in their 20s-50s are much more likely to rate books than those older or younger. 

**Questions**: Which books have the most ratings? Which books are most highly rated? Which books are most highly rated based on count?

We also checked to see which books had the most ratings (i.e. the most number of people rated that book). *Wild Animus* had the highest number of rating, with a count of 2,131. 

Using the `avg` function, we checked to see which books are most highly rated based on the average of all their ratings. We noticed that there were a lot of books that were rated 10. We added a `count` to the code to check to see how many people rated each book, and we noticed that the highest rated books had only 1 or 2 people rating them. Therefore, this rating does not accurately reflect the average rating of many people who have read the book. 

We then tried to analyze the ratings based on the amount of people that rated books. Using a `case` statement, we checked to see how many people gave each rating. 

	case when r.rating = 0 then 0
		when r.rating = 1 then 1
		...
		when r.rating = 10 then 10
	end as averageRating_band
	
We could see that the highest number of ratings was 0, with 716,109 people giving a rating of 0. There was also a large number of people who gave ratings from 8-10. 

**Question**: Which books are highly rated based on location? 

We checked to see ratings based on country and state. There did not seem to be any particular trend in the ratings of people based on location.

**Question**: What are the 10 hightest rated books for people between the ages of 30-45?

For this question, we limited the age to between 30 and 45. We also decided to do a few checks based on the number of people who rated books. 

By limiting the number of ratings to between 100 and 300, we saw that Harry Potter books were among the highest rated books between these ages. We also checked between various age groups, and Harry Potter still made the list. This makes sense, as the highest year in this dataset is 2004, and the Harry Potter books were coming out and very popular at this time.   
We also checked the Harry Potter books to see how popular they were in various languages, countries etc.

# Coming up With a More Accurate Measure for Rating

We wanted to try and combine the number of ratings per book and the average rating for that book into an accurate weighted rating to see which books are most popular. After trying a few variations that did not seem entirely accurate, we found a link online that included a formula for top rated movies in the IMDb database ([linked here](https://stats.stackexchange.com/questions/6418/rating-system-taking-account-of-number-of-votes)). Based on this formula, we created a formula for our books rating database, using 100 as the "minimum amount of ratings needed to qualify."

# Project Insights

### Book Title Length vs. Popularity

- In an article by Christopher Kokoski on writingbeginner.com, he states, “your book title length should be approximately 4 words to match best practices on the Amazon top 100 bestseller list. Fiction titles are often shorter than nonfiction titles. After 4-word titles, 6-word or 10-word titles were the most common in bestsellers for both fiction and nonfiction” [article link](https://www.writingbeginner.com/how-long-should-your-book-title-be/#:~:text=Your%20book%20title%20length%20should,for%20both%20fiction%20and%20nonfiction). 
- Based on this article, it seems that more popular books have shorter titles. This is because you want a title that can grab a reader’s attention and also keep their attention. Because of this, we thought that shorter titled books would be more popular than books with longer titles. In order to calculate popularity, we found an equation online which takes into account the rating and the number of people who have rated to determine a weighted average rating ([linked here](https://stats.stackexchange.com/questions/6418/rating-system-taking-account-of-number-of-votes)). When we visualized the data, it did not seem to prove that shorter titled books are more popular.
- In fact, there seems to be little to no correlation between length of title and book rating. The trendline is almost perfectly straight, with a slight upward trend toward longer titled books. 
- After doing a little more googling, we saw another article by Molly Blaisdell on authorlearningcenter.com which seems to break book length into two categories: fiction and nonfiction. The article states “Fiction titles tend to be much shorter than non-fiction titles, but only because non-fiction titles often include subtitles” [article link](https://www.authorlearningcenter.com/publishing/preparation/w/choosing-a-title/2214/book-title-what-s-a-good-length---article). 
- Based on this article, it is possible that the “straight line” trend of the ratings vs. title length analysis is due to the fact that longer titles are nonfiction and shorter titles are fiction and both are respectively popular. In order to get a more accurate reflection of the popularity of long vs. short titled books, we would need to filter for nonfiction vs. fiction books, respectively. However, one of the limitations of our data is that there is no genre or type listed for any of the books in the database. Therefore, we cannot split our dataset into these two categories

### Top 10 Most Highly Rated Books

- We used the same equation for weighted average to see which were the ten highest rated books from the dataset. Based on the results, the first five Harry Potter books are the top rated books. 
- Interestingly when viewing the book ratings for different age groups, Harry Potter retains a spot in the top ten list until we limit the age to people ~60 years old and older.
- Since this dataset was created in 2004, around the time the Harry Potter books were coming out, it stands to reason that this is why the Harry Potters are the highest rated books. The sixth and seventh books did not yet come out at this time so they do not appear in the dataset but we think it is safe to assume they would have also appeared in the top ten. 
- We also can see that Harry Potter and the Sorcerer’s stone appears twice in the results of this query, once as a paperback. From this we see some more limitations or our data. For one, some of the books in the dataset may include duplicates. Based on another query, we also saw that the dataset includes foreign versions of Harry Potter. Since there is no column for book type (i.e. hardcover vs. softcover) or book language (i.e. English or other), we cannot filter these duplicates out of our results. 
- We can also see that, since there are parentheses included in some of the titles listed in the “title” column, our previous query for title length may not either be accurate, as the length of some of the book titles will not be accurately reflected. (For ex: Harry Potter and the Sorcerer’s Stone (Book 1) will be grouped under a different title length than Harry Potter and the Sorcerer’s Stone (Harry Potter (Paperback)))

### Rating by Age

- We wanted to see how people of different ages rated. We visualized the data based on age and average rating. Based on the graph, there was a slight downward trend where it seems that younger people tend to rate higher than older people. However, the rating of older people were much more all over while the average rating of younger people were much more similar (closer to the trendline and less spread out). 
- We also checked to see how many people in age age category actually took part in rating. Based on the graph, a large number of people between the ages of 20-50 rated books, while much less people over 50 rated. We hypothesize that this may be due to the fact that younger people are probably more tech savvy and have a larger internet presence. As this dataset is from the early 2000s, we found a report online on internet usage [linked here](https://www.ntia.doc.gov/legacy/ntiahome/fttn00/falling.htm#f39). In this  this report, it is stated that people over the age of 50 had the lowest rate of internet usage in 2000, which seems to corroborate our hypothesis.  
- However, this is not absolutely conclusive that this is the reason why people in that age group rated more, as the information that we found about internet usage is not absolutely clear that of the 20-50 cohort had more internet users as a percentage of the total number of users, or if a higher percentage of people in the cohort used the internet. Presumably the two are correlated, but this is unproven since there can be many more members of the older cohort.   
- Furthermore, this does not help explain the slight differences in percentage or raters between the cohort of people in their 20’s vs. 30’s.

# Project Limitations

1. There is no column listing genre or type → we cannot analyze for non-fiction books vs. novels vs. educational books, etc. 
2. There is also no column listing the language the book is written in → we cannot filter for only English or other language books. Also, as a result, foreign versions of the same book may be appearing multiple times (this is especially relevant for the length-of-title search as the title length of a foreign version of a book may be different than the original version).
3. The user_age in this dataset has 110,762 null values which are a lot and it also contains irrelevant age of the users like 0, 110, 240. This seems to be due to user error during input. However, there does seem to be enough accurate ages to be able to filter out the definitely inaccurate ages and still be able to analyze the data. 
4. The years are only until 2004 so any books from then until the present would not show up in the dataset. 
