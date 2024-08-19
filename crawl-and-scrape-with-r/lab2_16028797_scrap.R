# Defining packages
library('rvest')
library('RCurl')
library('data.table')
library('sqldf')
library('stringr')
library('httr')

# Reading website into text
web_page_text<-getURLContent('https://www.thisisinsider.com/food')

# Using nodes to collect words
Bars <- sum(str_count(web_page_text,'bars'))
Restaurants <- sum(str_count(web_page_text,'restaurants'))
Cafes <- sum(str_count(web_page_text,'cafes'))
Fast_food <- sum(str_count(web_page_text,'fast food'))

places <- c(Bars, Restaurants, Cafes, Fast_food)
names <- c('Bars', 'Restaurants', 'Cafes', 'Fast Food')
freq_places <- data.frame(names, places)
View(freq_places)
write.csv(freq_places, 'lab2_16028797_scrap_outcome.csv')

# Plotting a bar chart
barplot(places,main='The Frequency of Places',xlab='Places',names.arg=c('Bars', 'Restaurants', 'Cafes', 'Fast Food'))
