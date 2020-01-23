# authors: Katie Birchard, Ryan Homer, Andrea Lee
# date: 2020-01-18
# Rscript src/conduct_hypothesis_test.R --datafile=data/train.feather --out=doc/img
"Conduct hypothesis test and save figures.

Usage: render_EDA.R --datafile=<path to the dataset> --out=<path to output directory>

Options:
<datafile>      Complete URL to the dataset.
<out> The destination path to save the EDA figures.
" -> doc

suppressMessages(library(docopt))
suppressMessages(library(tidyverse))
suppressMessages(library(lubridate))
suppressMessages(library(caret))
suppressMessages(library(knitr))
suppressMessages(library(ggpubr))
suppressMessages(library(feather))
suppressMessages(library(kableExtra))

main <- function(args) {
  check_args(args)
  make_plot(args$datafile, args$out)
  make_table(args$datafile, args$out)
}

check_args <- function(args) {
  if (!file.exists(path.expand(args$datafile))) {
    stop("Unable to find datafile.")
  }
  
  # make sure path exists
  if (!dir.exists(path.expand(args$out))) {
    dir.create(path.expand(args$out), recursive = TRUE)
  }
}

make_plot <- function(datafile, out) {
  dest_path <- path.expand(out)
  
  # Read in data
  avocado <- read_feather(datafile)
  
  model = lm(average_price ~ total_volume + PLU_4046 + PLU_4225 + PLU_4770 + total_bags + small_bags + large_bags + xlarge_bags + type + year + region + month, data = avocado)
  
  plot <- ggplot(model, aes(x = model$fitted.values, y = model$residuals)) +
    geom_point(colour= "cadetblue", alpha=0.1) +
    labs(title = 'Residual Plot', x = "Predicted Values", y = "Residuals") +
    theme_minimal()
  
  ggsave('residual_plot.png',  plot, path = file.path(dest_path))
}

make_table <- function(datafile, out) {
  dest_path <- path.expand(out)
  
  # Read in data
  avocado <- read_feather(datafile)
  
  model = lm(average_price ~ total_volume + PLU_4046 + PLU_4225 + PLU_4770 + total_bags + small_bags + large_bags + xlarge_bags + type + year + region + month, data = avocado)
  
  anova = kable(anova(model), 
                caption = "Table 1. Anova Table.") %>% 
          as_image(file = file.path(dest_path, 'anova_table.png'))
}

main(docopt(doc))