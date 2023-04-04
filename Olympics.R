###########################################################
###########################################################
## Download and install all required packages
install.packages("readr")
install.packages("sqldf")
install.packages("calibrate")
install.packages("repr")
install.packages("tidyverse")
install.packages("readxl")
install.packages("knitr")
library(readr)
library(sqldf)
library(calibrate)
library(repr)
library(tidyverse)
library(readxl)
library(knitr)

###########################################################
###########################################################
## Import data
setwd("/Users/elizabeth/Documents/GitHub/Olympics")
getwd()

olympics <- read.csv("athlete_events.csv", header = TRUE)
head(olympics)
str(olympics)

###########################################################
###########################################################
## Clean Data

# 1. Find null values

null_values <- colSums(is.na(olympics))

kable(null_values, format =  'markdown')

# 2. Fill the missing values in the column Medal with string of 'NA'
olympics$Medal[is.na(olympics$Medal)] <- "NA"

sum(is.na(olympics$Medal))
