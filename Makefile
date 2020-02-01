#
# Avocado Predictors
# Makefile
#
# Authors: Katie Birchard, Ryan Homer, Andrea Lee
# Date: 2020-01-30
#
# This is the dependency file that replicates the entire analysis
# including retrieving the data, splitting it into train/set sets
# and generating all reports.
#
# Usage:
#   make <target>
#
#   <target> = [all (default) | clean]
#
#   all : get data and generate all reports
#   clean : remove all auto-generated files
#

#
# target: all
# Main project dependencies for generating all reports
#
all : data/train.feather \
      src/DSCI_522_EDA.md \
      src/hypothesis_test.md \
      src/multicoll/multicoll.md \
      doc/img/anova_table.png doc/img/hypothesis_test_table.png doc/img/residual_plot.png \
      doc/img/collinearity.png doc/img/correlation_matrix.png \
      doc/img/EDA_month_table.png doc/img/EDA_plot.png doc/img/EDA_region_table.png doc/img/EDA_type_table.png doc/img/EDA_year_plot.png \
      results/cv_scores_lr.csv results/feature_weights_lr.csv results/feature_importance_rfr.csv results/feature_weights_lr.csv results/feature_plot.png \
      doc/avocado_predictors_report.md

# Get the data
data/avocado.csv :
	Rscript src/get_data.R --url=https://raw.githubusercontent.com/ryanhomer/dsci522-group411-data/master/avocado.csv --destfile=data/avocado.csv

# Split into training/validation and test data sets
data/test.feather data/train.feather : data/avocado.csv
	Rscript src/prepare_data.R --datafile=data/avocado.csv --out=data


# Render EDA and related reports

src/DSCI_522_EDA.md : src/DSCI_522_EDA.Rmd data/train.feather
	Rscript -e "rmarkdown::render('src/DSCI_522_EDA.Rmd')"

src/hypothesis_test.md : src/hypothesis_test.Rmd data/train.feather
	Rscript -e "rmarkdown::render('src/hypothesis_test.Rmd')"

src/multicoll/multicoll.md : src/multicoll/multicoll.Rmd data/train.feather
	Rscript -e "rmarkdown::render('src/multicoll/multicoll.Rmd')"


# Generate assets required for final report

doc/img/anova_table.png doc/img/hypothesis_test_table.png doc/img/residual_plot.png : data/train.feather
	Rscript src/conduct_hypothesis_test.R --datafile=data/train.feather --out=doc/img

doc/img/collinearity.png doc/img/correlation_matrix.png : data/train.feather
	Rscript src/multicoll/mc_create_assets.R --datafile=data/train.feather --out=doc/img

doc/img/EDA_month_table.png doc/img/EDA_plot.png doc/img/EDA_region_table.png doc/img/EDA_type_table.png doc/img/EDA_year_plot.png : data/train.feather
	Rscript src/render_EDA.R --datafile=data/train.feather --out=doc/img

# Run regression analyses
results/cv_scores_lr.csv results/feature_weights_lr.csv results/cv_scores_rfr.csv results/feature_importance_rfr.csv results/feature_plot.png : data/train.feather
	python src/regression.py data/train.feather results/

# Generate final report
doc/avocado_predictors_report.md : doc/avocado_predictors_report.Rmd
	Rscript -e "rmarkdown::render('doc/avocado_predictors_report.Rmd', output_format = 'github_document')"

#
# target: clean
# Removes all auto-generated files
#
clean :
	rm -rf data
	rm -rf doc/avocado_predictors_report.html
	rm -rf doc/avocado_predictors_report.md
	rm -rf doc/img
	rm -rf results/*
	rm -rf Rplots.pdf
	rm -rf src/DSCI_522_EDA.html
	rm -rf src/DSCI_522_EDA.md
	rm -rf src/DSCI_522_EDA_files
	rm -rf src/hypothesis_test.html
	rm -rf src/hypothesis_test.md
	rm -rf src/hypothesis_test_files
	rm -rf src/multicoll/multicoll.html
	rm -rf src/multicoll/multicoll.md
	rm -rf src/multicoll/multicoll_files
