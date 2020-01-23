# authors: Katie Birchard, Ryan Homer, Andrea Lee
# date: 2020-01-18
# Rscript src/render_EDA.R --datafile=data/train.feather --out=doc
"Fetch a dataset to a specified path.
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

main <- function(args) {
  check_args(args)
  make_plot(args$datafile, args$out)
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
  priceTrain <- read_feather(datafile)
  
  # What is the average avocado price per region?
  avocado_by_region <- priceTrain %>%
    group_by(region) %>%
    summarize(ave_price = mean(average_price))
  # There are many regions here, so it might make sense to group them
  price_per_region <- ggplot(avocado_by_region, aes(x=reorder(region, -ave_price), y=ave_price)) +
    geom_col(fill="darkblue", alpha=0.5, colour="darkblue") +
    xlab("Regions") +
    ylab("Average Price") +
    ggtitle("Region") +
    theme_bw() +
    theme(axis.text.x = element_text(angle=90, size = 5),
          axis.title.x = element_blank()) 
  
  # What is the average avocado price by type (organic vs. non-organic)
  avocado_by_type <- priceTrain %>%
    group_by(type) %>%
    summarize(ave_price = mean(average_price))
  price_per_type <- ggplot(avocado_by_type, aes(x=reorder(type, -ave_price), y=ave_price)) +
    geom_col(fill="darkblue", alpha=0.5, colour="darkblue") +
    xlab("Type") +
    ylab("Average Price") +
    ggtitle("Type") +
    theme_bw() +
    theme(axis.title.x = element_blank())
  
  # What is the average price per month?
  avocado_by_month <- priceTrain %>%
    group_by(month) %>%
    summarize(ave_price = mean(average_price))
  price_per_month <- ggplot(avocado_by_month, aes(x=month, y=ave_price)) +
    geom_col(fill="darkblue", alpha=0.5, colour="darkblue") +
    xlab("Month") +
    ylab("Average Price") +
    ggtitle("Month") +
    theme_bw() +
    theme(axis.title.x = element_blank())
  
  # Does average price correlate with number total sold?
  price_per_sold <- ggplot(priceTrain, aes(x=no_sold, y=average_price)) +
    geom_point(alpha=0.2, colour="darkblue") +
    ylab("Average Price") +
    xlab("Number Sold") +
    ggtitle("Number sold each week") +
    theme_bw() +
    theme(axis.title.x = element_blank())
  
  plot <- gridExtra::arrangeGrob(price_per_region, price_per_type,
                          price_per_month, price_per_sold,
                          ncol=2, nrow=2)

  ggsave('EDA_plot.png',  plot, path = file.path(dest_path))
}

main(docopt(doc))