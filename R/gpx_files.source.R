# Function to get list of available gpx files


get_gpx_folders <- function(gpx.folder) {
  # gpx.folder = gpx.loc
  # if (gpx.folder == "") return(unlist(list(EmptyVector="")))
  d <- list.dirs(path=gpx.folder, full.names = TRUE)
  d <- d[-which(d == gpx.folder)]
  names(d) <- basename(d)
  d
}

get_gpx_paths <- function(gpx.folder) {
  # gpx.folder = "/Users/axelair/Dropbox/Correspondence/Private/Health_and_Exercise/Runkeeper/workout_shiny/gpx/gpx_2018_04"
  # if (gpx.folder == "") return(unlist(list(EmptyVector="")))
  cat("Starting function: get_gpx_paths()\n")
  print(gpx.folder)
  g <- list.files(path=gpx.folder, full.names = TRUE, pattern="\\.gpx$")
  names(g) <- basename(g)
  g
}

