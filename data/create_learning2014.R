# Author: Baran Bayraktaroglu
# Date: 14.11.2022
# This file is for the data wrangling part of Assignment 2 of the course "PHD-302 Introduction to Open Data Science 2022"
# Here is the data source: http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt

# read the learning2014 data from the source into R
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# analyze the dimension of the data
dim(lrn14)
# We see that there are 183 observations and 60 variables.

# analyze the structure of the data
str(lrn14)
# We see that almost all of the variables are integers, except the variable 'gender'.

# scale the attitude variable by 10 to put it in the scale 1-5, since it is a sum of 10 numbers between 1-5
lrn14$attitude <- lrn14$Attitude / 10

# define deep_questions variable as a vector of questions related to deep learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
# And we combine this data by taking their mean to form the 'deep' column
lrn14$deep <- rowMeans(lrn14[, deep_questions])

# do similar computations for surface_questions & strategic_questions
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
lrn14$surf <- rowMeans(lrn14[, surface_questions])

strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
lrn14$stra <- rowMeans(lrn14[, strategic_questions])

# keep only the variables related to the ones listed in the Assignment
learning2014 <- lrn14[, c("gender","Age","attitude", "deep", "stra", "surf", "Points")]

# rename the variables to fit the names given in the Assignment, i.e. just make the first letter small
colnames(learning2014)[2] <- "age"
colnames(learning2014)[7] <- "points"

# Finally we keep the data with positive exam points, i.e. we exclude the ones with zero points
learning2014 <- filter(learning2014, points >0)

# check how many observations and variables the data has
str(learning2014)
# We indeed have 166 observations and 7 variables as expected

# write this data into a file called "learning2014.csv"
write_csv(learning2014, "learning2014.csv")

# The following is just to check that we can read the data
learning2014_read <- read_csv("learning2014.csv")

# compare the data we wrote and the data we read
str(learning2014_read)
head(learning2014_read)
# We again have 166 observations and 7 variables, as desired. 
