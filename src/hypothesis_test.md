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

![](hypothesis_test_files/figure-gfm/fit%20model-1.png)<!-- -->

Based on the EDA, we chose to fit a linear model to conudct our
hypothesis test. To confirm that a linear model would be appropriate for
this dataset, we will examine its residual plot. Looking at the residual
plot, the points are randomly distributed which indicates that a linear
model is appropriate in this case.

    ## Analysis of Variance Table
    ## 
    ## Response: average_price
    ##                 Df Sum Sq Mean Sq    F value    Pr(>F)    
    ## total_volume     1  87.00   87.00  1439.9970 < 2.2e-16 ***
    ## PLU_4046         1  26.38   26.38   436.6751 < 2.2e-16 ***
    ## PLU_4225         1   0.02    0.02     0.3029 0.5820806    
    ## PLU_4770         1   6.47    6.47   107.1677 < 2.2e-16 ***
    ## total_bags       1   0.91    0.91    15.0062 0.0001076 ***
    ## small_bags       1   1.80    1.80    29.8261 4.803e-08 ***
    ## large_bags       1   3.86    3.86    63.9264 1.388e-15 ***
    ## xlarge_bags      1   0.01    0.01     0.1708 0.6794506    
    ## type             1 814.61  814.61 13483.9172 < 2.2e-16 ***
    ## year             1  18.50   18.50   306.1424 < 2.2e-16 ***
    ## region          53 360.61    6.80   112.6231 < 2.2e-16 ***
    ## month           11 159.37   14.49   239.8181 < 2.2e-16 ***
    ## Residuals    14526 877.57    0.06                         
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

At a significance level of 0.05, it appears that the following features
are significant as their p-values are less than the significance level:

  - total\_volume
  - PLU\_4046
  - PLU\_4770
  - total\_bags
  - small\_bags
  - large\_bags
  - type
  - year
  - region
  - month

However, we should be cautious not to use the p-value significance as a
stand alone measure to determine if these features are correlated with
the target. We will also conduct a multicollinearity test to determine
if any of the features are redundant. We will then use these results to
serve as a validation for our final feature importances model.
