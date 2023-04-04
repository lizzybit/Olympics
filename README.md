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

### .x Find null values
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

### .x Fill the missing values in the column Medal with string of 'NA'
``` R
olympics$Medal[is.na(olympics$Medal)] <- "NA"

sum(is.na(olympics$Medal))
```
### .x Replace missing data:
Use 'mice' to impute based on columns Year, Age, Height, Weight

