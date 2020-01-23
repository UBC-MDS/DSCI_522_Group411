# authors: Katie Birchard, Ryan Homer, Andrea Lee
# date: 2020-01-18
#
"Fetch a dataset to a specified path.

Usage: prepare_data.R --datafile=<path to CSV data file> --out=<path to output directory>

Options:
<datafile> Path to the CSV file, including the actual filename.
<out>      The destination path to write the feather files to.
" -> doc

suppressMessages(library(docopt))
suppressMessages(library(tidyverse))
suppressMessages(library(lubridate))
suppressMessages(library(caret))
suppressMessages(library(feather))

main <- function(args) {
  check_args(args)
  pre_process(args$datafile, args$out)
}

#' Check input args
#'
#' @param args Vector of args from docopt
check_args <- function(args) {
  if (!file.exists(path.expand(args$datafile))) {
    stop("Unable to find datafile.")
  }

  # make sure path exists
  if (!dir.exists(path.expand(args$out))) {
    dir.create(path.expand(args$out), recursive = TRUE)
  }
}

#' Do the data wrangling and output the train and test feather files
#'
#' @param datafile Path to the CSV file, including the actual filename.
#' @param out The destination path to write the feather files to.
pre_process <- function(datafile, out) {
  dest_path <- path.expand(out)

  # Read data from CSV
  df <- read_csv(path.expand(datafile))

  # Rename some columns
  df <- df %>%
    rename(date = Date,
           PLU_4046 = `4046`,
           PLU_4225 = `4225`,
           PLU_4770 = `4770`,
           total_volume = `Total Volume`,
           total_bags = `Total Bags`,
           small_bags = `Small Bags`,
           large_bags = `Large Bags`,
           xlarge_bags = `XLarge Bags`,
           average_price = AveragePrice)

  # Creating columns for month and year-month
  df$month <- month(as.Date(df$date), label=TRUE)
  df$year_month <- as.POSIXct(df$date)
  df$year_month <- format(df$year_month, "%Y-%m")

  #
  # Split data into train/test sets
  #

  # set a random seed to reproducibility
  set.seed(123)

  # First, separate the dataset with average price as the target
  trainIndex_price <- createDataPartition(df$average_price,
                                          p=0.8,
                                          list=FALSE,
                                          times=1)

  train <- df[trainIndex_price, ]
  test <- df[-trainIndex_price, ]

  # Write data sets to feather files
  write_feather(train, file.path(dest_path, "train.feather"))
  write_feather(test, file.path(dest_path, "test.feather"))
}

main(docopt(doc))
