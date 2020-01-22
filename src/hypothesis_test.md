DSCI 522 Hypothesis Test
================
Katie Birchard, Ryan Homer, Andrea Lee

## Hypothesis Test: What is the strongest predictor of avocado prices in the United States?

To conduct a hypothesis test, we will fit an additive linear model and
interpret the p-values to determine which features are significant.

The features we will be testing are:

  - total\_volume: total volume of avocados sold
  - total\_bags: total number of bags of avocados sold
  - type: type of avocado sold (conventional or organic)
  - region: U.S. state avocado was sold in
  - PLU: price lookup code of avocado (4046 small avocado, 4225 large
    avocado, 4770 x-large avocado)
  - bag\_size: size of bag of avocados sold (small, large, x-large)
  - month: month avocado was sold in

The target is:

  - average\_price: average price of avocado sold

We chose a significance level of 0.05 as it is the industry standard. We
chose not to choose a stricter significance level (i.e. 0.01 or 0.001)
as we do not believe that predicting avocado prices requires as
conservative of a test.

    ## # A tibble: 8 x 5
    ##   term              estimate std.error statistic  p.value
    ##   <chr>                <dbl>     <dbl>     <dbl>    <dbl>
    ## 1 (Intercept)   0.582         1.27e- 2    45.7   0.      
    ## 2 total_volume -0.0000000129  9.31e-10   -13.8   1.84e-43
    ## 3 total_bags    0.0000000264  3.24e- 9     8.15  3.81e-16
    ## 4 type          0.488         1.76e- 3   277.    0.      
    ## 5 region       -0.000103      5.57e- 5    -1.85  6.38e- 2
    ## 6 PLU          -0.00000323    2.77e- 6    -1.17  2.43e- 1
    ## 7 bag_size      0.000532      1.05e- 3     0.509 6.11e- 1
    ## 8 month         0.0184        2.42e- 4    76.1   0.

At a significance level of 0.05, it appears that the following features
are significant as their p-values are less than the significance level:

  - total\_volume
  - total\_bags
  - type
  - month

It is surprising that the features region and PLU are not significant at
a significance level of 0.05. However, we should be cautious not to use
the p-value significance as a stand alone measure to determine if these
features are correlated with the target. We will also conduct a
multicollinearity test to determine if any of the features are
redundant. We will then use these results to serve as a validation for
our final feature importances model.
