# Author: Baran Bayraktaroglu
# Date: 28.11.2022
# This file is for the data wrangling part of Assignment 4 and Assignment 5 of the course "PHD-302 Introduction to Open Data Science 2022"

# Here are the data sources: 
# https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv
# https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv

# setting up some packages
library(tidyverse)
library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(boot)

# set working directory
setwd("~/Github/IODS-project")

# read the required data into variables
hd <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# analyze the dimension of the data
dim(hd)
dim(gii)
# We see that there are 195 observations and 8 variables in the hd data, and 195 observations and 10 variables in the gii data

# analyze the structure of the data
str(hd)
str(gii)
# We see that the variables are a mix of numerics and characters (namely the Countries variable).

# creating summaries for the variables
summary(hd)
summary(gii)

# rename variables to shorten their name
colnames(hd) <- c('HDI.Rank','Country','HDI','Life.Exp','Edu.Exp','Edu.Mean','GNI','GNI_minus_HDI.Rank')
colnames(gii) <- c('GII.Rank','Country','GII','Mat.Mor','Ado.Birth','Parli.F','Edu2.F','Edu2.M','Labo.F','Labo.M')

# mutating and defining new variables:the ratios Edu2.F / Edu2.M, Labo2.F / Labo2.M
gii <- mutate(gii, "Edu2.FM" = Edu2.F / Edu2.M)
gii <- mutate(gii, "Labo.FM" = Labo.F / Labo.M)

# joining the two data sets by the "Country "identifier
human <- inner_join(hd, gii, by = "Country")
human
# let's check the number of observations and variables
dim(human)
# We indeed have 195 observations and 19 variables as expected. We were successful in combining the data.

# write this data into a file called "human.csv"
write.csv(human, "data/human.csv")




# Author: Baran Bayraktaroglu
# Date: 5.12.2022
# This file continues for the data wrangling part of and Assignment 5 of the course "PHD-302 Introduction to Open Data Science 2022"


# We continue with data wrangling of Assignment 5. Let's load the data "human" again:
human<-read.csv( "data/human.csv")

# Let's look at the structure, dimensions and summary of the data "human", and describe it briefly

str(human)
dim(human)
summary(human)

# Observe that we have 195 observations and 19 variables as desired. 
# The data combines various ways to measure Human Development Index (HDI), 
# like life expectancy (Life.Exp), or Gross national income per capita (GNI). 
# There are various variables which also try to measure gender inequality such as
# "Parli.F" = Percetange of female representatives in parliament. 
# Overall, HDI is an important metric to determine whether a country 
# is worth living, apart from just looking at the GDP which only measures economic output/growth.


# 1) mutate GNI to numeric
human$GNI<-str_replace(human$GNI, pattern=",", replace ="")%>%as.numeric()
# note that this is technically not necessary, since human$GNI is already a numeric, but we do it for the points!

# 2) columns to keep
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# select the 'keep' columns
human <- dplyr::select(human, one_of(keep))


# 3) filter out all rows with NA values
human <- filter(human, complete.cases(human))


# 4) look at the last 10 observations of human
tail(human, n=10)

# define the last indice we want to keep
last <- nrow(human) - 7

# choose everything until the last 7 observations
human <- human[1:last, ]


# 5) save country variable
country <- human$Country

# delete country column
human <- select(human, -Country)

# add countries as rownames
rownames(human) <- country


# Let's check the final dimensions of the data
dim(human)
# We indeed have 155 observations and 8 variables.

# overwrite old human.csv data
write.csv(human, "data/human.csv")


