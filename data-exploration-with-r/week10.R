# Warning: incomplete final line (move cursor in original raw data file)

# Set working directory where CSV file is located

setwd('E:/Analytics Engineering/')

# Question 1

Vote <- read.csv(file='political.csv', header=FALSE, sep=',')
names(Vote) <- c('State', 'Party', 'Age')

print(Vote)

fParty <- table(Vote$Party)
fParty

# To get similar output in SAS

p <- as.data.frame(fParty)
names(p)[1] <- 'Party'
p

# Question 2

library(sas7bdat)
Bicycle <- read.sas7bdat('bicycles.sas7bdat')

outp1 <- subset(Bicycle, (Model=='Road Bike' & UnitCost>2500 | Model=='Hybrid' & UnitCost > 660))
print(outp1)

# Question 3

Bank <- read.fwf('bankdata.txt', widths=c(15, 5, 6, 4), col.names=c('Name', 'Acct', 'Balance', 'Rate'))

Interest <- Bank$Balance * Bank$Rate

Bank <- data.frame(Bank, Interest)

print(Bank)
