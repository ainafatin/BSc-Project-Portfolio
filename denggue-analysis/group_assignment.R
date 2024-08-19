# Set working directory
setwd("C:\\Downloads")

# installing packages
install.packages("sas7bdat")

# The dataset is cleaned and validated in SAS Studio
# The dataset is exported from SAS Studio to R for data exploration purposes

# Importing dataset
library(sas7bdat)
Denggue <- read.sas7bdat("denggue.sas7bdat")

# To validate the variable names inserted correctly
names(Denggue)

# importing library
library(ggplot2)

#1) Boxplot for Tahun (years)
boxplot(Denggue$Tahun)
# Results: There are two outliers in Tahun

#2) Boxplot for Minggu (week)
boxplot(Denggue$Minggu)
# Results: There are no outliers in Minggu

#3) Boxplot for Tempoh_Wabak_Berlaku__Hari_ (The Duration Denggue Happens)
boxplot(Denggue$Tempoh_Wabak_Berlaku__Hari_)
# Results: There are outliers in Tempoh_Wabak_Berlaku__Hari_

#4) Boxplot for Jumlah_Kes_Terkumpul (Total Number of Cases)
boxplot(Denggue$Jumlah_Kes_Terkumpul)
# Results: There are outliers in Jumlah_Kes_Terkumpul

#5
Negeri <- table(Denggue$Negeri)
Jumlah_Kes_Terkumpul <- table(Denggue$Jumlah_Kes_Terkumpul)
ggplot(data=Denggue, aes(x=Negeri, y=Jumlah_Kes_Terkumpul))+
  geom_bar(stat="identity")
#RESULT: Negeri Kelantan has the most dengue cases

#6
ggplot(data=Denggue, aes(x=Tahun, y=Jumlah_Kes_Terkumpul))+
  geom_bar(stat="identity")
#RESULT: Year 2014 has the most cases between the years 2010 to 2014

#7
x <- Denggue$Tempoh_Wabak_Berlaku__Hari_
y <- Denggue$Jumlah_Kes_Terkumpul
plot(x, y, main="Scatterplot for Jumlan kes terkumpul and Tempoh wabak berlaku",
     xlab="Tempoh Wabak Berlaku (Hari) ", ylab="Jumlah_Kes_Terkumpul ") 
#RESULT: There is a moderate positive relationship between Tempoh_Wabak_Berlaku__Hari_ (period disease happened) and Jumlah Kes (total cases)

#8
ggplot(data=Denggue, aes(x=Tahun, y=Tempoh_Wabak_Berlaku__Hari_))+
  geom_bar(stat="identity")
#RESULT: 2014 has the longest period of dengue happened (days)

#9
ggplot(data=Denggue, aes(x=Minggu, y=Jumlah_Kes_Terkumpul))+
  geom_bar(stat="identity")
#RESULT :Week 7, 2015 has the most cases
