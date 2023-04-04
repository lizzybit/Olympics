###########################################################
###########################################################
## Download and install all required packages
library(readr)
library(sqldf)
library(calibrate)
library(repr)
library(tidyverse)
library(readxl)
library(knitr)
library(rmarkdown)

###########################################################
###########################################################
## Import data
setwd("/Users/elizabeth/Documents/GitHub/Olympics")
getwd()

olympics <- read.csv("athlete_events.csv", header = TRUE)

head(olympics)

dim(olympics)

str(olympics)

###########################################################
###########################################################
## Clean Data

# 1. Find null values

colSums(is.na(olympics))


# 2. Fill the missing values in the column Medal with string of 'DNW'
olympics$Medal[is.na(olympics$Medal)] <- "DNW"

sum(is.na(olympics$Medal))

# 3. Replace missing values in height, weight and age with mean
olympics$Height[is.na(olympics$Height)] <- mean(olympics$Height, na.rm = TRUE)
olympics$Weight[is.na(olympics$Weight)] <- mean(olympics$Weight, na.rm = TRUE)
olympics$Age[is.na(olympics$Age)] <- mean(olympics$Age, na.rm = TRUE)

colSums(is.na(olympics))

# 4. Drop unused games column as it contains data already found in year and season column

olympics$Games <- NULL


###########################################################
###########################################################
## Exploratory Data Analysis


