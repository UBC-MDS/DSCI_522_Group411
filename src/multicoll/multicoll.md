Multicollinearity
================

Load
    libraries.

``` r
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──

    ## ✓ ggplot2 3.2.1     ✓ purrr   0.3.3
    ## ✓ tibble  2.1.3     ✓ dplyr   0.8.3
    ## ✓ tidyr   1.0.0     ✓ stringr 1.4.0
    ## ✓ readr   1.3.1     ✓ forcats 0.4.0

    ## ── Conflicts ────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
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
library(caret)
```

    ## Loading required package: lattice

    ## 
    ## Attaching package: 'caret'

    ## The following object is masked from 'package:purrr':
    ## 
    ##     lift

``` r
library(feather)
library(reshape2)
```

    ## 
    ## Attaching package: 'reshape2'

    ## The following object is masked from 'package:tidyr':
    ## 
    ##     smiths

## Correlation Matrix

Get training data.

``` r
# See README for how to create feather files.
df <- read_feather(here::here("data/train.feather"))
```

``` r
#' Set upper triangle of matrix to NA
#'
#' @param corr_matrix A matrix
#'
#' @return Matrix with upper triangle set to NA
upper_tri_na <- function(corr_matrix) {
  corr_matrix[upper.tri(corr_matrix)] <- NA
  corr_matrix
}
```

Under the assumption that the data can be modelled linearly after
observing the residual plot, we select the continuous numerical
predictors, compute the correlation matrix and wrangle into a plottable
dataframe (*Ggplot2 : Quick Correlation Matrix Heatmap - R Software and
Data Visualization*, n.d.).

``` r
# Create dataframe for correlation matrix chart
corr_df <- df %>% 
  select(total_volume, 
         PLU_4046, 
         PLU_4225, 
         PLU_4770, 
         total_bags, 
         small_bags, 
         large_bags, 
         xlarge_bags) %>% 
  cor %>% 
  upper_tri_na %>% 
  melt(na.rm = TRUE) %>% 
  mutate(value = round(value, 2))
```

Correlation Matrix Chart

``` r
ggplot(corr_df) + 
  geom_tile(aes(Var1, Var2, fill = value)) +
  geom_text(aes(Var1, Var2, label = value), color = "black", size = 4) +
  scale_fill_distiller(palette = "GnBu", direction = 1) +
  labs(title = "Correlation Matrix",
       subtitle = "Avocado Data",
       fill = "Pearson's\nCorrelation") +
  coord_fixed() +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        panel.grid.major = element_blank(),
        legend.justification = c(1, 0),
        legend.position = c(0.55, 0.7),
        legend.direction = "horizontal") +
  guides(fill = guide_colorbar(barwidth = 7, 
                               barheight = 1,
                               title.position = "top", 
                               title.hjust = 0.5))
```

![](multicoll_files/figure-gfm/chart-1.png)<!-- -->

Overall, there is fairly high collinarity between many of the
predictors. This was expected, since they all deal with volume of
avocados sold, be it by PLU code, bag type or total volume.

In particular, `total_bags` and `total_volume` were expected to be
highly correlated to other predictors that were sub-quantities of these
totals.

Due to the high correlation, including all these predictors in a
prediction model would probably lead to overfitting.

## Multicollinearity

Create linear model and comput VIF scores from car (Fox and Weisberg
2019)
package.

``` r
car::vif(lm(average_price ~ total_volume + PLU_4046 + PLU_4225 + PLU_4770 + total_bags + small_bags + large_bags + xlarge_bags, data = df))
```

    ## total_volume     PLU_4046     PLU_4225     PLU_4770   total_bags   small_bags 
    ## 4.375098e+09 5.707626e+08 5.165779e+08 4.140131e+06 2.489906e+14 1.426942e+14 
    ##   large_bags  xlarge_bags 
    ## 1.488220e+13 8.212601e+10

This suggests extremely high collinearity for these variables in a
linear model. We’ll be careful about using these features. They are
probably not very good predictors of the average avocado price.

## References

<div id="refs" class="references">

<div id="ref-car">

Fox, John, and Sanford Weisberg. 2019. *An R Companion to Applied
Regression*. Third. Thousand Oaks CA: Sage.
<https://socialsciences.mcmaster.ca/jfox/Books/Companion/>.

</div>

<div id="ref-corr">

*Ggplot2 : Quick Correlation Matrix Heatmap - R Software and Data
Visualization*. n.d. STHTDA.
<http://www.sthda.com/english/wiki/ggplot2-quick-correlation-matrix-heatmap-r-software-and-data-visualization>.

</div>

</div>
