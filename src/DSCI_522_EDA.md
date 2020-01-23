DSCI 522 Exploratory Data Analysis
================
Katie Birchard, Andrea Lee, Ryan Homer

## **Research Question**: What is the strongest predictor of avocado prices in the United States?

``` r
# Check the number of rows
nrow(avocado)
```

    ## [1] 14601

``` r
# Check the number of columns
ncol(avocado)
```

    ## [1] 16

``` r
# Check the structure of the dataset
# Here we can see the headers and type of each potential feature
str(avocado)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    14601 obs. of  16 variables:
    ##  $ X1           : num  0 1 2 3 4 5 6 7 8 10 ...
    ##  $ date         : Date, format: "2015-12-27" "2015-12-20" ...
    ##  $ average_price: num  1.33 1.35 0.93 1.08 1.28 1.26 0.99 0.98 1.02 1.12 ...
    ##  $ total_volume : num  64237 54877 118220 78992 51040 ...
    ##  $ PLU_4046     : num  1037 674 795 1132 941 ...
    ##  $ PLU_4225     : num  54455 44639 109150 71976 43838 ...
    ##  $ PLU_4770     : num  48.2 58.3 130.5 72.6 75.8 ...
    ##  $ total_bags   : num  8697 9506 8145 5811 6184 ...
    ##  $ small_bags   : num  8604 9408 8042 5677 5986 ...
    ##  $ large_bags   : num  93.2 97.5 103.1 133.8 197.7 ...
    ##  $ xlarge_bags  : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ type         : chr  "conventional" "conventional" "conventional" "conventional" ...
    ##  $ year         : num  2015 2015 2015 2015 2015 ...
    ##  $ region       : chr  "Albany" "Albany" "Albany" "Albany" ...
    ##  $ month        : Factor w/ 12 levels "Jan","Feb","Mar",..: 12 12 12 12 11 11 11 11 11 10 ...
    ##  $ year_month   : chr  "2015-12" "2015-12" "2015-12" "2015-12" ...

``` r
# Looking at the top of the data
head(avocado[, c(2:7)])
```

    ## # A tibble: 6 x 6
    ##   date       average_price total_volume PLU_4046 PLU_4225 PLU_4770
    ##   <date>             <dbl>        <dbl>    <dbl>    <dbl>    <dbl>
    ## 1 2015-12-27          1.33       64237.    1037.   54455.     48.2
    ## 2 2015-12-20          1.35       54877.     674.   44639.     58.3
    ## 3 2015-12-13          0.93      118220.     795.  109150.    130. 
    ## 4 2015-12-06          1.08       78992.    1132    71976.     72.6
    ## 5 2015-11-29          1.28       51040.     941.   43838.     75.8
    ## 6 2015-11-22          1.26       55980.    1184.   48068.     43.6

``` r
head(avocado[, c(8:14)])
```

    ## # A tibble: 6 x 7
    ##   total_bags small_bags large_bags xlarge_bags type          year region
    ##        <dbl>      <dbl>      <dbl>       <dbl> <chr>        <dbl> <chr> 
    ## 1      8697.      8604.       93.2           0 conventional  2015 Albany
    ## 2      9506.      9408.       97.5           0 conventional  2015 Albany
    ## 3      8145.      8042.      103.            0 conventional  2015 Albany
    ## 4      5811.      5677.      134.            0 conventional  2015 Albany
    ## 5      6184.      5986.      198.            0 conventional  2015 Albany
    ## 6      6684.      6556.      127.            0 conventional  2015 Albany

``` r
# Looking at the bottom of the data
tail(avocado[, c(2:7)])
```

    ## # A tibble: 6 x 6
    ##   date       average_price total_volume PLU_4046 PLU_4225 PLU_4770
    ##   <date>             <dbl>        <dbl>    <dbl>    <dbl>    <dbl>
    ## 1 2018-02-25          1.57       18421.    1974.    2483.       0 
    ## 2 2018-02-18          1.56       17597.    1892.    1928.       0 
    ## 3 2018-02-11          1.57       15986.    1924.    1368.       0 
    ## 4 2018-02-04          1.63       17075.    2047.    1529.       0 
    ## 5 2018-01-21          1.87       13767.    1192.    2453.     728.
    ## 6 2018-01-14          1.93       16205.    1528.    2981.     727.

``` r
tail(avocado[, c(8:14)])
```

    ## # A tibble: 6 x 7
    ##   total_bags small_bags large_bags xlarge_bags type     year region          
    ##        <dbl>      <dbl>      <dbl>       <dbl> <chr>   <dbl> <chr>           
    ## 1     13964.     13698.      266.            0 organic  2018 WestTexNewMexico
    ## 2     13777.     13554.      223.            0 organic  2018 WestTexNewMexico
    ## 3     12694.     12437.      256.            0 organic  2018 WestTexNewMexico
    ## 4     13499.     13067.      432.            0 organic  2018 WestTexNewMexico
    ## 5      9394.      9352.       42.3           0 organic  2018 WestTexNewMexico
    ## 6     10970.     10920.       50             0 organic  2018 WestTexNewMexico

``` r
# How many regions in the US are included in the dataset?
unique(avocado$region)
```

    ##  [1] "Albany"              "Atlanta"             "BaltimoreWashington"
    ##  [4] "Boise"               "Boston"              "BuffaloRochester"   
    ##  [7] "California"          "Charlotte"           "Chicago"            
    ## [10] "CincinnatiDayton"    "Columbus"            "DallasFtWorth"      
    ## [13] "Denver"              "Detroit"             "GrandRapids"        
    ## [16] "GreatLakes"          "HarrisburgScranton"  "HartfordSpringfield"
    ## [19] "Houston"             "Indianapolis"        "Jacksonville"       
    ## [22] "LasVegas"            "LosAngeles"          "Louisville"         
    ## [25] "MiamiFtLauderdale"   "Midsouth"            "Nashville"          
    ## [28] "NewOrleansMobile"    "NewYork"             "Northeast"          
    ## [31] "NorthernNewEngland"  "Orlando"             "Philadelphia"       
    ## [34] "PhoenixTucson"       "Pittsburgh"          "Plains"             
    ## [37] "Portland"            "RaleighGreensboro"   "RichmondNorfolk"    
    ## [40] "Roanoke"             "Sacramento"          "SanDiego"           
    ## [43] "SanFrancisco"        "Seattle"             "SouthCarolina"      
    ## [46] "SouthCentral"        "Southeast"           "Spokane"            
    ## [49] "StLouis"             "Syracuse"            "Tampa"              
    ## [52] "TotalUS"             "West"                "WestTexNewMexico"

``` r
table(avocado$region)
```

    ## 
    ##              Albany             Atlanta BaltimoreWashington               Boise 
    ##                 283                 267                 266                 273 
    ##              Boston    BuffaloRochester          California           Charlotte 
    ##                 276                 270                 279                 272 
    ##             Chicago    CincinnatiDayton            Columbus       DallasFtWorth 
    ##                 268                 264                 273                 276 
    ##              Denver             Detroit         GrandRapids          GreatLakes 
    ##                 269                 265                 271                 273 
    ##  HarrisburgScranton HartfordSpringfield             Houston        Indianapolis 
    ##                 280                 273                 267                 275 
    ##        Jacksonville            LasVegas          LosAngeles          Louisville 
    ##                 251                 259                 275                 292 
    ##   MiamiFtLauderdale            Midsouth           Nashville    NewOrleansMobile 
    ##                 262                 275                 275                 272 
    ##             NewYork           Northeast  NorthernNewEngland             Orlando 
    ##                 276                 265                 281                 271 
    ##        Philadelphia       PhoenixTucson          Pittsburgh              Plains 
    ##                 272                 269                 270                 273 
    ##            Portland   RaleighGreensboro     RichmondNorfolk             Roanoke 
    ##                 274                 257                 263                 279 
    ##          Sacramento            SanDiego        SanFrancisco             Seattle 
    ##                 267                 264                 267                 267 
    ##       SouthCarolina        SouthCentral           Southeast             Spokane 
    ##                 264                 265                 283                 265 
    ##             StLouis            Syracuse               Tampa             TotalUS 
    ##                 274                 263                 269                 279 
    ##                West    WestTexNewMexico 
    ##                 262                 261

``` r
# There are 54 unique regions, each with 338 observations

