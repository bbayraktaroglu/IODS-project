# Author: Baran Bayraktaroglu
# Date: 18.11.2022
# This file is for the data wrangling part of Assignment 3 of the course "PHD-302 Introduction to Open Data Science 2022"
# Here is the data source: https://archive.ics.uci.edu/ml/datasets/Student+Performance

# setting up some packages
library(tidyverse)
library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(boot)

# set working directory
setwd("/Users/barancik/Github/IODS-project/data")

# read the required data into variables
math <- read.table("student-mat.csv", sep = ";" , header = TRUE)
por <- read.table("student-por.csv", sep = ";", header = TRUE)

# analyze the dimension of the data
dim(math)
dim(por)
# We see that there are 395 observations and 33 variables in the math data, and 649 observations and 33 variables in the por data

# analyze the structure of the data
str(math)
str(por)
# We see that the variables are a mix of integers and characters. Some variables are binary answers like yes/no.

# give the columns that vary in the two data sets
free_cols <- c("failures", "paid", "absences", "G1", "G2", "G3")
free_cols
# the rest of the columns are common identifiers used for joining the data sets
join_cols <- setdiff(colnames(por), free_cols)

# join the two data sets by the selected identifiers
math_por <- inner_join(math, por, by = join_cols)

# look at the column names of the joined data set
# names(math_por) also works since data frames are columns in R
colnames(math_por)

# glimpse at the joined data set
glimpse(math_por)

# look at the dimension and the structure
dim(math_por)
str(math_por)
# There are 370 observations and 39 variables. We see that failures, paid, absences, G1, G2, G3 data are counted twice: once for math, once for por data

# Here is the code for getting rid of the duplicate data as the if-else structure from the Exercise:
# print out the column names of 'math_por'
colnames(math_por)

# create a new data frame with only the joined columns
alc <- select(math_por, all_of(join_cols))

# print out the columns not used for joining (those that varied in the two data sets)
free_cols

# for every column name not used for joining...
for(col_name in free_cols) {
  # select two columns from 'math_por' with the same original name
  two_cols <- select(math_por, starts_with(col_name))
  # select the first column vector of those two columns
  first_col <- select(two_cols, 1)[[1]]
  
  # then, enter the if-else structure!
  # if that first column vector is numeric...
  if(is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    alc[col_name] <- first_col
  }
}

# glimpse at the new combined data
glimpse(alc)
# We have 370 observations, 33 variables. We have successfully eliminated the duplicate variables.

# define a new column alc_use by taking the average of weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# define a new logical column 'high_use', which is true for students for which 'alc_use' is greater than 2, and false otherwise
alc <- mutate(alc, high_use = (alc_use > 2))

# glimpse at the new data
glimpse(alc)
# We now have 370 observations with 35 variables. We have successfully put alc_use and high_use into the dataset

# set working directory
setwd("/Users/barancik/Github/IODS-project/data")
# write this data into a file called "alc.csv"
write_csv(alc, "alc.csv")
