# authors: Katie Birchard, Ryan Homer, Andrea Lee
# date: 2020-01-18
#
"Conduct hypothesis test and save figures.

Usage: conduct_hypothesis_test.R --datafile=<path to the dataset> --out=<path to output directory>

Options:
<datafile>      Complete URL to the feather dataset.
<out> The destination path to save the hypothesis test figures.
" -> doc

suppressMessages(library(docopt))
suppressMessages(library(tidyverse))
suppressMessages(library(feather))
suppressMessages(library(kableExtra))
suppressMessages(library(broom))

main <- function(args) {
  check_args(args)
  make_plot(args$datafile, args$out)
  make_table(args$datafile, args$out)
}

check_args <- function(args) {
  #' Check input args
  #'
  #' @param args Vector of args from docopt

  if (!file.exists(path.expand(args$datafile))) {
    stop("Unable to find datafile.")
  }
  
  # make sure path exists
  if (!dir.exists(path.expand(args$out))) {
    dir.create(path.expand(args$out), recursive = TRUE)
  }
}

make_plot <- function(datafile, out) {
  #' Create plot and save plot as image.
  #' 
  #' @param datafile Path to the feather file, including the actual filename.
  #' @param out The destination path to save the images to to.
  #' @return png file of plot.
  
  dest_path <- path.expand(out)
  
  # Read in data
  avocado <- read_feather(datafile)
  
  # Fit model
  model <- lm(average_price ~ total_volume + PLU_4046 + PLU_4225 + PLU_4770 + total_bags + small_bags + large_bags + xlarge_bags + type + year + lat + lon + season, data = avocado)
  
  # Make residual plot
  plot <- ggplot(model, aes(x = model$fitted.values, y = model$residuals)) +
    geom_point(colour= "cadetblue", alpha=0.1) +
    labs(title = 'Residual Plot (Linear Model)', x = "Predicted Values", y = "Residuals") +
    theme_minimal()
  
  # Save plot as png
  ggsave('residual_plot.png',  plot, path = file.path(dest_path))
}

make_table <- function(datafile, out) {
  #' Create table and save table as image.
  #' 
  #' @param datafile Path to the feather file, including the actual filename.
  #' @param out The destination path to save the images to to.
  #' @return png file of table.

  dest_path <- path.expand(out)
  
  # Read in data
  avocado <- read_feather(datafile)
  
  # Fit model
  model <- lm(average_price ~ total_volume + PLU_4046 + PLU_4225 + PLU_4770 + total_bags + small_bags + large_bags + xlarge_bags + type + year + lat + lon + season, data = avocado)
  
  # Conduct hypothesis test and save table as png
  write_csv(tidy(model), path = file.path(dest_path, 'hypothesis_test_table.csv'))
  
  #p_val <- kable(tidy(model), 
  #               caption = "Table 1. Hypothesis Test Table.") %>% 
  #  as_image(file = file.path(dest_path, 'hypothesis_test_table.png'))
  
}
  
main(docopt(doc))