#We want to make sure that the data is consistent. For instance, for this dataset we want to make #sure that we have an equal number of observations for each region.

# How many types of avocado are there?
unique(avocado$type)
```

    ## [1] "conventional" "organic"

``` r
table(avocado$type)
```

    ## 
    ## conventional      organic 
    ##         7303         7298

``` r
# Looks like there are 3 more conventional observations than organic
```

The dataset we chose for this project was compiled by the Hass Avocado
Board using retail scan data, and was retrieved from Kaggle at this
[link](https://www.kaggle.com/neuromusic/avocado-prices?fbclid=IwAR35kKP-Fz0yYZj-QqsZ6iNDSVnLBncxTOG3Cce3F5EupQTVHo85ecn7SBo).
The dataset includes 23 columns and 18,249 rows of data. Most of the
columns/features are of type numeric, except for `region` and `type`,
which are categorical, and `Date`, which is a date-time object. The data
is ordered by year of `Date` (with months descending), starting in 2015
and ending in 2018. Each row of the dataframe represents a week in
avocado sales, including information about the average price of an
avocado for each region in the United States, number of bags sold,
number of each PLU code sold, total volume sold, number of bags sold,
and number of type sold (organic vs conventional).

Preliminary exploration of the dataset has given some insight to the
potential features of our model. First, it looks like the PLU code
`4770` does not have as many examples as the other PLU codes, which
could be due to missing data or rarity of that avocado variety. It also
looks like `XLarge Bags` might not be sold everywhere, considering that
none were sold in either the head or the tail of the data. We also want
to make sure that each categorical variable is represented equally in
the dataset. It appears that 54 unique regions are represented in the
dataset, each with 338 observations. In addition, there are only 2 types
of avocado, with `conventional` having 9126 observations and `organic`
having 9123 observations. This slight difference between types is minor,
and so should not affect analysis.

Since we want to ensure the prices in this dataset are relatively
accurate, we compared the average prices in this dataset to another
[study](https://www.statista.com/statistics/493487/average-sales-price-of-avocados-in-the-us/)
published by M. Shahbandeh in February 2019. According to the dataset we
selected, the average price of avocados from 2015 to 2018 was $1.41.

``` r
broom::tidy(summary(avocado$average_price))
```

    ## # A tibble: 1 x 6
    ##   minimum    q1 median  mean    q3 maximum
    ##     <dbl> <dbl>  <dbl> <dbl> <dbl>   <dbl>
    ## 1    0.44   1.1   1.37  1.41  1.66    3.25

According to Shahbandeh’s study, the average price of avocados in 2015
was $1.03, in 2016 was $1.04, in 2017 was $1.28, and in 2018 was $1.10.
Thus, the average price from our dataset is slightly higher compared to
Shahbandeh’s study. This discrepancy could be due to the inclusion of
organic avocados in this dataset, which tend to be more expensive.
However, the prices are still similar enough that the observations from
this dataset are likely accurate.

## Splitting the data into train and test sets

Before we begin visualizing the data, we will split the dataset into 80%
training data and 20% test data. The test data will not be used for the
exploratory dataset, and will only be used for testing the finalized
model at the end of the project.

## Exploratory analysis on the training dataset

We wanted to determine which features might be the most important to
include in our random forest regression model. Therefore we plotted
region, type, month, and number sold each week against the average price
to visualize the relationships between these variables (figure 1). We
did not plot number of avocados sold from each of the PLU codes,
`PLU_4046`, `PLU_4225`, and `PLU_4770`, or the number of bags sold from
`total_bags`, `small_bags`, `large_bags`, and `xlarge_bags`, because the
relationship between avocado prices and avocados sold could be
reciprocal (i.e. avocados sold may influence the price and vice versa),
leading to a false interpretation. From looking at these relationships,
we can see that some regions, such as Hartford-Springfield and San
Francisco, have higher avocado prices than other regions, such as
Houston. We can also clearly see (and we may have already predicted from
our own experience) that organic avocados are likely more expensive than
non-organic avocados. Finally, when we observe the monthly trend of
avocado prices, we can see that perhaps avocados are most expensive in
the fall months, and least expensive during the winter months.

``` r
# What is the distribution of the different categorical features?
# Make tables

