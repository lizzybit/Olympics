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


## Import data
``` R
setwd("/Users/elizabeth/Documents/GitHub/Olympics")
getwd()

olympics <- read.csv("athlete_events.csv", header = TRUE)
head(olympics)
```

## Clean Data
### .x Replace missing data:
Use 'mice' to impute based on columns Year, Age, Height, Weight

|column |num_na |
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
