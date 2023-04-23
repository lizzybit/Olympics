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

# Calculate of Outliers Bound

## Age
a_q1 <- quantile(olympics$Age, 0.25)
a_q3 <- quantile(olympics$Age, 0.75)
a_iqr <- a_q3 - a_q1

a_small <- a_q1 - 1.5 * a_iqr
a_high <- a_q3 + 1.5 * a_iqr

a_small
a_high

## Weight:
w_q1 <- quantile(olympics$Weight, 0.25)
w_q3 <- quantile(olympics$Weight, 0.75)
w_iqr <- w_q3 - w_q1

w_small <- w_q1 - 1.5 * w_iqr
w_high <- w_q3 + 1.5 * w_iqr

w_small
w_high

## Height:
h_q1 <- quantile(olympics$Height, 0.25)
h_q3 <- quantile(olympics$Height, 0.75)
h_iqr <- h_q3 - h_q1

h_small <- h_q1 - 1.5 * h_iqr
h_high <- h_q3 + 1.5 * h_iqr

h_small
h_high

## Find the sport(s) with the youngest athletes: Insert into read me

young <- (olympics$Age < (a_q1 - 1.5 * a_iqr))

olympics$Sport[young]

olympics[young, "Sport"] %>% table()

## Find the sport(s) with the oldest athletes:
old <- (olympics$Age < (a_q3 + 1.5 * a_iqr))

olympics$Sport[old]

olympics[old, "Sport"] %>% table()

## Find the sport(s) with the lighest athletes:
light <- (olympics$Weight < (w_q1 - 1.5 * w_iqr))

olympics$Sport[light]

olympics[light, "Sport"] %>% table()

## Find the sport(s) with the heaviest athletes:
heavy <- (olympics$Weight < (w_q3 + 1.5 * w_iqr))

olympics$Sport[heavy]

olympics[heavy, "Sport"] %>% table()

## Find the sport(s) with the shortest athletes:
short <- (olympics$Height < (h_q1 - 1.5 * h_iqr))

olympics$Sport[short]

olympics[short, "Sport"] %>% table()

## Find the sport(s) with the tallest athletes:
tall <- (olympics$Height < (h_q3 + 1.5 * h_iqr))

olympics$Sport[tall]

olympics[tall, "Sport"] %>% table()

# Compare the Mean Age, Weight and Height for Male and Female Athletes
olympics %>%
  group_by(Sex) %>%
  summarize(mean_age = mean(Age, na.rm = TRUE),
            mean_height = mean(Height, na.rm = TRUE),
            mean_weight = mean(Weight, na.rm = TRUE))

## Check the minimum, average, maximum Age, Height, Weight of Athletes in Each Year
e <- olympics %>%
  group_by(Year) %>%
  summarize(min_age = min(Age),
            mean_age = mean(Age),
            max_age = max(Age),
            min_height = min(Weight),
            mean_height = mean(Weight),
            max_height = max(Weight),
            min_weight = min(Height),
            mean_weight = mean(Height),
            max_weight = max(Height))

print(e, n = nrow(f))
kable(e, format =  'markdown')

## Plot Height vs Weight using a Scatterplot
ggplot(olympics, aes(x = Height, y = Weight)) +
  geom_point(fill = "blue", colour = "black", shape = 21) +
  labs(x = "Height", 
       y = "Weight") +
  ggtitle("Scatterplot of Height vs Weight") +
  theme(plot.title = element_text(hjust = 0.5))

## Plot Height vs Weight using a Scatterplot and Hightlight each Sex

ggplot(olympics, aes(x = Height, y = Weight)) +
  geom_point(aes(color = Sex, shape = Sex, fill = Sex)) +
  scale_color_manual(values = c("blue", "orange")) +
  labs(x = "Height", y = "Weight", color = "Sex", shape = "Sex", fill = "Sex") +
  ggtitle("Scatterplot of Height vs Weight by Sex")+
  theme(plot.title = element_text(hjust = 0.5))



# Check for the number of unique values in each column
unique_counts <- sapply(olympics, function(x) length(unique(x)))
print(unique_counts)

#check the non-numerical columns
summary(olympics[,sapply(olympics, is.character)])

## Check the first record within the dataset for each Olympic Sport
f <- olympics %>%
  arrange(Year) %>%
  group_by(Sport) %>%
  select(Year, Sport) %>%
  slice(1)

print(f, n = nrow(e))
kable(f, format =  'markdown')

## group the data by country and medal type, and count the number of occurrences
medals_by_country <- olympics %>%
  group_by(NOC, Medal) %>%
  summarise(count = n()) %>%
  ungroup()

## calculate the total number of medals won by each country
total_medals_by_country <- medals_by_country %>%
  group_by(NOC) %>%
  summarise(total_medals = sum(count)) %>%
  arrange(desc(total_medals))

## display the top 10 countries with the most medals
g <- head(total_medals_by_country, 10)
kable(g, format =  'markdown')