region_summary <- avocado %>%
  count(region)

region_summary <- avocado %>%
  group_by(region) %>%
  summarize(min = min(average_price),
            lower_quartile = quantile(average_price, 0.25),
            mean = mean(average_price),
            median = median(average_price),
            upper_quantile = quantile(average_price, 0.75),
            max = max(average_price))  %>%
  left_join(region_summary)

region_summary_table <- kable(region_summary,
                              caption = "Table 1. Summary statistics for the average price of avocados in all regions in the United States.")

region_summary_table
```

| region              |  min | lower\_quartile |     mean | median | upper\_quantile |  max |   n |
| :------------------ | ---: | --------------: | -------: | -----: | --------------: | ---: | --: |
| Albany              | 0.85 |          1.3550 | 1.559929 |  1.560 |          1.8100 | 2.13 | 283 |
| Atlanta             | 0.62 |          1.0400 | 1.340787 |  1.220 |          1.6200 | 2.75 | 267 |
| BaltimoreWashington | 0.95 |          1.2600 | 1.540150 |  1.570 |          1.7100 | 2.28 | 266 |
| Boise               | 0.58 |          1.0100 | 1.328132 |  1.200 |          1.5800 | 2.79 | 273 |
| Boston              | 0.85 |          1.2600 | 1.532391 |  1.560 |          1.8125 | 2.19 | 276 |
| BuffaloRochester    | 1.03 |          1.3325 | 1.511407 |  1.480 |          1.6000 | 2.57 | 270 |
| California          | 0.67 |          1.0800 | 1.383871 |  1.340 |          1.6400 | 2.58 | 279 |
| Charlotte           | 0.92 |          1.2575 | 1.624963 |  1.600 |          1.9200 | 2.83 | 272 |
| Chicago             | 0.82 |          1.2400 | 1.558657 |  1.610 |          1.7900 | 2.30 | 268 |
| CincinnatiDayton    | 0.44 |          0.9375 | 1.213712 |  1.130 |          1.4725 | 2.17 | 264 |
| Columbus            | 0.71 |          1.0000 | 1.249048 |  1.170 |          1.4800 | 2.22 | 273 |
| DallasFtWorth       | 0.65 |          0.8200 | 1.093913 |  1.040 |          1.3500 | 1.90 | 276 |
| Denver              | 0.60 |          0.9900 | 1.222862 |  1.170 |          1.4300 | 2.16 | 269 |
| Detroit             | 0.48 |          1.0300 | 1.278340 |  1.250 |          1.5100 | 2.08 | 265 |
| GrandRapids         | 0.77 |          1.2550 | 1.506421 |  1.510 |          1.7550 | 2.73 | 271 |
| GreatLakes          | 0.73 |          1.1100 | 1.328242 |  1.330 |          1.5300 | 1.98 | 273 |
| HarrisburgScranton  | 0.91 |          1.2175 | 1.510893 |  1.480 |          1.7900 | 2.27 | 280 |
| HartfordSpringfield | 0.86 |          1.3900 | 1.820476 |  1.810 |          2.2700 | 2.68 | 273 |
| Houston             | 0.51 |          0.7900 | 1.044794 |  0.980 |          1.2750 | 1.92 | 267 |
| Indianapolis        | 0.79 |          1.0850 | 1.313964 |  1.290 |          1.5300 | 2.10 | 275 |
| Jacksonville        | 0.54 |          1.2100 | 1.511195 |  1.470 |          1.8150 | 2.99 | 251 |
| LasVegas            | 0.54 |          0.9850 | 1.378880 |  1.270 |          1.7250 | 3.03 | 259 |
| LosAngeles          | 0.53 |          0.9450 | 1.223709 |  1.140 |          1.4250 | 2.37 | 275 |
| Louisville          | 0.56 |          1.0500 | 1.298973 |  1.240 |          1.5500 | 2.29 | 292 |
| MiamiFtLauderdale   | 0.79 |          1.2300 | 1.428321 |  1.420 |          1.5775 | 3.05 | 262 |
| Midsouth            | 0.95 |          1.1700 | 1.402073 |  1.400 |          1.6000 | 2.17 | 275 |
| Nashville           | 0.51 |          0.9600 | 1.208146 |  1.090 |          1.4950 | 2.22 | 275 |
| NewOrleansMobile    | 0.58 |          1.0300 | 1.300809 |  1.340 |          1.5200 | 2.32 | 272 |
| NewYork             | 0.77 |          1.3600 | 1.729493 |  1.780 |          2.0600 | 2.65 | 276 |
| Northeast           | 0.87 |          1.3400 | 1.621736 |  1.670 |          1.8900 | 2.31 | 265 |
| NorthernNewEngland  | 0.95 |          1.1900 | 1.481495 |  1.520 |          1.6800 | 1.96 | 281 |
| Orlando             | 0.83 |          1.2300 | 1.517970 |  1.480 |          1.8100 | 2.87 | 271 |
| Philadelphia        | 0.91 |          1.3700 | 1.620404 |  1.605 |          1.8600 | 2.39 | 272 |
| PhoenixTucson       | 0.46 |          0.6700 | 1.198216 |  1.140 |          1.7100 | 2.62 | 269 |
| Pittsburgh          | 0.87 |          1.2500 | 1.366741 |  1.390 |          1.4900 | 1.83 | 270 |
| Plains              | 0.76 |          1.1200 | 1.441978 |  1.500 |          1.7000 | 2.13 | 273 |
| Portland            | 0.68 |          0.9800 | 1.311533 |  1.210 |          1.5700 | 2.85 | 274 |
| RaleighGreensboro   | 0.86 |          1.2200 | 1.574397 |  1.540 |          1.8300 | 3.00 | 257 |
| RichmondNorfolk     | 0.78 |          1.0650 | 1.294183 |  1.260 |          1.4950 | 1.96 | 263 |
| Roanoke             | 0.70 |          1.0200 | 1.237312 |  1.160 |          1.4400 | 2.27 | 279 |
| Sacramento          | 0.86 |          1.2000 | 1.604757 |  1.600 |          1.9500 | 2.82 | 267 |
| SanDiego            | 0.61 |          1.0500 | 1.412614 |  1.290 |          1.8025 | 2.74 | 264 |
| SanFrancisco        | 0.84 |          1.3400 | 1.806255 |  1.660 |          2.3000 | 3.25 | 267 |
| Seattle             | 0.75 |          1.1000 | 1.442809 |  1.350 |          1.6950 | 2.96 | 267 |
| SouthCarolina       | 0.69 |          1.1000 | 1.406856 |  1.370 |          1.6700 | 2.21 | 264 |
| SouthCentral        | 0.62 |          0.8400 | 1.095170 |  1.060 |          1.3500 | 1.81 | 265 |
| Southeast           | 0.62 |          1.1500 | 1.399329 |  1.410 |          1.6350 | 2.33 | 283 |
| Spokane             | 0.74 |          1.0900 | 1.442830 |  1.320 |          1.7100 | 2.93 | 265 |
| StLouis             | 0.68 |          1.1325 | 1.422409 |  1.320 |          1.7500 | 2.84 | 274 |
| Syracuse            | 1.03 |          1.3400 | 1.511217 |  1.460 |          1.6400 | 2.44 | 263 |
| Tampa               | 0.75 |          1.1900 | 1.410743 |  1.410 |          1.5900 | 2.70 | 269 |
| TotalUS             | 0.76 |          1.0400 | 1.317778 |  1.330 |          1.5350 | 2.09 | 279 |
| West                | 0.66 |          0.9600 | 1.273053 |  1.185 |          1.5400 | 2.52 | 262 |
| WestTexNewMexico    | 0.52 |          0.8000 | 1.250498 |  1.110 |          1.6500 | 2.93 | 261 |

Table 1. Summary statistics for the average price of avocados in all
regions in the United States.

``` r
type_summary <- avocado %>%
  count(type)

