# Defining packages
library(rvest)
library(RCurl)
library(data.table)
library(sqldf)
library(stringr)
library(httr)

# Reading and passing HTML nodes
web_page_content <- read_html('https://www.thisisinsider.com/food')
web_page_links <- html_nodes(web_page_content,'a')%>%html_attr('href')

# Transferring nodes into a dataframe
print(head(web_page_links))
links_level1 <- data.frame(web_page_links)
View(links_level1)

# Seperating internal and external links
copy_links_level1 <- links_level1
internal_links_level1 <- gsub("\\#.*","",links_level1$web_page_links)
internal_links_level1 <- gsub("\\http.*","",internal_links_level1)
external_links_level1 <- links_level1[links_level1 $ web_page_links %like% "^http",]
View(internal_links_level1)
View(external_links_level1)

# Setting link and empty new dataframe
main_link <- 'https://www.thisisinsider.com/'
links_level2 <- data.frame()

# Looping for internal links
for (i in 1:20){
  extention_link <- internal_links_level1[i]
  new_link <- paste(main_link,extention_link,sep="")
  web_page_content2 <- read_html(new_link)
  web_page_links2 <- html_nodes(web_page_content2,'a')%>%html_attr('href')
  new_links <- data.frame(web_page_links2)
  links_level2 <- rbind(new_links,links_level2)
}

# Transfering nodes into dataframe
print(head(links_level2))
links_level2 <- data.frame(links_level2)
View(links_level2)

# Seperating internal and external links
copy_links_level2 <- links_level2
internal_links_level2 <- gsub("\\#.*","",links_level2$web_page_links)
internal_links_level2 <- gsub("\\http.*","",internal_links_level2)
external_links_level2 <- links_level2[links_level2 $ web_page_links2 %like% "^http",]
View(internal_links_level2)
View(external_links_level2)

# Setting link and empty new dataframe
main_link <- 'https://www.thisisinsider.com/'
links_level3 <- data.frame()

# Looping for internal links
for (i in 1:20){
  extention_link <- internal_links_level2[i]
  new_link <- paste(main_link,extention_link,sep="")
  web_page_content3 <- read_html(new_link)
  web_page_links3 <- html_nodes(web_page_content3,'a')%>%html_attr('href')
  new_links <- data.frame(web_page_links3)
  links_level3 <- rbind(new_links,links_level3)
}

# Transfering nodes into dataframe
print(head(links_level3))
links_level2 <- data.frame(links_level3)
View(links_level3)

# Seperating internal and external links
copy_links_level3 <- links_level3
internal_links_level3 <- gsub("\\#.*","",links_level3$web_page_links)
internal_links_level3 <- gsub("\\http.*","",internal_links_level3)
external_links_level3 <- links_level3[links_level3 $ web_page_links3 %like% "^http",]
View(internal_links_level3)
View(external_links_level3)

# Combining into one variable
external_links <- rbind(external_links_level1,external_links_level2,external_links_level3)
internal_links <- rbind(internal_links_level1,internal_links_level2,internal_links_level3)

# Exporting into CSV
internal_links <- unique(internal_links)
external_links <- unique(external_links)
count <- data.frame(nrow(external_links),nrow(internal_links))
write.csv(internal_links,'lab2_16028797_crawl_internal.csv')
write.csv(external_links,'lab2_16028797_crawl_external.csv')
