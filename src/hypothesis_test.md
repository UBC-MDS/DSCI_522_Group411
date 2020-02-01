DSCI 522 Hypothesis Test
================
Katie Birchard, Ryan Homer, Andrea Lee

## Hypothesis Test: What is the strongest predictor of avocado prices in the United States?

To conduct a hypothesis test, we will fit an additive linear model and
interpret the p-values to determine which features are significant.

The features we will be testing are:

  - `total_volume`: total volume of avocados sold
  - `PLU_4046`: number of of avocados with a price lookup code of 4046
    (small avocado) sold
  - `PLU_4225`: number of of avocados with a price lookup code of 4225
    (large avocado) sold
  - `PLU_4770`: number of of avocados with a price lookup code of 4770
    (x-large avocado) sold
  - `total_bags`: total number of bags of avocados sold
  - `small_bags`: number of small bags of avocados sold
  - `large_bags`: number of large bags of avocados sold
  - `xlarge_bags`: number of x-large bags of avocados sold
  - `type`: type of avocado sold (conventional or organic)
  - `year`: year avocado was sold in
  - `lat`: latitude of the U.S. region the avocado was sold in
  - `lon`: longitude of the U.S. region the avocado was sold in
  - `season`: season avocado was sold in

The target is:

  - `average_price`: average price of avocado sold

We chose a significance level of 0.05 as it is the industry standard. We
chose not to choose a stricter significance level (i.e. 0.01 or 0.001)
as we do not believe that predicting avocado prices requires as
conservative of a test.

Based on our EDA, we chose to fit a linear model to conduct our
hypothesis test. To confirm that a linear model would be appropriate for
this dataset, we will examine its residual plot. Looking at the residual
plot below, the points are randomly distributed which indicates that a
linear model is appropriate in this
case.

``` r
avocado <- read_feather('../data/train.feather')
```

``` r
model <- lm(average_price ~ total_volume + PLU_4046 + PLU_4225 + PLU_4770 + total_bags + small_bags + large_bags + xlarge_bags + type + year + lat + lon + season, data = avocado)

ggplot(model, aes(x = model$fitted.values, y = model$residuals)) +
  geom_point(colour= "cadetblue", alpha=0.1) +
  labs(title = 'Residual Plot (Linear Model)', x = "Predicted Values", y = "Residuals") +
  theme_minimal()
```

![](hypothesis_test_files/figure-gfm/fit%20model-1.png)<!-- -->

At a significance level of 0.05, it appears from the model below that
the following features are significant as their p-values are less than
the significance level:

  - `type`
  - `year`
  - `lat`
  - `lon`
  - `season`
  - `total_volume`
  - `PLU_4046`
  - `PLU_4225`
  - `PLU_4770`

<!-- end list -->

``` r
tidy(model)
```

    ## # A tibble: 16 x 5
    ##    term            estimate std.error statistic   p.value
    ##    <chr>              <dbl>     <dbl>     <dbl>     <dbl>
    ##  1 (Intercept)  -127.       5.84        -21.7   1.91e-102
    ##  2 total_volume   -0.000170 0.0000632    -2.68  7.31e-  3
    ##  3 PLU_4046        0.000169 0.0000632     2.68  7.38e-  3
    ##  4 PLU_4225        0.000170 0.0000632     2.69  7.23e-  3
    ##  5 PLU_4770        0.000169 0.0000632     2.68  7.46e-  3
    ##  6 total_bags     -0.0304   0.0404       -0.754 4.51e-  1
    ##  7 small_bags      0.0306   0.0404        0.758 4.49e-  1
    ##  8 large_bags      0.0306   0.0404        0.758 4.49e-  1
    ##  9 xlarge_bags     0.0306   0.0404        0.758 4.49e-  1
    ## 10 typeorganic     0.465    0.00582      79.9   0.       
    ## 11 year            0.0634   0.00290      21.9   2.01e-104
    ## 12 lat             0.00452  0.000544      8.31  1.04e- 16
    ## 13 lon             0.00117  0.000165      7.07  1.66e- 12
    ## 14 seasonSpring   -0.187    0.00737     -25.4   5.14e-139
    ## 15 seasonSummer   -0.0691   0.00761      -9.08  1.20e- 19
    ## 16 seasonWinter   -0.252    0.00734     -34.3   2.59e-246

However, we should be cautious not to use the p-value significance as a
stand alone measure to determine if these features are correlated with
the target. We will also conduct a multicollinearity test to determine
if any of the features are redundant. We will then use these results to
serve as a validation for our final feature importances model.