type_summary <- avocado %>%
  group_by(type) %>%
  summarize(min = min(average_price),
            lower_quartile = quantile(average_price, 0.25),
            mean = mean(average_price),
            median = median(average_price),
            upper_quantile = quantile(average_price, 0.75),
            max = max(average_price))  %>%
  left_join(type_summary)

type_summary_table <- kable(type_summary, 
                            caption = "Table 2. Summary statistics for the average price of avocados for organic and non-organic avocados.")

type_summary_table
```

| type         |  min | lower\_quartile |     mean | median | upper\_quantile |  max |    n |
| :----------- | ---: | --------------: | -------: | -----: | --------------: | ---: | ---: |
| conventional | 0.46 |          0.9800 | 1.157939 |   1.13 |            1.32 | 2.22 | 7303 |
| organic      | 0.44 |          1.4225 | 1.653286 |   1.62 |            1.86 | 3.25 | 7298 |

Table 2. Summary statistics for the average price of avocados for
organic and non-organic avocados.

``` r
month_summary <- avocado %>%
  count(month)

month_summary <- avocado %>%
  group_by(month) %>%
  summarize(min = min(average_price),
            lower_quartile = quantile(average_price, 0.25),
            mean = mean(average_price),
            median = median(average_price),
            upper_quantile = quantile(average_price, 0.75),
            max = max(average_price))  %>%
  left_join(month_summary)

