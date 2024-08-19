# Extracting and Parsing Web Site Data (R)
# Using the example script

# Chosen website: https://www.thisisinsider.com/food
# Objective: To observe the places where food is being promoted and see how frequent it is mentioned in the website
# Desired Outcome: The frequency of dining places mention in the website such as bars, restaurants, cafes and fast food chains.

# install required packages

# bring packages into the workspace
library(RCurl)  # functions for gathering data from the web
library(XML)  # XML and HTML parsing
library(httr)

# gather home page for thisisinsider using RCurl package
web_page_text <- GET('https://www.thisisinsider.com/food')

# show the class of the R object and encoding
print(attributes(web_page_text))

# show the text including all of the HTML tags
print(web_page_text)

# parse the HTML DOM into an internal C data structure for XPath processing
web_page_tree <- htmlTreeParse(web_page_text, useInternalNodes = TRUE,
                               asText = TRUE, isHTML = TRUE)
print(attributes(web_page_tree))

# extract the text within paragraph tags using an XPath query
# XPath // selects nodes anywhere in the document  p for paragraph tags
web_page_content <- xpathSApply(web_page_tree, "//p/text()")
print(attributes(web_page_content))
print(head(web_page_content))
print(tail(web_page_content))

# send content to external text file for review
sink("text_file_for_review.txt")
print(web_page_content)
sink()