DSCI\_522\_EDA
================
Katie Birchard
17/01/2020

``` r
# Loading necessary packages for EDA
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──

    ## ✓ ggplot2 3.2.1     ✓ purrr   0.3.3
    ## ✓ tibble  2.1.3     ✓ dplyr   0.8.3
    ## ✓ tidyr   1.0.0     ✓ stringr 1.4.0
    ## ✓ readr   1.3.1     ✓ forcats 0.4.0

    ## ── Conflicts ────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following object is masked from 'package:base':
    ## 
    ##     date

``` r
# Loading in the dataset locally (will change to downloading using script later)
avocado <- read_csv("avocado.csv")
```

    ## Warning: Missing column names filled in: 'X1' [1]

    ## Parsed with column specification:
    ## cols(
    ##   X1 = col_double(),
    ##   Date = col_date(format = ""),
    ##   AveragePrice = col_double(),
    ##   `Total Volume` = col_double(),
    ##   `4046` = col_double(),
    ##   `4225` = col_double(),
    ##   `4770` = col_double(),
    ##   `Total Bags` = col_double(),
    ##   `Small Bags` = col_double(),
    ##   `Large Bags` = col_double(),
    ##   `XLarge Bags` = col_double(),
    ##   type = col_character(),
    ##   year = col_double(),
    ##   region = col_character()
    ## )

``` r
# Checking column headers
head(avocado)
```

    ## # A tibble: 6 x 14
    ##      X1 Date       AveragePrice `Total Volume` `4046` `4225` `4770` `Total Bags`
    ##   <dbl> <date>            <dbl>          <dbl>  <dbl>  <dbl>  <dbl>        <dbl>
    ## 1     0 2015-12-27         1.33         64237.  1037. 5.45e4   48.2        8697.
    ## 2     1 2015-12-20         1.35         54877.   674. 4.46e4   58.3        9506.
    ## 3     2 2015-12-13         0.93        118220.   795. 1.09e5  130.         8145.
    ## 4     3 2015-12-06         1.08         78992.  1132  7.20e4   72.6        5811.
    ## 5     4 2015-11-29         1.28         51040.   941. 4.38e4   75.8        6184.
    ## 6     5 2015-11-22         1.26         55980.  1184. 4.81e4   43.6        6684.
    ## # … with 6 more variables: `Small Bags` <dbl>, `Large Bags` <dbl>, `XLarge
    ## #   Bags` <dbl>, type <chr>, year <dbl>, region <chr>

``` r
# Changing the spread of the data so we have a column for PLU and bag size
# Note that PLU is the Price Look-Up codes - which are baed on the commodity,
# variety, and size of the avocado group
# It looks like the average price was calculated across these PLUs
avocado2 <- avocado %>% 
  gather(key = "PLU", value = "no_sold", `4046`, `4225`, `4770`) %>%
  gather(key = "bag_size", value = "bags_sold", `Small Bags`, `Large Bags`, `XLarge Bags`)

# How many data points do we have for each feature?
length(avocado$X1)
```

    ## [1] 18249

``` r
length(avocado2$X1)
```

    ## [1] 164241

``` r
# Creating another column for month
avocado2$month <- month(as.Date(avocado2$Date), label=TRUE)
```

``` r
# What is the average avocado price per region?
avocado_by_region <- avocado2 %>%
  group_by(region) %>%
  summarize(ave_price = mean(AveragePrice))

# There are many regions here, so it might make sense to group them
ggplot(avocado_by_region, aes(x=reorder(region, -ave_price), y=ave_price)) +
  geom_col(fill="darkblue", alpha=0.5, colour="darkblue") +
  xlab("Regions") +
  ylab("Average Price") +
  ggtitle("Average Price of Avocados by Region") +
  theme_bw() +
  theme(axis.text.x = element_text(angle=90)) 
```

![](DSCI_522_EDA_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

``` r
# What is the average avocado price by type (organic vs. non-organic)
avocado_by_type <- avocado2 %>%
  group_by(type) %>%
  summarize(ave_price = mean(AveragePrice))

ggplot(avocado_by_type, aes(x=reorder(type, -ave_price), y=ave_price)) +
  geom_col(fill="darkblue", alpha=0.5, colour="darkblue") +
  xlab("Type") +
  ylab("Average Price") +
  ggtitle("Average Price of Avocados by Type") +
  theme_bw()
```

![](DSCI_522_EDA_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

``` r
# What is the average price per month?
avocado_by_month <- avocado2 %>%
  group_by(month) %>%
  summarize(ave_price = mean(AveragePrice))

# Interesting 
ggplot(avocado_by_month, aes(x=reorder(month, -ave_price), y=ave_price)) +
  geom_col(fill="darkblue", alpha=0.5, colour="darkblue") +
  xlab("Month") +
  ylab("Average Price") +
  ggtitle("Average Price of Avocados by Month") +
  theme_bw()
```

![](DSCI_522_EDA_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
# How many of each variety of avocado sells?
avocado_by_plu <- avocado2 %>%
  group_by(PLU) %>%
  summarize(ave_no_sold = mean(no_sold))

# PLU 4770 is not very popular...
ggplot(avocado_by_plu, aes(x=reorder(PLU, -ave_no_sold), y=ave_no_sold)) +
  geom_col(fill="darkblue", alpha=0.5, colour="darkblue") +
  xlab("PLU") +
  ylab("Average Number of Avocados Sold") +
  ggtitle("Average Number of Avocados Sold by PLU") +
  theme_bw()
```

![](DSCI_522_EDA_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
# Do people prefer buying smaller bags, or bigger bags of avocados?
avocado_by_bag <- avocado2 %>%
  group_by(bag_size) %>%
  summarize(ave_bags_sold = mean(bags_sold))

# Turns out smaller bags are better
ggplot(avocado_by_bag, aes(x=reorder(bag_size, -ave_bags_sold), y=ave_bags_sold)) +
  geom_col(fill="darkblue", alpha=0.5, colour="darkblue") +
  xlab("PLU") +
  ylab("Average Number of Bags Sold") +
  ggtitle("Average Number of Bags Sold by Bag Size") +
  theme_bw()
```

![](DSCI_522_EDA_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

``` r
# Do people buy their avocados in bags more or individually?
ggplot(avocado2, aes(y=bags_sold, x=no_sold)) +
  geom_point(alpha=0.5, colour="darkblue") +
  ylab("Number of bags of avocados sold") +
  xlab("Number of avocados sold total") +
  ggtitle("Are people buying more avocados individually or in bulk?") +
  theme_bw()
```

![](DSCI_522_EDA_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->