month_summary_table <- kable(month_summary, 
                            caption = "Table 2. Summary statistics for the average price of avocados for each month of the year.")

month_summary_table
```

| month |  min | lower\_quartile |     mean | median | upper\_quantile |  max |    n |
| :---- | ---: | --------------: | -------: | -----: | --------------: | ---: | ---: |
| Jan   | 0.51 |            1.05 | 1.312503 |  1.280 |          1.5400 | 2.70 | 1542 |
| Feb   | 0.46 |            0.99 | 1.279950 |  1.270 |          1.5600 | 2.59 | 1385 |
| Mar   | 0.44 |            1.07 | 1.331495 |  1.300 |          1.5650 | 3.05 | 1451 |
| Apr   | 0.51 |            1.07 | 1.370415 |  1.340 |          1.6325 | 2.83 | 1132 |
| May   | 0.55 |            1.05 | 1.353705 |  1.320 |          1.6100 | 2.73 | 1212 |
| Jun   | 0.52 |            1.10 | 1.400954 |  1.340 |          1.6600 | 2.76 | 1017 |
| Jul   | 0.56 |            1.17 | 1.458411 |  1.410 |          1.6900 | 2.75 | 1227 |
| Aug   | 0.58 |            1.18 | 1.514462 |  1.470 |          1.7900 | 3.00 | 1096 |
| Sep   | 0.58 |            1.19 | 1.570145 |  1.560 |          1.8500 | 2.97 | 1037 |
| Oct   | 0.65 |            1.27 | 1.577873 |  1.565 |          1.8200 | 3.25 | 1208 |
| Nov   | 0.60 |            1.16 | 1.451225 |  1.440 |          1.7000 | 3.12 | 1143 |
| Dec   | 0.49 |            1.05 | 1.333058 |  1.310 |          1.5700 | 2.57 | 1151 |

Table 2. Summary statistics for the average price of avocados for each
month of the year.

``` r
### What is the average avocado price per region?
avocado_by_region <- avocado %>%
  group_by(region) %>%
  summarize(ave_price = mean(average_price))

