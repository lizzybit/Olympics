# Olympics


## Download and install all required packages
``` R
install.packages("readr")
install.packages("sqldf")
install.packages("calibrate")
install.packages("repr")
install.packages("tidyverse")
install.packages("readxl")
install.packages("mice")
library(readr)
library(sqldf)
library(calibrate)
library(repr)
library(tidyverse)
library(readxl)
library(mice)
```


## x. Import data
``` R
setwd("/Users/elizabeth/Documents/GitHub/Olympics")
getwd()

olympics <- read.csv("athlete_events.csv", header = TRUE)
head(olympics)
```

## x. Clean Data

### x.x Impute Missing Data
#### x.x.x Find Null Values
``` R
null_values <- colSums(is.na(olympics))

kable(null_values, format =  'markdown')
```
-- Output
|column |null   |
|:------|------:|
|ID     |      0|
|Name   |      0|
|Sex    |      0|
|Age    |   9474|
|Height |  60171|
|Weight |  62875|
|Team   |      0|
|NOC    |      0|
|Games  |      0|
|Year   |      0|
|Season |      0|
|City   |      0|
|Sport  |      0|
|Event  |      0|
|Medal  | 231333|

#### x.x.x Fill the Missing Values in the Column Medal With String of ‘DNW'
Medals have a NULL value in about 231,333 rows. This is because only the top 3 athletes in each sport can win medals. These missing values are therefore replaceds by 'Did not win' or 'DNW'.
``` R
olympics$Medal[is.na(olympics$Medal)] <- "DNW"

sum(is.na(olympics$Medal))
```
#### x.x.x Replace Missing Values in Height, Weight and Age With Mean
``` R
olympics$Height[is.na(olympics$Height)] <- mean(olympics$Height, na.rm = TRUE)
olympics$Weight[is.na(olympics$Weight)] <- mean(olympics$Weight, na.rm = TRUE)
olympics$Age[is.na(olympics$Age)] <- mean(olympics$Age, na.rm = TRUE)
```
#### x.x.x Comfirm That All Columns Are Imputed
``` R
null_values <- colSums(is.na(olympics))
kable(null_values, format =  'markdown')

null_values <- colSums(is.na(olympics))
kable(null_values, format =  'markdown')
```
-- Output
|column |null   |
|:------|------:|
|ID     |  0|
|Name   |  0|
|Sex    |  0|
|Age    |  0|
|Height |  0|
|Weight |  0|
|Team   |  0|
|NOC    |  0|
|Games  |  0|
|Year   |  0|
|Season |  0|
|City   |  0|
|Sport  |  0|
|Event  |  0|
|Medal  |  0|

### Drop Unused Games Column as It Contains Data Already Found in Year and Season Column
``` R
olympics$Games <- NULL
R
