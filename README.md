# Olympics

## Download and install all required packages
``` {r}
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
``` {r}
setwd("/Users/elizabeth/Documents/GitHub/Olympics")
getwd()
```
> Output:
``` {r}
"/Users/elizabeth/Documents/GitHub/Olympics"
```
> Input:
``` {r}
olympics <- read.csv("athlete_events.csv", header = TRUE)
```
### x.x Get Basic Information About the Data
> Input:
``` {r}
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
``` {r}
dim(olympics)
```
> Output:
``` {r}
271116     15
```
> Input:
``` {r}
str(olympics)
```
> Output:
``` {r}
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
``` {r}
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
```{r}
olympics$Medal[is.na(olympics$Medal)] <- "DNW"

sum(is.na(olympics$Medal))
```
#### Replace Missing Values in Height, Weight and Age Using Mice
Build a list of columns that will be used for imputation
> Input:
``` {r}
cols_to_impute = c('Year', 'Age', 'Height', 'Weight')
```
Create an imputation model using mice
> Input:
```{r}
imputation_model <- mice(olympics[, cols_to_impute])
``` 
Impute missing values
> Input:
```{r}
imputed_data <- complete(imputation_model)
``` 
Assign the imputed data back to the original DataFrame's columns
> Input:
```{r}
olympics[, cols_to_impute] <- imputed_data[, cols_to_impute]
```
#### x.x.x Comfirm That All Columns Are Imputed
> Input:
``` {r}
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
``` {r}
olympics$Games <- NULL
```


## .x Exploratory Data Analysis
### x.x Look at the Statistical Summary of the Numeric Columns:
> Input:
``` {r}
summary(olympics[, sapply(olympics, is.numeric)])
```
>Output:

|      ID       |     Age      |    Height    |    Weight    |     Year    |
|:--------------|:-------------|:-------------|:-------------|:------------|
|Min.   :     1 |Min.   :10.00 |Min.   :127.0 |Min.   : 25.0 |Min.   :1896 |
|1st Qu.: 34643 |1st Qu.:22.00 |1st Qu.:170.0 |1st Qu.: 63.0 |1st Qu.:1960 |
|Median : 68205 |Median :25.00 |Median :175.3 |Median : 70.7 |Median :1988 |
|Mean   : 68249 |Mean   :25.56 |Mean   :175.3 |Mean   : 70.7 |Mean   :1978 |
|3rd Qu.:102097 |3rd Qu.:28.00 |3rd Qu.:180.0 |3rd Qu.: 75.0 |3rd Qu.:2002 |
|Max.   :135571 |Max.   :97.00 |Max.   :226.0 |Max.   :214.0 |Max.   :2016 |

### x.x Plot the histograms for the age, weight and height values:

*Age*

> Input:
``` {r}
ggplot(olympics, aes(x = Age)) +
  geom_histogram(binwidth = 1, fill = "blue", color = "black") +
  labs(title = "Distribution of Athlete Age",
       x = "Age",
       y = "Count")
```
> Output:

<p align = "center">
  <img src="https://user-images.githubusercontent.com/128324837/229913751-3af2ebd5-9877-4aa5-82da-5054ee04dfac.png">
</p>

*Weight:*

> Input:
``` {r}
ggplot(olympics, aes(x = Weight)) +
  geom_histogram(binwidth = 5, fill = "blue", color = "black") +
  labs(title = "Distribution of Athlete Weight",
       x = "Weight",
       y = "Count")
```
<p align = "center">
  <img src="https://user-images.githubusercontent.com/128324837/229913791-cf69ec70-8dda-432b-b696-78b04f44e2b8.png">
</p>

*Height*

> Input:
``` {r}
ggplot(olympics, aes(x = Height)) +
  geom_histogram(binwidth = 3, fill = "blue", color = "black") +
  labs(title = "Distribution of Athlete Height",
       x = "Height",
       y = "Count")
```
<p align = "center">
  <img src="https://user-images.githubusercontent.com/128324837/229913813-a9596601-5b8b-49e3-aebd-ded84133643a.png">
</p>

### x.x Create a boxplot of age and highlight the outliers

*Age*

> Input:
``` {r}
ggplot(olympics, aes(y = Age)) + 
  geom_boxplot(outlier.shape = 19, outlier.size = 3) +
  ylim(0, 100) +
  theme(plot.title = element_text(hjust = 0.5))+
  labs(title = "Age Distribution with Outliers",
       x = "",
       y = "Age")+
  scale_x_continuous(breaks = c())
```
> Output:
<p align = "center">
  <img src="https://user-images.githubusercontent.com/128324837/229929140-81fee535-97af-4314-8827-ca295524f224.png">
</p>

*Weight*

> Input:
``` {r}
ggplot(olympics, aes(y = Weight)) + 
  geom_boxplot(outlier.shape = 19, outlier.size = 3) +
  ylim(0, 220) +
  theme(plot.title = element_text(hjust = 0.5))+
  labs(title = "Weight Distribution with Outliers",
       x = "",
       y = "Weight")+
  scale_x_continuous(breaks = c())
```
> Output:
<p align = "center">
  <img src="https://user-images.githubusercontent.com/128324837/229929172-5deda8ea-b4f2-4cb8-b325-bccd8ac72de2.png">
</p>

*Height:*

> Input:
``` {r}
ggplot(olympics, aes(y = Height)) + 
  geom_boxplot(outlier.shape = 19, outlier.size = 3) +
  ylim(120, 230) +
  theme(plot.title = element_text(hjust = 0.5))+
  labs(title = "Height Distribution with Outliers",
       x = "",
       y = "Height")+
  scale_x_continuous(breaks = c())
  ```
> Output:
<p align = "center">
  <img src="https://user-images.githubusercontent.com/128324837/229929189-bd434bb4-7b62-4f82-bd6c-3024961439d8.png">
</p>

### .x Calculate Outliers Bound
*Age*
> Input:
``` {r}
a_q1 <- quantile(olympics$Age, 0.25)
a_q3 <- quantile(olympics$Age, 0.75)
a_iqr <- a_q3 - a_q1

a_small <- a_q1 - 1.5 * a_iqr
a_high <- a_q3 + 1.5 * a_iqr

a_small
a_high
  ```
> Output:
``` {r}
> a_small
 25% 
10.5 
> a_high
 75% 
38.5 
```
*Weight*
> Input:
``` {r}
w_q1 <- quantile(olympics$Weight, 0.25)
w_q3 <- quantile(olympics$Weight, 0.75)
w_iqr <- w_q3 - w_q1

w_small <- w_q1 - 1.5 * w_iqr
w_high <- w_q3 + 1.5 * w_iqr

w_small
w_high
```
> Output:
``` {r}
> w_small
 25% 
31.5 
> w_high
  75% 
107.5 
```

*Height:*

> Input:
``` {r}
h_q1 <- quantile(olympics$Height, 0.25)
h_q3 <- quantile(olympics$Height, 0.75)
h_iqr <- h_q3 - h_q1

h_small <- h_q1 - 1.5 * h_iqr
h_high <- h_q3 + 1.5 * h_iqr

h_small
h_high
``` 
> Output:
``` {r}
> h_small
25% 
147 
> h_high
75% 
203 
``` 
