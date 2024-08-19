# Matrix
A = matrix(c(2,4,3,5,1,7), 
           nrow=2, 
           ncol=3, 
           byrow=TRUE)

# Understanding data structure

# Load employee data
emp <- read.csv("path", header = FALSE)

# View class
class(emp) # data.frame

# view dimensions
dim(emp) # 6 5

# view column names
names(emp) # "V1" "V2" "V3" "V4" "V5"

# view a summary
summary(emp) # overview of entire data structure

# view structure
str(emp) # format of data structure

# Looking at data

# view data
head(emp, n=3) # first three observations
head(emp) # all the observations

# view bottom
tail(emp, n=2) # last two observations

# view entire dataset
print(emp) # not recommended to show all

# Visualizing data

# view histogram
hist(as.numeric(emp$v5))

# view plot of two variables
plot(emp$v3, emp$v5)