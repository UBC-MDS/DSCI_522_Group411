DSCI 522 Hypothesis Test
================
Katie Birchard, Ryan Homer, Andrea Lee

## Hypothesis Test: What is the strongest predictor of avocado prices in the United States?

To conduct a hypothesis test, we will fit an additive linear model and
interpret the p-values to determine which features are significant.

The features we will be testing are:

  - total\_volume: total volume of avocados sold
  - PLU\_4046: number of of avocados with a price lookup code of 4046
    (small avocado) sold
  - PLU\_4225: number of of avocados with a price lookup code of 4225
    (large avocado) sold
  - PLU\_4770: number of of avocados with a price lookup code of 4770
    (x-large avocado) sold
  - total\_bags: total number of bags of avocados sold
  - small\_bags: number of small bags of avocados sold
  - large\_bags: number of large bags of avocados sold
  - xlarge\_bags: number of x-large bags of avocados sold
  - type: type of avocado sold (conventional or organic)
  - year: year avocado was sold in
  - region: U.S. state avocado was sold in
  - month: month avocado was sold in

The target is:

  - average\_price: average price of avocado sold

We chose a significance level of 0.05 as it is the industry standard. We
chose not to choose a stricter significance level (i.e. 0.01 or 0.001)
as we do not believe that predicting avocado prices requires as
conservative of a test.

Based on our EDA, we chose to fit a linear model to conudct our
hypothesis test. To confirm that a linear model would be appropriate for
this dataset, we will examine its residual plot. Looking at the residual
plot below, the points are randomly distributed which indicates that a
linear model is appropriate in this
case.

``` r
avocado <- read_feather('../data/train.feather')
```

``` r
model <- lm(average_price ~ total_volume + PLU_4046 + PLU_4225 + PLU_4770 + total_bags + small_bags + large_bags + xlarge_bags + type + year + region + month, data = avocado)

ggplot(model, aes(x = model$fitted.values, y = model$residuals)) +
  geom_point(colour= "cadetblue", alpha=0.1) +
  labs(title = 'Residual Plot', x = "Predicted Values", y = "Residuals") +
  theme_minimal()
```

![](hypothesis_test_files/figure-gfm/fit%20model-1.png)<!-- -->

At a significance level of 0.05, it appears from the model below that
the following features are significant as their p-values are less than
the significance level:

  - type
  - year
  - region
  - month

However, region and month are categorical variables that have numerous
levels. Therefore, with all these levels, it is difficult to interpret
their p-values from this model.

``` r
tidy(model)
```

    ## # A tibble: 75 x 5
    ##    term             estimate std.error statistic   p.value
    ##    <chr>               <dbl>     <dbl>     <dbl>     <dbl>
    ##  1 (Intercept)  -114.        4.60        -24.7   2.22e-132
    ##  2 total_volume   -0.0000180 0.0000390    -0.463 6.43e-  1
    ##  3 PLU_4046        0.0000180 0.0000390     0.463 6.43e-  1
    ##  4 PLU_4225        0.0000180 0.0000390     0.462 6.44e-  1
    ##  5 PLU_4770        0.0000181 0.0000390     0.464 6.43e-  1
    ##  6 total_bags     -0.0218    0.0311       -0.701 4.83e-  1
    ##  7 small_bags      0.0218    0.0311        0.702 4.83e-  1
    ##  8 large_bags      0.0218    0.0311        0.702 4.83e-  1
    ##  9 xlarge_bags     0.0218    0.0311        0.702 4.83e-  1
    ## 10 typeorganic     0.491     0.00430     114.    0.       
    ## # … with 65 more rows

ANOVA is a special case of linear model that assumes categorical
predictors. We can also use ANOVA to calculate and interpret the
features’ p-values. This will act as a validation for the categorical
variables we determined as significant above. The results of our ANOVA
test below confirms that the features type, year, region, and month are
significant at a 0.05 significance
level.

``` r
model <- lm(average_price ~ type + year + region + month, data = avocado)
anova(model)
```

    ## Analysis of Variance Table
    ## 
    ## Response: average_price
    ##              Df Sum Sq Mean Sq  F value    Pr(>F)    
    ## type          1 895.66  895.66 14786.52 < 2.2e-16 ***
    ## year          1  19.36   19.36   319.63 < 2.2e-16 ***
    ## region       53 400.52    7.56   124.76 < 2.2e-16 ***
    ## month        11 161.21   14.66   241.95 < 2.2e-16 ***
    ## Residuals 14534 880.36    0.06                       
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

However, we should be cautious not to use the p-value significance as a
stand alone measure to determine if these features are correlated with
the target. We will also conduct a multicollinearity test to determine
if any of the features are redundant. We will then use these results to
serve as a validation for our final feature importances model.
