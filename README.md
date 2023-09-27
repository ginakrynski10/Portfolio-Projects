# Analytics Portfolio Project Descriptions
## SQL Projects
### Recipe Sharing Database
**Code**: [RecipeSharing.sql](RecipeSharing.sql) \
&nbsp;  
**Description**: The Recipe Sharing database is designed to be the back-end of a recipe sharing web application. I practiced creating entity relationship diagrams (ERDs), working with tables, joins, views, and mock data. I created various stored procedures to perform common functions such as user login, change password, and add/update/delete procedures for each table. \
&nbsp;  
**Technology**: SQL Server
### Weight Training Database
**Code**: [WeightTraining.sql](WeightTraining.sql) \
&nbsp;  
**Description**: The Weight Training database is designed to track users exercises, their exercise plans, and the exercise plan details. I practiced creating tables, working with joins, mock data, and creating stored procedures for common functions. \
&nbsp;  
**Technology**: SQL Server
### SQL Query Practice
**Code**: [PropertyQueries.sql](PropertyQueries.sql) \
&nbsp;  
**Description**: This file contains several queries created to practice querying from a Propterty database. The database contains tables such as Owner, PropertyOwners, Property, PropertyRental, RentalData, and RentalPayment. \
&nbsp;  
**Technology**: SQL Server
## Python Projects
### Disney Movie Analysis
**Code**: [FinalMovieAnalysis.ipynb](FinalMovieAnalysis.ipynb) \
&nbsp;  
**Description**: I created FinalMovieAnalysis.ipynb as my contribution to a group project. Other analyses were performed by other members of my group. We then synthesized our analyses into a written report that we presented to our class. \
&nbsp;  
The first part of this analysis uses data about Disney movies from IMDB. Data cleaning was performed before beginning the exploratory data analysis. The EDA was used to identify films of interest for a report that looked into why Disney chose to remake certain movies over others, such as their many live action remakes of popular animated movies. \
&nbsp;  
The second part of this analysis uses data scraped from Reddit forums where several of the movies mentioned in the report are discussed by Reddit users. Then,  a sentiment analyzer function was created using the TFIDVectorizer function from the sklearn package to measure the amount of positive vs negative words from each data entry. The sentiment analyzer function is used to calculate the percentage of positive comments for each movie discussed in the report \
&nbsp;  
**Libraries used**: pandas, numpy, pylab, seaborn, matplotlib.pyplot, statistics, requests, sklearn
### Football Web Scraping
**Code**: [FootballWebScraping.ipynb](FootballWebScraping.ipynb) \
&nbsp;  
**Description**: This project scrapes data from [this website](https://probabilityfootball.com/picks.html?1487349677&username=AVERAGES&weeknum=5) about the 2008 NFL season, which includes information such as the home team, away team, winner, and the percentage of experts that predicted each team winning. The goal of this project was to determine if the experts prediction accuracy was equal to 50% or greater than 50% using a 1 sample t-test. I created a function to scrape the important data from the source html and reformat it into a cleaner looking table that could be used in the analysis. I first tested the function with a subset of data from week 1 of the 2008 NFL season. Then, I used a loop to apply the function to each week of the 2008 season. Finally, a 1 sample t-test was performed to answer the original question of the experts prediction accuracy. \
&nbsp;  
**Libraries Used**: requests, re, pandas, scipy\

## R Projects
### Crime Analysis
**Code**: [CrimeAnalysis.R](CrimeAnalysis.R) \
&nbsp;

**Description**: This analysis was created for a report that investigated the impact of the COVID-19 pandemic on crime rates in the City of Chicago. The main dataset used for the analysis is the Crimes 2001-Present that can be found on the Chicago Data Portal Website. The final report including all plots created and finished analyses can be read by downloading [CrimeAnalysisFinalReport.docx](CrimeAnalysisFinalReport.docx) \
&nbsp;  
**Libraries Used**: tidyverse, jsonlite, knitr, kableExtra, scales, maps, rgdal, maptools, ggthemes, broom, gridExtra

