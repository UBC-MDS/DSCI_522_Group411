#!/bin/bash
#
# run_all.sh
#
# Avocado Price Predictors
# by Katie Birchard, Ryan Homer and Andrea Lee
# Jan, 2020
#
# This driver script automates the process of retrieving
# the data used in the project and generating all reports
# including the final analysis.
#
# Usage: bash run_all.sh

# Get the data
Rscript src/get_data.R --url=https://raw.githubusercontent.com/ryanhomer/dsci522-group411-data/master/avocado.csv --destfile=data/avocado.csv

# Split into training/validation and test data sets
Rscript src/prepare_data.R --datafile=data/avocado.csv --out=data

# Render EDA and related reports
Rscript -e "rmarkdown::render('src/DSCI_522_EDA.Rmd')"
Rscript -e "rmarkdown::render('src/hypothesis_test.Rmd')"
Rscript -e "rmarkdown::render('src/multicoll/multicoll.Rmd')"

# Generate assets required for final report
Rscript src/conduct_hypothesis_test.R --datafile=data/train.feather --out=doc/img
Rscript src/multicoll/mc_create_assets.R --datafile=data/train.feather --out=doc/img
Rscript src/render_EDA.R --datafile=data/train.feather --out=doc/img

# Run regression analysis
python src/regression.py data/train.feather results/

# Generate final report
Rscript -e "rmarkdown::render('doc/avocado_predictors_report.Rmd', output_format = 'github_document')"
