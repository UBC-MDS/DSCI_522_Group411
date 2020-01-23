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

![](hypothesis_test_files/figure-gfm/fit%20model-1.png)<!-- -->

Based on the EDA, we chose to fit a linear model to conudct our
hypothesis test. To confirm that a linear model would be appropriate for
this dataset, we will examine its residual plot. Looking at the residual
plot, the points are randomly distributed which indicates that a linear
model is appropriate in this case.

    ## Analysis of Variance Table
    ## 
    ## Response: average_price
    ##                  Df Sum Sq Mean Sq    F value Pr(>F)    
    ## total_volume      1  796.4   796.4 1.1540e+04 <2e-16 ***
    ## total_bags        1   21.9    21.9 3.1710e+02 <2e-16 ***
    ## type              1 7361.1  7361.1 1.0667e+05 <2e-16 ***
    ## region           53 3521.0    66.4 9.6273e+02 <2e-16 ***
    ## PLU               2    0.1     0.1 7.8920e-01 0.4542    
    ## bag_size          2    0.0     0.0 1.2130e-01 0.8857    
    ## month             1  562.4   562.4 8.1498e+03 <2e-16 ***
    ## Residuals    131333 9062.8     0.1                      
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

At a significance level of 0.05, it appears that the following features
are significant as their p-values are less than the significance level:

  - total\_volume
  - total\_bags
  - type
  - month
  - region

However, we should be cautious not to use the p-value significance as a
stand alone measure to determine if these features are correlated with
the target. We will also conduct a multicollinearity test to determine
if any of the features are redundant. We will then use these results to
serve as a validation for our final feature importances model.
