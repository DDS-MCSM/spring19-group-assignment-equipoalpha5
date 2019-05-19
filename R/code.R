#
#' Title - Initial configurations,
#' A new directory will be created if not exists, where data will be stored
#'
#' @return None
#' @export
#'
#' @examples
#' initial.config()
#'
initial.config <- function() {
  tini <- Sys.time()
  set.seed(666)
  dir.data <- file.path(getwd(), "data")
  if (!dir.exists(dir.data)) {
    print("[*] Create data directory")
    dir.create(dir.data)
  }
}


#' Title - Donwload data
#' This function will be used to download and read data in a csv format,
#' the param scansio.url is the url of the data
#' @return None
#' @export
#'
#' @examples
#' download.zipdata
#'
download.zipdata <- function() {
  maxmind.url <- "https://iscxdownloads.cs.unb.ca/iscxdownloads/ISCX-URL-2016/ISCXURL2016.zip"
  maxmind.file <- file.path(getwd(), "data", "maxmind.zip")
  download.file(url = maxmind.url, destfile = maxmind.file)
  zipfiles <- unzip(zipfile = maxmind.file, list = T)
  maxmind.source <- zipfiles$Name[grep(pattern = ".*All.csv", x = zipfiles$Name)]
  unzip(zipfile = maxmind.file, exdir = dir.data, files = maxmind.source)
  maxmind.source <- file.path(getwd(), "data", maxmind.source)
  df.maxmind <- read.csv(maxmind.source, stringsAsFactors = FALSE)
  rm(maxmind.file, zipfiles)
}

#' Title
#'
#' @param scope: Num of data that will be taken
#'
#' @return None
#' @export
#'
#' @examples
#' generate.df(500)
#' generate.df(1000)
#'
generate.df <- function(scope){
  muestra <- sample(1:nrow(df.maxmind), scope)
  df.scans <- df.maxmind[muestra,c(1:9,20:80)]
  rm(muestra)

}

#' Title - Function to clean data frame, the idea is to delete that that is not usefull for the analysis
#'
#' @return None
#' @export
#'
#' @examples
#' clean.df
#'
clean.df <- function(){

}
