# Author: Baran Bayraktaroglu
# Date: 6.12.2022
# This file is for the data wrangling part of Assignment 6 of the course "PHD-302 Introduction to Open Data Science 2022"

# Here are the data sources: 
# https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt
# https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt

# setting up some packages
library(tidyverse)
library(dplyr)
library(ggplot2)
library(tidyr)

# set working directory
setwd("~/Github/IODS-project")

# 1) read the required data into variables
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

# saving the data into local folder
write_csv(BPRS, "data/BPRS.csv")
write_csv(RATS, "data/RATS.csv")

# column names
colnames(BPRS)
colnames(RATS)

# dimensions of the datasets
dim(BPRS)
dim(RATS)

# structures of the datasets
str(BPRS)
str(RATS)

# summaries of the datasets
summary(BPRS)
summary(RATS)

# 2)  Convert the categorical variables of both data sets to factors. (1 point)

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# 3) Convert the data sets to long form. Add a week variable to BPRS and a Time variable to RATS. (1 point)

BPRSL <-  pivot_longer(BPRS, cols=-c(treatment,subject),names_to = "weeks",values_to = "bprs") %>% arrange(weeks)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))
rm(BPRS)

RATSL <- pivot_longer(RATS, cols=-c(ID,Group), names_to = "WD",values_to = "Weight") %>%  mutate(Time = as.integer(substr(WD,3,4))) %>% arrange(Time)

# 4) Now, take a serious look at the new data sets and compare them with their wide form versions: 
# Check the variable names, view the data contents and structures, and create some brief summaries of the variables. Make sure that you understand the point of the long form data and the crucial difference between the wide and the long forms before proceeding the to Analysis exercise. (2 points)

# checking the columns of the long data
colnames(BPRSL)
colnames(RATSL)

# dimensions of the long data
dim(BPRSL)
dim(RATSL)

# structure of the long data
str(BPRSL)
str(RATSL)

# summaries of the long data
summary(BPRSL)
summary(RATSL)

# We see that the long data format collects the week/time data into a single column, for different treatment/subject/ID/Group, 
# i.e. for each treatment+subject combination in the BPRS data, we collect all of the week data in a single column
# To obtain the number of observations in the long data, the number of observations in the wide will be multiplied by the number of weeks/time variables
# In the case of BPRS, we have 9 weeks. So 40*9=360 observations in the long data.


