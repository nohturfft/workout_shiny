cat("\014")
message("\n** HELLO AND WELCOME TO THE SHINY WORKOUT PROJECT! **")
# lib.loc <- "packages"
# styles.loc <- "styles"
gpx.loc <- "gpx"

proj.root <- rprojroot::find_rstudio_root_file()
# file.exists(proj.root)

for (foldr in c(gpx.loc, proj.root)) {
  if(!file.exists(foldr)) {
    message(paste("Error in .Rprofile. This folder does not exist:", foldr))
    # exit
  }
}
rm(foldr)

gpx.loc <- paste(proj.root, gpx.loc, sep="/")
# styles.loc <- paste(proj.root, styles.loc, sep="/")