# Avocado Price Predictors

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

*__Creators__: Katie Birchard, Ryan Homer, Andrea Lee*

## Dataset

We will be analyzing the [avocado prices dataset](https://www.kaggle.com/neuromusic/avocado-prices?fbclid=IwAR35kKP-Fz0yYZj-QqsZ6iNDSVnLBncxTOG3Cce3F5EupQTVHo85ecn7SBo) retrieved from Kaggle and compiled by the Hass Avocado Board using retail scan data from the United States [1]. The dataset consists of approximately 18,000 records over 4 years (2015 - 2018). The dataset contains information about avocado prices, Price Look-Up (PLU) codes, types (organic or conventional), region purchased in the United States, volume sold, bags sold, and date sold.

## Research Question

We will be answering the research question: **What is the strongest predictor of avocado prices in the United States?**

Our goal is to find the feature that most strongly predicts the average price of avocados in the United States. A natural inferential sub-question would be to first determine if any of the features correlate with avocado prices and if there is any multicollinearity among the features. From our results, we can also compute a rank of features by importance.

## Analysis

To answer our research question, we will first need to determine our target and features. Our target will be `average price` and our features will be `type`, `region`, `date`, `total volume`, `PLU_code`, `no_variety_sold`, `Total Bags`, `bag_size`, `bags_sold`, `month`, and `year_month`. Some of these features do not match the column names of the original dataset, such as `month` or `PLU_code`, as they were created during data wrangling step of the exploratory data analysis.

Next, we will need to determine if the features are correlated with the target. We will do this by fitting an additive linear model. We will then conduct a hypothesis test and interpret the p-values and confidence intervals to determine which features are significant. This hypothesis test will also serve as a validation for the feature importances computed in the last step.

To get a better understanding of our features, we will also test for multicollinearity by computing their variance inflation factors. We will then check for and remove any redundancies between features. This will allow us to build a more accurate model in the next step.

Once we have confirmed which features are correlated with the target and are non-redundant, we will fit a Random Forest Regressor model using these features. We will then compute the feature importances using the `feature_importances_` attribute. This attribute will return an importance value for each feature that indicates how important that feature is at explaining the target (the higher the value, the more important the feature is). The importance value is based on the decrease in impurity measure. The decrease in impurity is calculated by the model by computing how much each feature contributes to decreasing the weighted impurity. The model then averages each feature's impurity decrease over the trees.

Lastly, we will plot our results in order to find out which feature is the strongest predictor of avocado prices.

## Exploratory Data Analysis

Before we can perform our hypotheses tests and create our random forest regression model, we will partition the complete dataset into an 80% training set and a 20% test set. We will then perform exploratory data analysis on the training set to assess the validity of our dataset, as well as assess possible correlations between the features and average avocado prices. To ensure the validity of our dataset, we will include a table of summary statistics and compare these values to a previous study looking at average avocado prices over a similar time period [2]. To get an idea of which features may be of importance, we will include bar plots depicting the relationship between month and price, type and price, and region and price. We will also display a plot depicting how avocado prices have varied by week between 2015 and 2018.

## Results

To communicate our results, we will create a bar chart ranking the features by importance, from most to least important. The plot will have the features on the x-axis and the importance values on the y-axis.

## Usage

Here are two suggested ways to run this analysis.

### Run with Docker (recommended)

1. Install [Docker](https://www.docker.com/get-started).
1. Download or clone this repository.
1. Open a terminal session and navigate to the root of the project directory.
1. Run the analysis with the following command:

```
docker run --rm -v /$(pwd):/avocado avocado_predictors make -C /avocado all
```
**Windows Users**: You may need to replace `/$(pwd)` above with the absolute path to the root of your project directory.


To clean out all temporary files (without launching a Docker container):

```
make clean
```

When the process has completed, you can find the analysis report at `doc/avocado_predictors_report.html` or `doc/avocado_predictors_report.md`.

### Run without Docker

1. Make sure you've installed all of the dependencies listed in the Dependencies section below.
1. Download or clone this repository.
1. Open a terminal session and navigate to the root of the project directory.
1. Run the analysis with the following command:

```
make all
```

To clean out all temporary files:

```
make clean
```

#### Run Individual Pieces

To retrieve and prepare the data:

```
Rscript src/get_data.R --url=https://raw.githubusercontent.com/ryanhomer/dsci522-group411-data/master/avocado.csv --destfile=data/avocado.csv
Rscript src/prepare_data.R --datafile=data/avocado.csv --out=data
```

To generate markdown versions of the notebooks we used during EDA:

```
Rscript -e "rmarkdown::render('src/DSCI_522_EDA.Rmd')"
Rscript -e "rmarkdown::render('src/hypothesis_test.Rmd')"
Rscript -e "rmarkdown::render('src/multicoll/multicoll.Rmd')"
```

To generate the final report:

```
Rscript src/conduct_hypothesis_test.R --datafile=data/train.feather --out=doc/img
Rscript src/multicoll/mc_create_assets.R --datafile=data/train.feather --out=doc/img
Rscript src/render_EDA.R --datafile=data/train.feather --out=doc/img
python src/regression.py data/train.feather results/
Rscript -e "rmarkdown::render('doc/avocado_predictors_report.Rmd', output_format = 'github_document')"
```

## Dependencies

### OS-level Dependencies

Package Name|Version
-|-
chromedriver|79.0.3945.36
Python|3.7
R|3.6.2

### R Package Dependencies

Package Name|Version
-|-
broom|0.5.3
caret|6.0-85
car|3.0-6
docopt|0.6.1
feather|0.3.5
ggpubr|0.2.4
here|0.1
kableExtra|1.1.0
knitr|1.25
lubridate|1.7.4
magick|2.3
RCurl|1.98-1.1
reshape2|1.4.3
tidyverse|1.2.1

### Python Package Dependencies

Package Name|Version
-|-
altair|4.0.0
numpy|1.17
pandas|0.25.3
pyarrow|0.15.1
scikit-learn|0.22.1
selenium|3.141.0

## Reports

- [Exploratory Data Analysis](https://github.com/UBC-MDS/DSCI_522_Group411/blob/master/src/DSCI_522_EDA.md)
- [Hypothesis Test (Intermediate Analysis)](https://github.com/UBC-MDS/DSCI_522_Group411/blob/master/src/hypothesis_test.md)
- [Multicollinearity Test (Intermediate Analysis)](https://github.com/UBC-MDS/DSCI_522_Group411/blob/master/src/multicoll/multicoll.md)
- [Random Forest Feature Importances (Final Analysis)](https://github.com/UBC-MDS/DSCI_522_Group411/blob/master/src/ML_analysis.ipynb)
- [Final Report](https://github.com/UBC-MDS/DSCI_522_Group411/blob/master/doc/avocado_predictors_report.md)

## Scripts

- [Download Data](https://github.com/UBC-MDS/DSCI_522_Group411/blob/master/src/get_data.R)
- [Prepare Data](https://github.com/UBC-MDS/DSCI_522_Group411/blob/master/src/prepare_data.R)
- [Render EDA](https://github.com/UBC-MDS/DSCI_522_Group411/blob/master/src/render_EDA.R)
- [Conduct Hypothesis Test](https://github.com/UBC-MDS/DSCI_522_Group411/blob/master/src/conduct_hypothesis_test.R)
- [Conduct Multicollinearity Test](https://github.com/UBC-MDS/DSCI_522_Group411/blob/master/src/multicoll/mc_create_assets.R)
- [Conduct Feature Importances Analysis](https://github.com/UBC-MDS/DSCI_522_Group411/blob/master/src/regression.py)
- [Final Report](https://github.com/UBC-MDS/DSCI_522_Group411/blob/master/src/run_all.sh)

## References

[1] Kiggins, J. "Avocado Prices: Historical data on avocado prices and sales volume in multiple US markets." May 2018. [Web Link](https://www.kaggle.com/neuromusic/avocado-prices).

[2] Shahbandeh, M. "Average sales price of avocados in the U.S. 2012-2018." February 2019. [Web Link](https://www.statista.com/statistics/493487/average-sales-price-of-avocados-in-the-us/).
