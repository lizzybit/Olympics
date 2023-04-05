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
#### x.x.x Find the Sport(s) With the Youngest Athletes:
> input
``` {r}
young <- (olympics$Age < (a_q1 - 1.5 * a_iqr))

olympics$Sport[young]

olympics[young, "Sport"] %>% table()
```
> Output:
``` {r}
Gymnastics 
         1         
```
####  x.x.x Find the Sport(s) With the Oldest Athletes:
> input
``` {r}
old <- (olympics$Age < (a_q3 + 1.5 * a_iqr))

olympics$Sport[old]

olympics[old, "Sport"] %>% table()
```
> Output:
``` {r}

              Aeronautics             Alpine Skiing                  Alpinism 
                        1                      8805                        17 
                  Archery          Art Competitions                 Athletics 
                     2060                      1393                     38262 
                Badminton                  Baseball                Basketball 
                     1453                       887                      4528 
            Basque Pelota          Beach Volleyball                  Biathlon 
                        2                       554                      4857 
                Bobsleigh                    Boxing                  Canoeing 
                     2870                      6031                      6120 
                  Cricket                   Croquet      Cross Country Skiing 
                       22                        13                      9080 
                  Curling                   Cycling                    Diving 
                      385                     10750                      2831 
            Equestrianism                   Fencing            Figure Skating 
                     4537                      9816                      2273 
                 Football          Freestyle Skiing                      Golf 
                     6713                       929                       212 
               Gymnastics                  Handball                    Hockey 
                    26515                      3648                      5390 
               Ice Hockey              Jeu De Paume                      Judo 
                     5482                         7                      3791 
                 Lacrosse                      Luge       Military Ski Patrol 
                       58                      1459                        24 
        Modern Pentathlon              Motorboating           Nordic Combined 
                     1665                        13                      1343 
                     Polo                  Racquets       Rhythmic Gymnastics 
                       68                        10                       658 
                    Roque                    Rowing                     Rugby 
                        1                     10462                       157 
             Rugby Sevens                   Sailing                  Shooting 
                      299                      5643                      8535 
Short Track Speed Skating                  Skeleton               Ski Jumping 
                     1534                       183                      2395 
             Snowboarding                  Softball             Speed Skating 
                      934                       474                      5587 
                 Swimming     Synchronized Swimming              Table Tennis 
                    23143                       907                      1889 
                Taekwondo                    Tennis              Trampolining 
                      606                      2795                       151 
                Triathlon                Tug-Of-War                Volleyball 
                      526                       157                      3396 
               Water Polo             Weightlifting                 Wrestling 
                     3820                      3893                      7102 

```
#### x.x.x Find the Sport(s) With the Lighest Athletes:
> input
``` {r}
light <- (olympics$Weight < (w_q1 - 1.5 * w_iqr))

olympics$Sport[light]

olympics[light, "Sport"] %>% table()
```
> Output:
``` {r}
       Alpine Skiing            Athletics            Bobsleigh 
                   2                    5                    1 
Cross Country Skiing              Cycling               Diving 
                   1                    1                    4 
             Fencing       Figure Skating             Football 
                   1                    2                    1 
          Gymnastics      Nordic Combined  Rhythmic Gymnastics 
                 178                    2                    2 
              Rowing             Shooting        Speed Skating 
                   1                    1                    1 
            Swimming           Volleyball            Wrestling 
                   1                    1                    1 
```
#### x.x.x Find the Sport(s) With the Heaviest Athletes:
> input
``` {r}
heavy <- (olympics$Weight < (w_q3 + 1.5 * w_iqr))

olympics$Sport[heavy]

olympics[heavy, "Sport"] %>% table()
```
> Output:
``` {r}
              Aeronautics             Alpine Skiing                  Alpinism 
                        1                      8788                        22 
                  Archery          Art Competitions                 Athletics 
                     2293                      3357                     37307 
                Badminton                  Baseball                Basketball 
                     1457                       868                      4136 
            Basque Pelota          Beach Volleyball                  Biathlon 
                        2                       556                      4890 
                Bobsleigh                    Boxing                  Canoeing 
                     2933                      5994                      6146 
                  Cricket                   Croquet      Cross Country Skiing 
                       24                        19                      9111 
                  Curling                   Cycling                    Diving 
                      462                     10819                      2828 
            Equestrianism                   Fencing            Figure Skating 
                     6293                     10622                      2292 
                 Football          Freestyle Skiing                      Golf 
                     6711                       936                       244 
               Gymnastics                  Handball                    Hockey 
                    26560                      3562                      5401 
               Ice Hockey              Jeu De Paume                      Judo 
                     5469                        11                      3450 
                 Lacrosse                      Luge       Military Ski Patrol 
                       58                      1477                        24 
        Modern Pentathlon              Motorboating           Nordic Combined 
                     1669                        17                      1338 
                     Polo                  Racquets       Rhythmic Gymnastics 
                       90                        11                       658 
                    Roque                    Rowing                     Rugby 
                        4                     10515                       159 
             Rugby Sevens                   Sailing                  Shooting 
                      291                      6448                     11211 
Short Track Speed Skating                  Skeleton               Ski Jumping 
                     1532                       197                      2395 
             Snowboarding                  Softball             Speed Skating 
                      935                       474                      5597 
                 Swimming     Synchronized Swimming              Table Tennis 
                    23128                       909                      1953 
                Taekwondo                    Tennis              Trampolining 
                      601                      2842                       152 
                Triathlon                Tug-Of-War                Volleyball 
                      529                       161                      3387 
               Water Polo             Weightlifting                 Wrestling 
                     3721                      3496                      6696 
```
#### x.x.x Find the sport(s) with the shortest athletes:
> input
``` {r}
short <- (olympics$Height < (h_q1 - 1.5 * h_iqr))

olympics$Sport[short]

olympics[short, "Sport"] %>% table()
```
> Output:
``` {r}

       Alpine Skiing     Art Competitions            Athletics 
                  15                    8                   51 
           Badminton           Basketball             Biathlon 
                   1                    2                    3 
           Bobsleigh               Boxing             Canoeing 
                   3                   26                    4 
             Cricket              Croquet Cross Country Skiing 
                   1                    1                    6 
             Cycling               Diving              Fencing 
                  23                    9                   15 
      Figure Skating             Football           Gymnastics 
                  13                   13                  798 
            Handball               Hockey           Ice Hockey 
                   4                    4                    7 
                Judo    Modern Pentathlon         Motorboating 
                   9                    1                    1 
     Nordic Combined  Rhythmic Gymnastics               Rowing 
                   1                    1                   23 
               Rugby              Sailing             Shooting 
                   2                    1                   23 
         Ski Jumping        Speed Skating             Swimming 
                   2                    3                   42 
        Table Tennis               Tennis           Volleyball 
                   2                    6                    1 
          Water Polo        Weightlifting            Wrestling 
                   4                   18                   14 
```
#### x.x.x Find the Sport(s) With the Tallest Athletes:
> input
``` {r}
tall <- (olympics$Height < (h_q3 + 1.5 * h_iqr))

olympics$Sport[tall]

olympics[tall, "Sport"] %>% table()
```
> Output:
``` {r}
        Aeronautics             Alpine Skiing                  Alpinism 
                        1                      8818                        25 
                  Archery          Art Competitions                 Athletics 
                     2333                      3525                     38546 
                Badminton                  Baseball                Basketball 
                     1457                       893                      3856 
            Basque Pelota          Beach Volleyball                  Biathlon 
                        2                       545                      4890 
                Bobsleigh                    Boxing                  Canoeing 
                     3053                      6033                      6157 
                  Cricket                   Croquet      Cross Country Skiing 
                       24                        19                      9127 
                  Curling                   Cycling                    Diving 
                      463                     10846                      2841 
            Equestrianism                   Fencing            Figure Skating 
                     6334                     10704                      2296 
                 Football          Freestyle Skiing                      Golf 
                     6735                       937                       245 
               Gymnastics                  Handball                    Hockey 
                    26666                      3618                      5415 
               Ice Hockey              Jeu De Paume                      Judo 
                     5508                        11                      3782 
                 Lacrosse                      Luge       Military Ski Patrol 
                       59                      1479                        24 
        Modern Pentathlon              Motorboating           Nordic Combined 
                     1675                        17                      1342 
                     Polo                  Racquets       Rhythmic Gymnastics 
                       95                        12                       658 
                    Roque                    Rowing                     Rugby 
                        4                     10518                       160 
             Rugby Sevens                   Sailing                  Shooting 
                      299                      6567                     11409 
Short Track Speed Skating                  Skeleton               Ski Jumping 
                     1534                       199                      2401 
             Snowboarding                  Softball             Speed Skating 
                      936                       478                      5607 
                 Swimming     Synchronized Swimming              Table Tennis 
                    23101                       909                      1952 
                Taekwondo                    Tennis              Trampolining 
                      603                      2843                       152 
                Triathlon                Tug-Of-War                Volleyball 
                      529                       165                      3196 
               Water Polo             Weightlifting                 Wrestling 
                     3815                      3927                      7138 
```
#### x.x.x Check for the Number of Unique Values in Each Column
> input
``` {r}
unique_counts <- sapply(olympics, function(x) length(unique(x)))
print(unique_counts)
```
> Output:
``` {r}
      ID   Name   Sex Age Height Weight Team  NOC Year Season City Sport Event Medal
  135571 134732     2  74     95    220 1184  230   35      2   42    66   765     4
```

#### x.x Look at the Non Numerical Data:
> input
``` {r}
summary(olympics[,sapply(olympics, is.character)])
```
> Output:
``` {r}
     Name               Sex                Team               NOC           
 Length:271116      Length:271116      Length:271116      Length:271116     
 Class :character   Class :character   Class :character   Class :character  
 Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    Season              City              Sport              Event          
 Length:271116      Length:271116      Length:271116      Length:271116     
 Class :character   Class :character   Class :character   Class :character  
 Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    Medal          
 Length:271116     
 Class :character  
 Mode  :character  
 ```
