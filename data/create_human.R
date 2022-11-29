# Author: Baran Bayraktaroglu
# Date: 28.11.2022
# This file is for the data wrangling part of Assignment 4 of the course "PHD-302 Introduction to Open Data Science 2022"

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
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

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
write_csv(human, "data/human.csv")