# There are many regions here, so it might make sense to group them
price_per_region <- ggplot(avocado, aes(x=reorder(region, -average_price), y=average_price)) +
  geom_boxplot(alpha=0.1) +
  geom_point(aes(x=reorder(region, -ave_price), y=ave_price, colour="red"),
             data=avocado_by_region) +
  xlab("Regions") +
  ylab("Average Price ($)") +
  ggtitle("Avocado Price by Region") +
  scale_colour_manual(values=c("red"),
                    breaks=c("red"),
                    labels=c("Mean"),
                    name=c("")) +
  theme_bw() +
  theme(axis.text.x = element_text(angle=90, size = 8),
        axis.title.x = element_blank()) 

# What is the average avocado price by type (organic vs. non-organic)
avocado_by_type <- avocado %>%
  group_by(type) %>%
  summarize(ave_price = mean(average_price))

price_per_type <- ggplot(avocado, aes(x=reorder(type, -average_price), y=average_price)) +
  geom_boxplot(alpha=0.2) +
  geom_point(aes(x=reorder(type, -ave_price), y=ave_price, colour="red"),
             data=avocado_by_type) +
  xlab("Type") +
  ylab("Average Price ($)") +
  ggtitle("Avocado Price by Type") +
  scale_colour_manual(values=c("red"),
                    breaks=c("red"),
                    labels=c("Mean"),
                    name=c("")) +
  theme_bw() +
  theme(axis.title.x = element_blank())

