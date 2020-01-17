# author: Ryan Homer
# date: 2020-01-16
#
"Fetch a Kaggle dataset to a specified path.

If you have a `kaggle.json` authentication file, you do not need to specify `username` or `key`.

Usage: get_kaggle_dataset.R [--username=<Kaggle username> --key=<Kaggle API key>] --dataset=<dataset> [--unzip --force] <path>

Options:
<username>    Your Kaggle username.
<key>         Your Kaggle API key
<dataset>     The Kaggle dataset name (in the form `account_name/dataset_name`)
<path>        The path of the destination folder
<unzip>       Unzip archive (deletes archive after extraction)
<force>       Skip check whether local version of file is up to date, force file download
" -> doc

library(docopt)

main <- function(opt) {
  if (!is.null(opt$username) && !is.null(opt$key)) {
    Sys.setenv(KAGGLE_USERNAME = opt$username,
               KAGGLE_KEY = opt$key)

    print(Sys.getenv("KAGGLE_USERNAME"))
    print(Sys.getenv("KAGGLE_KEY"))
  }

  # Prepare system command and execute
  command <- "kaggle datasets download"
  if (!is.null(opt$unzip)) {
    command <- paste(command, "--unzip")
  }
  if (!is.null(opt$force)) {
    command <- paste(command, "--force")
  }
  if (!is.null(opt$path)) {
    command <- paste(command, "-p", opt$path)
  }
  command <- paste(command, opt$dataset)
  system(command)
}

opt <-docopt(doc)
main(opt)
