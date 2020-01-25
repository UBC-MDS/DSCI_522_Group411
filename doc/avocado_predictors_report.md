DSCI 522 Avocado Predictors
================
Katie Birchard, Ryan Homer, Andrea Lee
24/01/2020

# What is the strongest predictor of avocado prices in the United States?

We will be answering the research question: **What is the strongest
predictor of avocado prices in the United States?**

Our goal is to find the feature that most strongly predicts the price of
avocados in the United States. A natural inferential sub-question would
be to first determine if any of the features correlate with avocado
prices and if there is any multicollinearity among the features. From
our results, we can also compute a rank of features by importance.

# Dataset

We will be analyzing the [avocado prices
dataset](https://www.kaggle.com/neuromusic/avocado-prices) retrieved
from Kaggle and compiled by the Hass Avocado Board using retail scan
data from the United States (Kiggins 2018). The dataset consists of
approximately 18,000 records over 4 years (2015 - 2018). The dataset
contains information about avocado prices, Price Look-Up (PLU) codes,
types (organic or conventional), region purchased in the United States,
volume sold, bags sold, and date sold.

# Analysis

We used a random forest regression model to determine the strongest
predictors of avocado prices. Before we fitted the model, we first
conducted a hypothesis test and a multicollinearity test to determine
which features are significant and should be used in the model. These
tests also identified features that were strongly correlated with one
another, and therefore would be redundant to include in the model.

The features we tested were:

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
  - `region`: U.S. state avocado was sold in
  - `month`: month avocado was sold in

The features we used in the random forest regression model were:

  - `type`: type of avocado sold (conventional or organic)
  - `region`: U.S. state avocado was sold in
  - `month`: month avocado was sold in

The target was:

  - `average_price`: average price of avocado sold

To perform this anlaysis, the R and Python programming languages (R Core
Team 2019; Van Rossum and Drake 2009) as well as the following R and
Python packages were used: `caret` (Kuhn 2020), `docopt` (de Jonge
2018), `feather` (Wickham 2019), `tidyverse` (Wickham et al. 2019),
`lubridate` (Grolemund and Wickham 2011), `car` (Fox and Weisberg 2019),
`kableExtra` (Zhu 2019), `reshape2` (Wickham 2007), `tidyverse` (Wickham
et al. 2019), `broom` (Robinson and Hayes 2019), `knitr` (Xie 2014),
`ggpubr` (Kassambara 2018), `RCurl` (Temple Lang 2020), `here`(Müller
2017), `pandas` (McKinney and others 2010), `numpy` (Oliphant 2006),
`selenium` (Salunke 2014), `scikit-learn` (Pedregosa et al. 2011), and
`altair` (Sievert 2018).

# Exploratory Data Analysis

We wanted to determine which features might be the most important to
include in our random forest regression model. Therefore we plotted
region, type, and month against the average price to visualize the
relationships between these variables. We did not plot number of
avocados sold from each of the PLU codes, `PLU_4046`, `PLU_4225`, and
`PLU_4770`, or the number of bags sold from `total_bags`, `small_bags`,
`large_bags`, and `xlarge_bags`, because the relationship between
avocado prices and avocados sold could be reciprocal (i.e. avocados sold
may influence the price and vice versa), leading to a false
interpretation. From looking at these relationships, we can see that
some regions, such as Hartford-Springfield and San Francisco, have
higher avocado prices than other regions, such as Houston. We can also
clearly see (and we may have already predicted from our own experience)
that organic avocados are likely more expensive than non-organic
avocados. Finally, when we observe the monthly trend of avocado prices,
we can see that perhaps avocados are most expensive in the fall months,
and least expensive during the winter months.

![](../doc/img/EDA_plot.png) **Figure 1.** Average price of avocados in
the United States by region, type, month, and number of total avocados
sold each week.

Since we want to ensure the prices in this dataset are relatively
accurate, we compared the average prices in this dataset to another
[study](https://www.statista.com/statistics/493487/average-sales-price-of-avocados-in-the-us/)
published by M. Shahbandeh in February 2019. According to the dataset we
selected, the average price of avocados from 2015 to 2018 was $1.41.
According to Shahbandeh’s study, the average price of avocados from 2015
to 2018 was $1.11 (Shahbandeh 2019). Thus, the average price from our
dataset is slightly higher compared to Shahbandeh’s study. This
discrepancy could be due to the inclusion of organic avocados in this
dataset, which tend to be more expensive. However, the prices are still
similar enough that the observations from this dataset are likely
accurate.

# Results

## Hypothesis Test

First, we conducted a hypothesis test to determine if any of the
features are correlated to the target. To conduct a hypothesis test, we
fitted an additive linear model and interpreted the p-values to
determine which features are significant. We chose a significance level
of 0.05 as it is the industry standard. We chose not to choose a
stricter significance level (i.e. 0.01 or 0.001) as we do not believe
that predicting avocado prices requires as conservative of a test.

Based on our EDA, we chose to fit a linear model to conudct our
hypothesis test. To confirm that a linear model would be appropriate for
this dataset, examined its residual plot. Looking at the residual plot
below, the points are randomly distributed which indicates that a linear
model is appropriate in this case. ![](../doc/img/residual_plot.png)
**Figure 2.** Residual plot to examine appropriateness of using a linear
model.

At a significance level of 0.05, it appears from the model below that
the following features are significant as their p-values are less than
the significance level:

  - `type`
  - `year`
  - `region`
  - `month`

However, region and month are categorical variables that have numerous
levels. Therefore, with all these levels, it is difficult to interpret
their p-values from this model.
![](../doc/img/hypothesis_test_table.png) **Figure 3.** Hypothesis test.

We also used ANOVA to calculate and interpret the features’ p-values, as
ANOVA is a special case of linear model that assumes categorical
predictors. This test will act as a validation for the categorical
variables we determined as significant above. The results of our ANOVA
test below confirms that the features `type`, `year`, `region`, and
`month` are significant at a 0.05 significance level.
![](../doc/img/anova_table.png) **Figure 4.** Hypothesis test of
significant features using ANOVA.

However, we should be cautious not to use the p-value significance as a
stand alone measure to determine if these features are correlated with
the target. We also conducted a multicollinearity test to determine if
any of the features are redundant. We then used these results to inform
which features should be included in the feature importances model.

## Multicollinearity Test

Next we conducted a multicollinearity test to check for any redundancies
between features. Under the assumption that the data can be modelled
linearly after observing the residual plot, we selected the continuous
numerical predictors, computed the correlation matrix, and wrangled the
data into a plottable dataframe \[3\].
![](../doc/img/correlation_matrix.png) **Figure 5.** Correlation matrix
of continuous features.

Overall, there is fairly high collinarity between many of the
predictors. This was expected, since they all deal with volume or number
of avocados sold, be it by PLU code, bag type or total volume. In
particular, `total_bags` and `total_volume` were expected to be highly
correlated to other predictors that were sub-quantities of these totals.
Due to the high correlation, including all these predictors in a
prediction model would probably lead to overfitting.

To verify the result from the correlation matrix above, we also computed
the variance inflation (VIF) scores from the `car` package.

![](../doc/img/collinearity.png) **Figure 6.** Variance inflation scores
of continuous features.

The high VIF scores suggest extremely high collinearity for these
variables in a linear model. Therefore, we will be careful about using
these features as they are probably ineffective predictors of the
average avocado price.

## Random Forest Feature Importances

Lastly, we fitted a random forest regressor model using the features
that we determined as significant from the analysis above (`region`,
`type`, and `month`). We used one hot encoding on these categorical
features and used randomized cross validation to determine the optimal
hyperparameters, maximum depth and number of estimators. We calculated
the average (validation) scores using cross validation to determine how
well our model was performing.

| Fold | Neg Mean Squared Error |
| ---: | ---------------------: |
|    1 |            \-0.0634236 |
|    2 |            \-0.0712498 |
|    3 |            \-0.0549990 |
|    4 |            \-0.1310914 |
|    5 |            \-0.1385528 |

**Table 1**. Cross-validation scores for each of the folds in the random
forest regression model.

From this model, we were able to determine the relative importance of
each feature.

| Feature Names               | Importance |
| :-------------------------- | ---------: |
| type\_organic               |  0.4724502 |
| type\_conventional          |  0.1726477 |
| region\_HartfordSpringfield |  0.0395635 |
| region\_SanFrancisco        |  0.0352611 |
| month\_Nov                  |  0.0327563 |
| month\_Dec                  |  0.0254321 |
| region\_NewYork             |  0.0227305 |
| region\_Houston             |  0.0212973 |
| region\_PhoenixTucson       |  0.0198379 |
| month\_Feb                  |  0.0167626 |
| region\_DallasFtWorth       |  0.0149198 |
| region\_WestTexNewMexico    |  0.0131553 |
| region\_SouthCentral        |  0.0123819 |
| region\_Charlotte           |  0.0109272 |
| region\_Sacramento          |  0.0097175 |

**Table 2**. The relative feature importances of the top 15 most
important features determined by random forest regression model.

We found that our top predictor of avocado prices is `type`
(i.e. whether the avocado is organic or conventional).

![](../results/feature_plot.png)

**Figure 7.** Plot ranking features by importance.

Our model had a training accuracy score of 0.71. The result from our
model aligned with our expectations as our EDA depicted differences in
distributions between organic and conventional acovado prices.

We also fitted a linear regression model, however, the training accuracy
score was 0.61, which is much lower than the accuracy of the random
forest model. Therefore, we decided to use the random forest model to
continue on with our analysis of computing feature importances.

# Discussion

The random forest regression model predicted that `type` is the most
important feature for predicting avocado price. This result is expected,
since we observed a significant difference in the distribution of
average prices between organic and conventional avocados during the
exploratory data analysis and hypothesis testing. We also expected this
result from previous experience buying avocados. Organic avocados are
grown without the use of pesticides, and therefore produce a lower yield
per growing season, ultimately resulting in a more expensive avocado.

The `region` feature also seemed to play some importance in the pricing
of avocados. For instance, regions such as Hartford-Springfield and San
Francisco were the third and fourth most important predictors of average
avocado price. It is unclear how these regions affect avocado prices.

Our random forest model could be improved substantially by modifying the
`month` and `region` features.

`Month` is ordinal, thus it should be treated as a numerical variable.
However, it is difficult to convert month into its numerical form since
December and January would be interpreted as furthest apart from one
another, when in reality they should be interpreted as close to one
another. That being said, we could treat month as a categorical variable
if we group the months into seasons and use season as a feature instead.

Similarly, the different regions within the `region` feature are also
related to one other as some regions are closer to one another
geographically, while others are further apart. Therefore, a more
accurate way to depict `region` would be to transform each region into
its respective latitude and longitude.

# References

<div id="refs" class="references">

<div id="ref-docopt">

de Jonge, Edwin. 2018. *Docopt: Command-Line Interface Specification
Language*. <https://CRAN.R-project.org/package=docopt>.

</div>

<div id="ref-car">

Fox, John, and Sanford Weisberg. 2019. *An R Companion to Applied
Regression*. Third. Thousand Oaks CA: Sage.
<https://socialsciences.mcmaster.ca/jfox/Books/Companion/>.

</div>

<div id="ref-lubridate">

Grolemund, Garrett, and Hadley Wickham. 2011. “Dates and Times Made Easy
with lubridate.” *Journal of Statistical Software* 40 (3): 1–25.
<http://www.jstatsoft.org/v40/i03/>.

</div>

<div id="ref-ggpubr">

Kassambara, Alboukadel. 2018. *Ggpubr: ’Ggplot2’ Based Publication Ready
Plots*. <https://CRAN.R-project.org/package=ggpubr>.

</div>

<div id="ref-avocado-data">

Kiggins, J. 2018. “Avocado Prices: Historical Data on Avocado Prices and
Sales Volume in Multiple Us Markets.”
<https://www.kaggle.com/neuromusic/avocado-prices>.

</div>

<div id="ref-caret">

Kuhn, Max. 2020. *Caret: Classification and Regression Training*.
<https://CRAN.R-project.org/package=caret>.

</div>

<div id="ref-pandas">

McKinney, Wes, and others. 2010. “Data Structures for Statistical
Computing in Python.” In *Proceedings of the 9th Python in Science
Conference*, 445:51–56. Austin, TX.

</div>

<div id="ref-here">

Müller, Kirill. 2017. *Here: A Simpler Way to Find Your Files*.
<https://CRAN.R-project.org/package=here>.

</div>

<div id="ref-numpy">

Oliphant, Travis E. 2006. “A Guide to Numpy.” Trelgol Publishing USA.

</div>

<div id="ref-scikit-learn">

Pedregosa, F., G. Varoquaux, A. Gramfort, V. Michel, B. Thirion, O.
Grisel, M. Blondel, et al. 2011. “Scikit-Learn: Machine Learning in
Python.” *Journal of Machine Learning Research* 12: 2825–30.

</div>

<div id="ref-r">

R Core Team. 2019. *R: A Language and Environment for Statistical
Computing*. Vienna, Austria: R Foundation for Statistical Computing.
<https://www.R-project.org/>.

</div>

<div id="ref-broom">

Robinson, David, and Alex Hayes. 2019. *Broom: Convert Statistical
Analysis Objects into Tidy Tibbles*.
<https://CRAN.R-project.org/package=broom>.

</div>

<div id="ref-selenium">

Salunke, Sagar Shivaji. 2014. *Selenium Webdriver in Python: Learn with
Examples*. 1st ed. North Charleston, SC, USA: CreateSpace Independent
Publishing Platform.

</div>

<div id="ref-avocado-study">

Shahbandeh, M. 2019. “Average Sales Price of Avocados in the U.s.
2012-2018.”
<https://www.statista.com/statistics/493487/average-sales-price-of-avocados-in-the-us/>.

</div>

<div id="ref-2018-altair">

Sievert, Jacob VanderPlas AND Brian E. Granger AND Jeffrey Heer AND
Dominik Moritz AND Kanit Wongsuphasawat AND Arvind Satyanarayan AND
Eitan Lees AND Ilia Timofeev AND Ben Welsh AND Scott. 2018. “Altair:
Interactive Statistical Visualizations for Python.” *The Journal of Open
Source Software* 3 (32). <http://idl.cs.washington.edu/papers/altair>.

</div>

<div id="ref-RCurl">

Temple Lang, Duncan. 2020. *RCurl: General Network (Http/Ftp/...) Client
Interface for R*. <https://CRAN.R-project.org/package=RCurl>.

</div>

<div id="ref-Python">

Van Rossum, Guido, and Fred L. Drake. 2009. *Python 3 Reference Manual*.
Scotts Valley, CA: CreateSpace.

</div>

<div id="ref-reshape2">

Wickham, Hadley. 2007. “Reshaping Data with the reshape Package.”
*Journal of Statistical Software* 21 (12): 1–20.
<http://www.jstatsoft.org/v21/i12/>.

</div>

<div id="ref-feather">

———. 2019. *Feather: R Bindings to the Feather ’Api’*.
<https://CRAN.R-project.org/package=feather>.

</div>

<div id="ref-tidyverse">

Wickham, Hadley, Mara Averick, Jennifer Bryan, Winston Chang, Lucy
D’Agostino McGowan, Romain François, Garrett Grolemund, et al. 2019.
“Welcome to the tidyverse.” *Journal of Open Source Software* 4 (43):
1686. <https://doi.org/10.21105/joss.01686>.

</div>

<div id="ref-knitr">

Xie, Yihui. 2014. “Knitr: A Comprehensive Tool for Reproducible Research
in R.” In *Implementing Reproducible Computational Research*, edited by
Victoria Stodden, Friedrich Leisch, and Roger D. Peng. Chapman;
Hall/CRC. <http://www.crcpress.com/product/isbn/9781466561595>.

</div>

<div id="ref-kableExtra">

Zhu, Hao. 2019. *KableExtra: Construct Complex Table with ’Kable’ and
Pipe Syntax*. <https://CRAN.R-project.org/package=kableExtra>.

</div>

</div>
