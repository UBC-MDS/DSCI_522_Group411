# Predicting Avocado Prices

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

*__Creators__: Katie Birchard, Ryan Homer, Andrea Lee*

## Dataset

We will be analyzing the [avocado prices dataset](https://www.kaggle.com/neuromusic/avocado-prices?fbclid=IwAR35kKP-Fz0yYZj-QqsZ6iNDSVnLBncxTOG3Cce3F5EupQTVHo85ecn7SBo) retrieved from Kaggle and compiled by the Hass Avocado Board using retail scan data [1]. The dataset consists of approximately 18,000 records over 4 years (2015 - 2018). The dataset contains information about avocado prices, PLU numbers, types, region purchased, volume sold, bags sold, and date sold.

## Research Question

We will be answering the research question: **What is the strongest predictor of avocado prices?**

Our goal is to find the feature that most strongly predicts the average price of avocados. A natural inferential sub-question would be to first determine if any of the features correlate with avocado prices and if there is any multicollinearity among the features. From our results, we can also compute a rank of features by importance.

## Analysis

To answer our research question, we will first need to determine our target and features. Our target will be `average price` and our features will be `type`, `region`, `date`, `total volume`, `4046`, `4225`, `4770`, `Total Bags`, `Small Bags`, `Large Bags`, and `XLarge Bags`. Our features may be subject to change after exploratory data analysis and data wrangling is performed.

Next, we will need to determine if the features are correlated with the target. We will do this by fitting an additive linear model. We will then conduct a hypothesis test and interpret the p-values to determine which features are significant. This hypothesis test will also serve as a validation for the feature importances computed in the last step. 

To get a better understanding of our features, we will also test for multicollinearity by computing their variance inflation factors. We will then check for and remove any redundancies between features. This will allow us to build a more accurate model in the next step.

Once we have confirmed which features are correlated with the target and are non-redundant, we will fit a random forest model using these features. We will then compute the feature importances using the `feature_importances_` attribute.

## Exploratory Data Analysis


## Results

To communicate our results, we will create a bar chart ranking the features by importance, from most to least important. The plot will have the features on the x-axis and the importance values on the y-axis.

## References
[1] Kiggins, Justin, Avocado Prices: Historical data on avocado prices and sales volume in multiple US markets, May 2018, [Web Link](https://www.kaggle.com/neuromusic/avocado-prices).
