# authors: Katie Birchard, Ryan Homer, Andrea Lee
# date: 2020-01-18
#
"Create report assets for collinearity analysis.

Usage: mc_create_assets.R --datafile=<path to CSV data file> --out=<path to output directory>

Options:
<datafile> Path to the CSV file, including the actual filename.
<out>      The destination path to write the feather files to.
" -> doc

library(docopt)
suppressMessages(library(tidyverse))
suppressMessages(library(lubridate))
suppressMessages(library(caret))
suppressMessages(library(feather))
suppressMessages(library(reshape2))
suppressMessages(library(kableExtra))
suppressMessages(library(car))
source(here::here("src/multicoll/support_functions.R"))

main <- function(args) {
  check_args(args)
  create_assets(args$datafile, args$out)
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

#' Create assets
#'
#' @param datafile Path to the CSV file, including the actual filename.
#' @param out The destination path to write the feather files to.
create_assets <- function(datafile, out) {
  dest_path <- path.expand(out)

  # Read data from CSV
  df <- read_feather(path.expand(datafile))

  # correlation matrix
  p <- df %>%
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
    mutate(value = round(value, 2)) %>%
    ggplot() +
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

    ggsave("correlation_matrix.png", p, path = dest_path)


    # multicollinearity table
    webshot::install_phantomjs()
    lm(average_price ~ total_volume + PLU_4046 + PLU_4225 + PLU_4770 + total_bags + small_bags + large_bags + xlarge_bags,
       data = df) %>%
      vif() %>%
      enframe() %>%
      pivot_wider(id_cols = "name") %>%
      kable("html") %>%
      kable_styling() %>%
      save_kable(file = file.path(dest_path, "collinearity.png"))
}

main(docopt(doc))
