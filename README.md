# Predicting Avocado Prices

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

*__Creators__: Katie Birchard, Ryan Homer, Andrea Lee*

## Dataset

We will be analyzing the [avocado prices dataset](https://www.kaggle.com/neuromusic/avocado-prices?fbclid=IwAR35kKP-Fz0yYZj-QqsZ6iNDSVnLBncxTOG3Cce3F5EupQTVHo85ecn7SBo) retrieved from Kaggle and compiled by the Hass Avocado Board using retail scan data [1]. The dataset consists of approximately 18,000 records over 4 years (2015 - 2018). The dataset contains information about avocado prices, Price Look-Up (PLU) codes, types (organic or conventional), region purchased in the United States, volume sold, bags sold, and date sold.

## Research Question

We will be answering the research question: **What is the strongest predictor of avocado prices in the United States?**

Our goal is to find the feature that most strongly predicts the average price of avocados in the United States. A natural inferential sub-question would be to first determine if any of the features correlate with avocado prices and if there is any multicollinearity among the features. From our results, we can also compute a rank of features by importance.

## Analysis

To answer our research question, we will first need to determine our target and features. Our target will be `average price` and our features will be `type`, `region`, `date`, `total volume`, `PLU_code`, `no_variety_sold`, `Total Bags`, `bag_size`, `bags_sold`, `month`, and `year_month`. Some of these features do not match the column names of the original dataset, such as `month` or `PLU_code`, as they were created during data wrangling step of the exploratory data analysis.

Next, we will need to determine if the features are correlated with the target. We will do this by fitting an additive linear model. We will then conduct a hypothesis test and interpret the p-values and confidence intervals to determine which features are significant. This hypothesis test will also serve as a validation for the feature importances computed in the last step.

To get a better understanding of our features, we will also test for multicollinearity by computing their variance inflation factors. We will then check for and remove any redundancies between features. This will allow us to build a more accurate model.

Once we have confirmed that the features are correlated with the target, we will fit a random forest regression model. We will then compute the feature importances using the `feature_importances_` attribute.

## Exploratory Data Analysis

Before we can perform our hypotheses tests and create our random forest regression model, we will partition the complete dataset into an 80% training set and a 20% test set. We will then perform exploratory data analysis on the training set to assess the validity of our dataset, as well as assess possible correlations between the features and average avocado prices. To ensure the validity of our dataset, we will include a table of summary statistics and compare these values to a previous study looking at average avocado prices over a similar time period [2]. To get an idea of which features may be of importance, we will include bar plots depicting the relationship between month and price, type and price, and region and price. We will also display a plot depicting how avocado prices have varied by week between 2015 and 2018.

## Results

To communicate our results, we will create a bar chart ranking the features by importance, from most to least important. The plot will have the features on the x-axis and the importance values on the y-axis.

## Usage

To replicate this analysis, clone this repository and make sure that the dependencies below are installed. Then, run the following in your terminal from the root directory of the project.

```
Rscript src/get_data.R --url=https://raw.githubusercontent.com/ryanhomer/dsci522-group411-data/master/avocado.csv --destfile=data/avocado.csv
Rscript -e "rmarkdown::render('src/DSCI_522_EDA.Rmd')"
```

### R Package Dependencies
Package Name|Version
-|-
tidyverse|1.2.1
lubridate|1.7.4
caret|6.0-85
knitr|1.25
ggpubr|0.2.4

## References
[1] Kiggins, J. "Avocado Prices: Historical data on avocado prices and sales volume in multiple US markets." May 2018. [Web Link](https://www.kaggle.com/neuromusic/avocado-prices).

[2] Shahbandeh, M. "Average sales price of avocados in the U.S. 2012-2018." February 2019. [Web Link](https://www.statista.com/statistics/493487/average-sales-price-of-avocados-in-the-us/)
