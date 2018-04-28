get.center <- function(the.range) {
  range(the.range) %>% mean
}

have_internet <- function(){
  !is.null(curl::nslookup("r-project.org", error = FALSE))
}

# help(package="ggmap")
get_googlemap
# http://maps.googleapis.com/maps/api/staticmap?center=51.233099,-0.370846&zoom=14&size=640x640&scale=2&maptype=terrain&sensor=false
plot.google.map <- function(df, my.zoom=14) {
  cat("\nStarting function: plot.google.map() ...\n")
  # my.zoom=14
  cat("... download map ...\n")
  mapImageData <- get_googlemap(center = c(lon = get.center(df$longitude), lat = get.center(df$latitude)),
                                zoom = my.zoom,
                                # size = c(500, 500),
                                maptype = c("terrain"),
                                archiving = TRUE)
  cat("... create map plot ...\n")
  gg <- ggmap(mapImageData,
        extent = "device") + # takes out axes, etc.
    geom_point(aes(x = longitude,
                   y = latitude),
               data = df,
               colour = "red",
               size = 1,
               pch = 20)
  cat("... about to exit function: plot.google.map()\n")
  return(gg)
}

