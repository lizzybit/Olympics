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
library(mice)

###########################################################
###########################################################
## Import data
setwd("/Users/elizabeth/Documents/GitHub/Olympics")
getwd()

olympics <- read.csv("athlete_events.csv", header = TRUE)

a <- head(olympics)
kable(a, format =  'markdown')

dim(olympics)

str(olympics)



# Build a list of columns that will be used for imputation
cols_to_impute = c('Year', 'Age', 'Height', 'Weight')

# Create an imputation model using mice
imputation_model <- mice(olympics[, cols_to_impute])

# Impute missing values
imputed_data <- complete(imputation_model)

# Assign the imputed data back to the original DataFrame's columns
olympics[, cols_to_impute] <- imputed_data[, cols_to_impute]
###########################################################
###########################################################
## Clean Data

# 1. Find null values

b <- colSums(is.na(olympics))

kable(b, format =  'markdown')

# 2. Fill the missing values in the column Medal with string of 'DNW'
olympics$Medal[is.na(olympics$Medal)] <- "DNW"

sum(is.na(olympics$Medal))

# 3. Replace missing values in height, weight and age using mice
# Build a list of columns that will be used for imputation
cols_to_impute = c('Year', 'Age', 'Height', 'Weight')

# Create an imputation model using mice
imputation_model <- mice(olympics[, cols_to_impute])

# Impute missing values
imputed_data <- complete(imputation_model)

# Assign the imputed data back to the original DataFrame's columns
olympics[, cols_to_impute] <- imputed_data[, cols_to_impute]

c <- colSums(is.na(olympics))
kable(c, format =  'markdown')

# 4. Drop unused games column as it contains data already found in year and season column

olympics$Games <- NULL

###########################################################
###########################################################
## Exploratory Data Analysis

# 1. Look at the statistical summary of the numeric columns:
summary(olympics)

d <- summary(olympics[, sapply(olympics, is.numeric)])

kable(d, format =  'markdown')

# Plot the histograms for the age, weight and height values:

## Age:

ggplot(olympics, aes(x = Age)) +
  geom_histogram(binwidth = 1, fill = "blue", color = "black") +
  theme(plot.title = element_text(hjust = 0.5))+
  labs(title = "Distribution of Athlete Age",
       x = "Age",
       y = "Count")

## Weight:
ggplot(olympics, aes(x = Weight)) +
  geom_histogram(binwidth = 5, fill = "blue", color = "black") +
  theme(plot.title = element_text(hjust = 0.5))+
  labs(title = "Distribution of Athlete Weight",
       x = "Weight",
       y = "Count")

## Height:
ggplot(olympics, aes(x = Height)) +
  geom_histogram(binwidth = 3, fill = "blue", color = "black") +
  theme(plot.title = element_text(hjust = 0.5))+
  labs(title = "Distribution of Athlete Height",
       x = "Height",
       y = "Count")


# Create a boxplot of age and highlight the outliers

## Age
ggplot(olympics, aes(y = Age)) + 
  geom_boxplot(outlier.shape = 19, outlier.size = 3) +
  ylim(0, 100) +
  theme(plot.title = element_text(hjust = 0.5))+
  labs(title = "Age Distribution with Outliers",
       x = "",
       y = "Age")+
  scale_x_continuous(breaks = c())

## Weight:
ggplot(olympics, aes(y = Weight)) + 
  geom_boxplot(outlier.shape = 19, outlier.size = 3) +
  ylim(0, 220) +
  theme(plot.title = element_text(hjust = 0.5))+
  labs(title = "Weight Distribution with Outliers",
       x = "",
       y = "Weight")+
  scale_x_continuous(breaks = c())

## Height:
ggplot(olympics, aes(y = Height)) + 
  geom_boxplot(outlier.shape = 19, outlier.size = 3) +
  ylim(120, 230) +
  theme(plot.title = element_text(hjust = 0.5))+
  labs(title = "Height Distribution with Outliers",
       x = "",
       y = "Height")+
  scale_x_continuous(breaks = c())



