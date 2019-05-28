#' PhisTank
#' Ref: https://www.phishtank.com/developer_info.php
#' http://data.phishtank.com/data/online-valid.csv
#'
#'
library(httr)
library(plyr)
library(leaflet)

#' Download source data to local file
#'
#'
#'
#' @param dstpath path where source data will be stored, tempdir set as default.
#'
#' @return character, local path of downloaded file
DownloadPTDData <- function(dstpath = tempdir()){
  local.file <- paste(dstpath, "phishtank.txt",
                      sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))
  source.raw.data <- "http://data.phishtank.com/data/online-valid.csv"
  download.file(url = source.raw.data, destfile = local.file)
  return(local.file)
}


#' Title
#'
#' @param dstpath
#'
#' @return
#' @export
#'
#' @examples
geolocate_ip <- function(df){


  load("C:/Users/eeamoreno/Desktop/PracticaDriven/final/data/maxmind.rda")
  # Seleccionamos una muestra de scans
  df$ip.num <- iptools::ip_to_numeric(df$ip)



  # Usamos multiples cpu's para geolocalizar IPs en rangos
  if (verbose) print("[*] Foreach IP (source and destination) identify network range using parallel computing")
  no_cores <- parallel::detectCores() - 1
  cl <- parallel::makeCluster(no_cores)
  parallel::clusterExport(cl, "df.maxmind")
  df$sloc <- sapply(df$ip.num,
                          function(ip)
                            which((ip >= df.maxmind$min_numeric) &
                                    (ip <= df.maxmind$max_numeric)))

  parallel::stopCluster(cl)
  rm(cl, no_cores)

  # convert list with rang row number and failed detections to numeric
  df$sloc2 <- as.numeric(df$sloc)
  # Join and tidy data frame (source address)
  if (verbose) print("[*] Joining source IP's with geolocation data")
  df <- dplyr::left_join(df, df.maxmind, by = c("sloc2" = "rowname"))
  df <- dplyr::select(df, timestamp_ts, saddr, latitude, longitude, accuracy_radius,
                      is_anonymous_proxy, is_satellite_provider)
  names(df) <- c("timestamp", "hostname", "ip", "target", "online", "ip_num", "sloc2", "slatitude", "slongitude") #elegir parametros
               #  "accuracy_radius", "is_anonymous_proxy", "is_satellite_provider")

  # Join and tidy data frame (destination address)
  # if (verbose) print("[*] Joining destination IP's with geolocation data")
  # suppressMessages(library(dplyr))
  # df.dst <- df %>%
  #   left_join(df.maxmind, by = c("dloc" = "rowname")) %>%
  #   select(daddr, latitude, longitude)
  # names(df.dst) <- c("daddr", "dlatitude", "dlongitude")
  # df <- dplyr::bind_cols(df, df.dst)
  # rm(df.dst, df)

  # Set categoric variables as factors
  #if (verbose) print("[*] Tidy data and save it")
  #df$is_anonymous_proxy <- as.factor(df$is_anonymous_proxy)
  #df$is_satellite_provider <- as.factor(df$is_satellite_provider)
  saveRDS(object = df, file = file.path(getwd(), "data", "maxmindoutput.rda"))

  #return dataframe
  return(df)
}

#' Read raw data and returns as data.frame
#'
#' @param local.file
#'
#' @return data.frame
BuildPTDDataFrame <- function(local.file = paste(tempdir(),
                                                 "phishtank.txt",
                                                 sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))){
  df <- read.csv(file = local.file, header = T,
                 colClasses = c("integer", "character", "character", "character", "factor", "character", "factor", "factor"))

  return(df)
}


#' Title
#'
#' @param dowload.time
#'
#' @return
#' @export
#'
#' @examples
GetPTDData <- function(dowload.time = Sys.time()){
  #Descargamos el data set
  lf <- DownloadPTDData()

  #Leemos el data set para crear el df
  df <- BuildPTDDataFrame(local.file = lf)

  #Limpiamos el data frame objectives
  df.urls <- dplyr::select(df,submission_time,url,target,online)

  #declara df donde se guardaran el hostname, ip, target y timestamp
  df.ipdomain <- data.frame("timestamp" = character(0), "hostname" = character(0), "ip" = character(0), "target" = character(0), "online" = character(0), stringsAsFactors=FALSE)

   #recorrer df de hostnames para encontrar la ip a partir de la url del pishing
  for(i in 1:nrow(df.urls)) {

     #parseamos la url para quedarnos solo con el dominio
     array <- parse_url(df.urls[i,2])

     print(array$hostname)

     #pasamos de hostname a ip
     ip <- iptools::hostname_to_ip(array$hostname)

     #puede devolver mas de una ip asi que cojemos la primera de la lista
     print(ip[[1]][1])
     #df with ips and domain
     fila <- data.frame("timestamp" = df.urls[i,1],"hostname" = array$hostname,"ip" = ip[[1]][1], "target" = df.urls[i,3], "online" = df.urls[i,4])

     #añadimos la nueva fila al df
     df.ipdomain <- rbind(df.ipdomain, fila)
  }

  rm(array)
  rm(fila)
  rm(ip)
  rm(df)
  rm(df.objectives)
  rm(df.urls)
  df.ipdomain <- as.character(df.ipdomain$ip)
  saveRDS(object = df.ipdomain, file = file.path(getwd(), "data", "ipdomain.rda"))
  return(df.ipdomain)

}

#' Title
#'
#' @return
#' @export
#'
#' @examples
getIpGeolocated <- function(){

  load <- TRUE
  if (load) {
    load("C:/Users/eeamoreno/Desktop/PracticaDriven/final/data/ipdomainDF.rda")
  }else{
    df <- GetPTDData()
  }

  map.locations <- getIpGeolocated(df.2)

  m <- leaflet(df) %>% addMarkers(popup = df$target)
  m <- leaflet(df) %>% addCircleMarkers(popup = df$target, fillColor = )
  m <- addTiles(m)
 # m <- addMarkers(m, lng=174.768, lat=-36.852, popup="The birthplace of R")
  m
}


#' Title
#'
#' @return
#' @export
#'
#' @examples
getCountTarget <- function(){
  load <- TRUE
  if (load) {
    load("C:/Users/eeamoreno/Desktop/PracticaDriven/final/data/ipdomainDF.rda")
  }else{
    df <- GetPTDData()
  }

  #df donde se hace un count para ver el numero de ataques recibidos por empresa
  df.countTarget <- plyr::count(df, c("target"))
  dplyr::arrange(df.countTarget, desc(freq))
  summary(df.countTarget)

}

#' Title
#'
#' @return
#' @export
#'
#' @examples
getCountDomains <- function(){
  load <- TRUE
  if (load) {
   df.ipdomain <- load("C:/Users/eeamoreno/Desktop/PracticaDriven/final/data/ipdomainDF.rda")
  }else{
    df.ipdomain <- GetPTDData()
  }
  #df donde hacemos un count de los diferentes hostnames existentes
  df.countDomains <- plyr::count(df.ipdomain, c("hostname"))
  dplyr::arrange(df.countDomains, desc(freq))
  summary(df.countDomains)

}


