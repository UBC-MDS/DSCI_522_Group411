# author: Ryan Homer
# date: 2020-01-18
#
"Fetch a dataset to a specified path.

Usage: get_dataset.R --url=<URL to the dataset> --destfile=<local file path> [--quiet]

Options:
<url>      Complete URL to the dataset.
<destfile> The destination path, including the filename.
<quiet>    Suppress output.
" -> doc

library(docopt)
suppressMessages(library(RCurl))

main <- function(opt) {
  # if we make it here, we are guaranteed by docopt to have `url`, `destfile` and `quiet` args,
  # so no need to use `is.null`
  if (!url.exists(opt$url)) {
    stop("Unable to access URL!")
  }

  download.file(opt$url, destfile = opt$destfile, quiet = opt$quiet)
}

opt <-docopt(doc)
main(opt)
