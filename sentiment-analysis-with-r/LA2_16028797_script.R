library(tm)
library(stringr)
library(wordcloud)

# Set working directory
setwd("C:/Users/User/Documents/IST2234 WEB AND NETWORK ANALYTICS/Lab Assignment 2")

# Reading file
amazonreview <- read.table(file="amazon_alexa.tsv", header=TRUE, sep="\t", fill=TRUE)

# Changing variable name
names(amazonreview) <- c('Rating', 'Date', 'Variation', 'Verified_Reviews', 'Feedback')
names(amazonreview)

# Discovering common themes/words

# Reading review variable from the dataset
reviews <- (amazonreview$Verified_Reviews)

# Removing spaces, removing stop words, converting text to lower case
reviews <- tolower(reviews)
reviews <- removeWords(reviews, stopwords())
reviews <- stripWhitespace(reviews)

# Listing common words
reviewtext <- str_split(reviews, pattern="\\s+")
reviewtext <- unlist(reviewtext)
class(reviewtext)
str(reviewtext)
reviewtext
write.csv(reviewtext, "LA2_16028797_common.csv")

# Creating visualization from common words
wordcloud(reviewtext)
jpeg(file="commonwords.jpeg")
wordcloud(reviewtext, min.freq=2, random.order=FALSE, scale=c(3,0.5))
dev.off()

# Sentiment Analysis

# Seperating positive and negative words
positivewords <- scan("Hu_Liu_positive_word_list.txt", what="character", comment.char=";")
negativewords <- scan("Hu_Liu_negative_word_list.txt", what="character", comment.char=";")

# Match common words to positive and negative words
sum(!is.na(match(reviewtext, positivewords)))
sum(!is.na(match(reviewtext, negativewords))) 

# Calculate positive and negative words for each review
score <- sum(!is.na(match(reviewtext, positivewords))) - sum(!is.na(match(reviewtext, negativewords)))
score
hist(score)

# Listing words seperated into positive and negative words
write.csv(reviewtext, "LA2_16028797_sentiment.csv")

# Create word cloud from sentiment analysis
wordcloud(reviewtext)
jpeg(file="sentiment.jpeg")
dev.off()
