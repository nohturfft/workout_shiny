get.gpx.data <- function(gpx.file) {
  cat("Starting function: get.gpx.data()\n")
  # gpx.file <- "/Users/axelair/Dropbox/Correspondence/Private/Health_and_Exercise/Runkeeper/workout_shiny/gpx/gpx_2018_04/2018-04-19-1935.gpx"
  print(gpx.file)
  stopifnot(file.exists(gpx.file))
  x1 <- read_xml(gpx.file)
  a <- as_list(x1)
  
  trkseg <- a$gpx$trk$trkseg
  
  elevation <- sapply(trkseg, function(seg) {seg$ele[[1]]}) %>% as.numeric
  date <- sapply(trkseg, function(seg) {
    seg$time[[1]] %>% strsplit(., split="T") %>% .[[1]] %>% .[[1]]
  }) #%>% as.numeric
  time <- sapply(trkseg, function(seg) {
    seg$time[[1]] %>% strsplit(., split="T") %>% .[[1]] %>% .[[2]] %>% sub("Z$", "", .)
  }) #%>% as.numeric
  hr <- sapply(trkseg, function(seg) {
    seg$extensions[[1]][[1]][[1]] %>% as.numeric
  }) #%>% as.numeric
  hr
  latitude <- sapply(trkseg, function(seg) {
    attr(seg, "lat") %>% as.numeric
  })
  longitude <- sapply(trkseg, function(seg) {
    attr(seg, "lon") %>% as.numeric
  })
  
  df <- data.frame(date=date, time=time, elevation=elevation, hr=hr, latitude=latitude, longitude=longitude)
  df$time <- strptime(df$time, "%H:%M:%S")
  head(df)
  df
}

