#Exploring raw data
# 1. understand the structure of your data
# 2. Look at your data
# 3. Visualize your data

#1. Understanding the structure of your data
#load the employee data 
emp<-read.csv("D:\\2018 R Introduction\\employee.csv", header = FALSE)
#view its class
class(emp)
#view its dimensions
dim(emp)
#view its column names
names(emp)
#view a summary
summary(emp)
#view structure
str(emp)

#2. Looking at your data
#view top
head(emp, n=3)
head(emp)
#view the bottom
tail(emp, n=2)
#View entire dataset (not recommended!)
print(emp)

#3. Visualize your data
#view histogram
hist(as.numeric(emp$V5))

#view plot of two variables
plot(emp$V3, emp$V5)


