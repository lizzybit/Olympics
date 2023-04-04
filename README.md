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
> Input:
``` R
setwd("/Users/elizabeth/Documents/GitHub/Olympics")
getwd()
```
> Output:
``` R
"/Users/elizabeth/Documents/GitHub/Olympics"
```
> Input:
``` R
olympics <- read.csv("athlete_events.csv", header = TRUE)
```
### x.x Get Basic Information About the Data
> Input:
``` R
head(olympics)
```
> Output:

| ID|Name                     |Sex | Age| Height| Weight|Team           |NOC |Games       | Year|Season |City      |Sport         |Event                              |Medal |
|--:|:------------------------|:---|---:|------:|------:|:--------------|:---|:-----------|----:|:------|:---------|:-------------|:----------------------------------|:-----|
|  1|A Dijiang                |M   |  24|    180|     80|China          |CHN |1992 Summer | 1992|Summer |Barcelona |Basketball    |Basketball Men's Basketball        |NA    |
|  2|A Lamusi                 |M   |  23|    170|     60|China          |CHN |2012 Summer | 2012|Summer |London    |Judo          |Judo Men's Extra-Lightweight       |NA    |
|  3|Gunnar Nielsen Aaby      |M   |  24|     NA|     NA|Denmark        |DEN |1920 Summer | 1920|Summer |Antwerpen |Football      |Football Men's Football            |NA    |
|  4|Edgar Lindenau Aabye     |M   |  34|     NA|     NA|Denmark/Sweden |DEN |1900 Summer | 1900|Summer |Paris     |Tug-Of-War    |Tug-Of-War Men's Tug-Of-War        |Gold  |
|  5|Christine Jacoba Aaftink |F   |  21|    185|     82|Netherlands    |NED |1988 Winter | 1988|Winter |Calgary   |Speed Skating |Speed Skating Women's 500 metres   |NA    |
|  5|Christine Jacoba Aaftink |F   |  21|    185|     82|Netherlands    |NED |1988 Winter | 1988|Winter |Calgary   |Speed Skating |Speed Skating Women's 1,000 metres |NA    |

> Input:
``` R
dim(olympics)
```
> Output:
``` R
271116     15
```
> Input:
``` R
str(olympics)
```
> Output:
``` R
data.frame': 271116 obs. of 15 variables:
 $ ID    : int  1 2 3 4 5 5 5 5 5 5 ...
 $ Name  : chr  "A Dijiang" "A Lamusi" "Gunnar Nielsen Aaby" "Edgar Lindenau Aabye" ...
 $ Sex   : chr  "M" "M" "M" "M" ...
 $ Age   : int  24 23 24 34 21 21 25 25 27 27 ...
 $ Height: int  180 170 NA NA 185 185 185 185 185 185 ...
 $ Weight: num  80 60 NA NA 82 82 82 82 82 82 ...
 $ Team  : chr  "China" "China" "Denmark" "Denmark/Sweden" ...
 $ NOC   : chr  "CHN" "CHN" "DEN" "DEN" ...
 $ Games : chr  "1992 Summer" "2012 Summer" "1920 Summer" "1900 Summer" ...
 $ Year  : int  1992 2012 1920 1900 1988 1988 1992 1992 1994 1994 ...
 $ Season: chr  "Summer" "Summer" "Summer" "Summer" ...
 $ City  : chr  "Barcelona" "London" "Antwerpen" "Paris" ...
 $ Sport : chr  "Basketball" "Judo" "Football" "Tug-Of-War" ...
 $ Event : chr  "Basketball Men's Basketball" "Judo Men's Extra-Lightweight" "Football Men's Football" "Tug-Of-War Men's Tug-Of-War" ...
 $ Medal : chr  NA NA NA "Gold" ...
 ```

## x. Clean Data

### x.x Impute Missing Data
#### x.x.x Find Null Values
> Input:
``` R
colSums(is.na(olympics))
```
> Output:

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
> Input:
``` R
olympics$Medal[is.na(olympics$Medal)] <- "DNW"

sum(is.na(olympics$Medal))
```
#### x.x.x Replace Missing Values in Height, Weight and Age With Mean
> Input:
``` R
olympics$Height[is.na(olympics$Height)] <- mean(olympics$Height, na.rm = TRUE)
olympics$Weight[is.na(olympics$Weight)] <- mean(olympics$Weight, na.rm = TRUE)
olympics$Age[is.na(olympics$Age)] <- mean(olympics$Age, na.rm = TRUE)
```
#### x.x.x Comfirm That All Columns Are Imputed
> Input:
``` R
colSums(is.na(olympics))
```
> Output:

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

### x.x Drop Unused Games Column as It Contains Data Already Found in Year and Season Column
> Input:
``` R
olympics$Games <- NULL
```


## .x Exploratory Data Analysis
### x.x Look at the Statistical Summary of the Numeric Columns:
> Input:
``` R
summary(olympics[, sapply(olympics, is.numeric)])
```
>Output:

