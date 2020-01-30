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
  
  # Create transform region into lat and lon, transform month into season
  df <- df %>% 
    mutate(
      lat = case_when(
        region == 'Albany' ~ 42.652580,
        region == 'Atlanta' ~ 33.748997,
        region == 'BaltimoreWashington' ~ 38.975552,
        region == 'Boise' ~ 43.615021,
        region == 'Boston' ~ 42.360081,
        region == 'BuffaloRochester' ~ 43.0250469,
        region == 'California' ~ 37.1930971,
        region == 'Charlotte' ~ 35.2033533,
        region == 'Chicago' ~ 41.8339037,
        region == 'CincinnatiDayton' ~ 39.3908994,
        region == 'Columbus' ~ 39.9831302,
        region == 'DallasFtWorth' ~ 32.7429804,
        region == 'Denver' ~ 39.7645187,
        region == 'Detroit' ~ 42.3528795,
        region == 'GrandRapids' ~ 42.9564627,
        region == 'GreatLakes' ~ 45.0427191,
        region == 'HarrisburgScranton' ~ 40.957185,
        region == 'HartfordSpringfield' ~ 41.896674,
        region == 'Houston' ~ 29.8174782,
        region == 'Indianapolis' ~ 39.768402,
        region == 'Jacksonville' ~ 30.332184,
        region == 'LasVegas' ~ 36.169941,
        region == 'LosAngeles' ~ 34.052235,
        region == 'Louisville' ~ 38.252666,
        region == 'MiamiFtLauderdale' ~ 25.8961018,
        region == 'Nashville' ~ 36.186314,
        region == 'NewOrleansMobile' ~ 30.0329222,
        region == 'NewYork' ~ 40.6971494,
        region == 'NorthernNewEngland' ~ 44.117377,
        region == 'Orlando' ~ 28.4810971,
        region == 'Philadelphia' ~ 39.952583,
        region == 'PhoenixTucson' ~ 33.448376	,
        region == 'Pittsburgh' ~ 40.440624,
        region == 'Plains' ~  37.262032,
        region == 'Portland' ~ 45.523064,
        region == 'RaleighGreensboro' ~ 35.787743,
        region == 'RichmondNorfolk' ~ 37.541290,
        region == 'Roanoke' ~ 37.270969,
        region == 'Sacramento' ~ 38.575764,
        region == 'SanDiego' ~ 32.715736,
        region == 'SanFrancisco' ~ 37.733795,
        region == 'Seattle' ~ 47.608013,
        region == 'SouthCarolina' ~ 33.836082,
        region == 'Spokane' ~ 47.658779,
        region == 'StLouis' ~ 38.627003,
        region == 'Syracuse' ~ 43.088947,
        region == 'Tampa' ~ 27.964157,
        region == 'WestTexNewMexico' ~ 34.307144 
      )) %>% 
    mutate(
      lon = case_when(
        region == 'Albany' ~ -73.756233,
        region == 'Atlanta' ~ -84.387985,
        region == 'BaltimoreWashington' ~ -76.937737,
        region == 'Boise' ~ -116.202316,
        region == 'Boston' ~ -71.058884,
        region == 'BuffaloRochester' ~ -78.2144207,
        region == 'California' ~ -123.7969215,
        region == 'Charlotte' ~ -80.9799129,
        region == 'Chicago' ~ -87.8720473,
        region == 'CincinnatiDayton' ~ -84.3688404,
        region == 'Columbus' ~ -83.1309125,
        region == 'DallasFtWorth' ~ -97.5240348,
        region == 'Denver' ~ -104.995195,
        region == 'Detroit' ~ -83.2392883,
        region == 'GrandRapids' ~ -85.7301287,
        region == 'GreatLakes' ~ -88.694491,
        region == 'HarrisburgScranton' ~ -76.1568427,
        region == 'HartfordSpringfield' ~ -72.5898687,
        region == 'Houston' ~ -95.681478,
        region == 'Indianapolis' ~ -86.158066,
        region == 'Jacksonville' ~ -81.655647,
        region == 'LasVegas' ~ -115.139832,
        region == 'LosAngeles' ~ -118.243683,
        region == 'Louisville' ~ -85.758453,
        region == 'MiamiFtLauderdale' ~ -80.4848929,
        region == 'Nashville' ~ -87.0654302,
        region == 'NewOrleansMobile' ~ -90.0226481,
        region == 'NewYork' ~ -74.2598635,
        region == 'NorthernNewEngland' ~ -74.7945577,
        region == 'Orlando' ~ -81.5089233,
        region == 'Philadelphia' ~ -75.165222,
        region == 'PhoenixTucson' ~ -112.074036,
        region == 'Pittsburgh' ~ 	-79.995888,
        region == 'Plains' ~ -100.589760,
        region == 'Portland' ~ -122.676483,
        region == 'RaleighGreensboro' ~ -78.644257,
        region == 'RichmondNorfolk' ~  -77.434769,
        region == 'Roanoke' ~ -79.941429,
        region == 'Sacramento' ~ -121.478851,
        region == 'SanDiego' ~ -117.161087,
        region == 'SanFrancisco' ~ -122.446747,
        region == 'Seattle' ~ -122.335167,
        region == 'SouthCarolina' ~ -81.163727,
        region == 'Spokane' ~ -117.426048,
        region == 'StLouis' ~ -90.199402,
        region == 'Syracuse' ~ -76.154480,
        region == 'Tampa' ~ -82.452606,
        region == 'WestTexNewMexico' ~ -106.018066 
      )) %>% 
    mutate(
      season = case_when(
        month == 'Jan' ~ 'Winter',
        month == 'Feb' ~ 'Winter',
        month == 'Mar' ~ 'Spring',
        month == 'Apr' ~ 'Spring',
        month == 'May' ~ 'Spring',
        month == 'Jun' ~ 'Summer',
        month == 'Jul' ~ 'Summer',
        month == 'Aug' ~ 'Summer',
        month == 'Sep' ~ 'Fall',
        month == 'Oct' ~ 'Fall',
        month == 'Nov' ~ 'Fall',
        month == 'Dec' ~ 'Winter',
      )) %>% 
    filter(!is.na(lat) | !is.na(lon))

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
