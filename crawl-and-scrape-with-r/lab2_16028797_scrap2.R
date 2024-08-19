# Defining packages
library('rvest')
library('RCurl')
library('data.table')
library('sqldf')
library('stringr')
library('httr')

# Reading website into text
web_page_text<-getURLContent('https://en.wikipedia.org/wiki/Food_pyramid_(nutrition)')

# Using nodes to collect words
Carbohydrate <- sum(str_count(web_page_text,'carbohydrate'))
Vitamin <- sum(str_count(web_page_text,'vitamin'))
Protein <- sum(str_count(web_page_text,'protein'))
Dairy <- sum(str_count(web_page_text,'dairy'))
Fruits <- sum(str_count(web_page_text,'fruits'))
Vegetables <- sum(str_count(web_page_text,'vegetables'))

nutrition <- c(Carbohydrate, Vitamin, Protein, Dairy, Fruits, Vegetables)
names <- c('Carbohydrate', 'Vitamin', 'Protein', 'Dairy', 'Fruits', 'Vegetables')
freq_nutrition <- data.frame(names, nutrition)
View(freq_nutrition)
write.csv(freq_nutrition, 'lab2_16028797_scrap_outcome2.csv')

# Plotting a bar chart
barplot(nutrition,main='The Frequency of Nutrition',xlab='Nutrional Value',names.arg=c('Carbohydrate', 'Vitamin', 'Protein', 'Dairy', 'Fruits', 'Vegetables'))
