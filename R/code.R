# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

#scansio.url <- "https://opendata.rapid7.com/sonar.tcp/2019-04-04-1554350684-ftp_21.csv.gz"
scansio.url <- "https://iscxdownloads.cs.unb.ca/iscxdownloads/ISCX-URL-2016/ISCXURL2016.zip"
scope <- 500
#' Title
#'
#' @return
#' @export
#'
#' @examples
initial.config <- function() {
  tini <- Sys.time()
  set.seed(666)
  dir.data <- file.path(getwd(), "data")
  if (!dir.exists(dir.data)) {
    print("[*] Create data directory")
    dir.create(dir.data)
  }
}
#' Title
#'
#' @return
#' @export
#'
#' @examples
download.csvdata <- function() {
  scansio.source <- file.path(getwd(), "data","scans.io.tcp21.csv")
  scansio.file.gz <- paste(scansio.source, ".gz", sep = "")
  download.file(url = scansio.url, destfile = scansio.file.gz)
  R.utils::gunzip(scansio.file.gz)
  df <- read.csv(scansio.source, stringsAsFactors = FALSE)
  rm(scansio.file.gz)
  sumarry()}

#' Title
#'
#' @return
#' @export
#'
#' @examples
download.zipdata <- function() {
  maxmind.url <- "https://geolite.maxmind.com/download/geoip/database/GeoLite2-City-CSV.zip"
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
#' @param nrows
#'
#' @return
#' @export
#'
#' @examples
generate.df <- function(nrows){
  muestra <- sample(1:nrow(df.maxmind), scope)
  df.scans <- df.maxmind[muestra,c(1:9,20:80)]
  rm(muestra)

}

#' Title
#'
#' @return
#' @export
#'
#' @examples
clean.df <- function(){

}
