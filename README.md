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
```
Output:
``` R
[1] "/Users/elizabeth/Documents/GitHub/Olympics"
```

``` R
olympics <- read.csv("athlete_events.csv", header = TRUE)
head(olympics)
```
### x.x Get Basic Information About the Data
``` R
head(olympics)
```


| ID|Name                     |Sex | Age| Height| Weight|Team           |NOC |Games       | Year|Season |City      |Sport         |Event                              |Medal |
|--:|:------------------------|:---|---:|------:|------:|:--------------|:---|:-----------|----:|:------|:---------|:-------------|:----------------------------------|:-----|
|  1|A Dijiang                |M   |  24|    180|     80|China          |CHN |1992 Summer | 1992|Summer |Barcelona |Basketball    |Basketball Men's Basketball        |NA    |
|  2|A Lamusi                 |M   |  23|    170|     60|China          |CHN |2012 Summer | 2012|Summer |London    |Judo          |Judo Men's Extra-Lightweight       |NA    |
|  3|Gunnar Nielsen Aaby      |M   |  24|     NA|     NA|Denmark        |DEN |1920 Summer | 1920|Summer |Antwerpen |Football      |Football Men's Football            |NA    |
|  4|Edgar Lindenau Aabye     |M   |  34|     NA|     NA|Denmark/Sweden |DEN |1900 Summer | 1900|Summer |Paris     |Tug-Of-War    |Tug-Of-War Men's Tug-Of-War        |Gold  |
|  5|Christine Jacoba Aaftink |F   |  21|    185|     82|Netherlands    |NED |1988 Winter | 1988|Winter |Calgary   |Speed Skating |Speed Skating Women's 500 metres   |NA    |
|  5|Christine Jacoba Aaftink |F   |  21|    185|     82|Netherlands    |NED |1988 Winter | 1988|Winter |Calgary   |Speed Skating |Speed Skating Women's 1,000 metres |NA    |

``` R
dim(olympics)
str(olympics)
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

### x.x Drop Unused Games Column as It Contains Data Already Found in Year and Season Column
``` R
olympics$Games <- NULL
R