# What is the average price per month?
avocado_by_month <- avocado %>%
  group_by(month) %>%
  summarize(ave_price = mean(average_price))

price_per_month <- ggplot(avocado, aes(x=month, y=average_price)) +
  geom_boxplot(alpha=0.2) +
  geom_point(aes(x=month, y=ave_price, colour="red"),
             data=avocado_by_month) +
  xlab("Month") +
  ylab("Average Price ($)") +
  ggtitle("Avocado Price by Month") +
  scale_colour_manual(values=c("red"),
                    breaks=c("red"),
                    labels=c("Mean"),
                    name=c("")) +
  theme_bw() +
  theme(axis.title.x = element_blank(),
        legend.position = "right")
```

``` r
gridExtra::grid.arrange(price_per_region, price_per_type,
                        price_per_month,
                        ncol=1, nrow=3)
```

![](DSCI_522_EDA_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

**Figure 1.** Average price of avocados in the United States by region,
type, month, and number of total avocados sold each week.

We also plotted the average avocado price over time to get an idea of
how the price has fluctuated and whether there were any outlier months
in the dataset (figure 2). It appears that there was a sharp incline in
avocado prices in August-October of 2017, which may influence our
analysis.

``` r
avocado %>%
  group_by(year_month) %>%
  summarize(average_price = mean(average_price)) %>%
  ggplot(aes(x=year_month, y=average_price)) +
    geom_point(alpha=0.5, colour="darkblue") +
    xlab("Year-Month") +
    ylab("Average Price") +
    #ggtitle("Average Avocado Price Over Time") +
    theme_bw() +
    theme(axis.text.x = element_text(angle=90)) 
```

![](DSCI_522_EDA_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

**Figure 2.** Average number of avocados sold per week between 2015 and
2018.

## References

Kiggins, J. “Avocado Prices: Historical data on avocado prices and sales
volume in multiple US markets.” May 2018. [Web
Link](https://www.kaggle.com/neuromusic/avocado-prices).

Shahbandeh, M. “Average sales price of avocados in the U.S. 2012-2018.”
February 2019. [Web
Link](https://www.statista.com/statistics/493487/average-sales-price-of-avocados-in-the-us/).
