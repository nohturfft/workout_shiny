#-------------------------------------------------------------------------------
# Clear memory; Detach packages; Clear console
#-------------------------------------------------------------------------------
rm(list=setdiff(ls(all=TRUE), c("gpx.loc", "scripts.loc", "proj.root", ".Random.seed")))
cat("\014")

#-------------------------------------------------------------------------------
# Load packages
#-------------------------------------------------------------------------------
library(shiny)
library(shinyjs)
library(magrittr)
library(dplyr)
library(xml2)
library(ggmap)
library(raster)


#-------------------------------------------------------------------------------
# Source code:
#-------------------------------------------------------------------------------
source(paste0(scripts.loc, "/gpx_files.source.R"))
source(paste0(scripts.loc, "/get_gpx_data.source.R"))
source(paste0(scripts.loc, "/get_google_map.source.R"))

#-------------------------------------------------------------------------------
# Get list of gpx data folders:
#-------------------------------------------------------------------------------
cat("Get list of gpx data folders: ...\n")
gpx.folders <- get_gpx_folders(gpx.loc)
gpx.files <- get_gpx_paths(gpx.folders[1])
print(gpx.files)

#-------------------------------------------------------------------------------
# Define server logic:
#-------------------------------------------------------------------------------
#cat("Define server logic: ...\n)
shinyServer(function(input, output, session) {
  cat("Starting function: shinyServer() ...\n")
  cat("... define reactive values\n")
  rv <- reactiveValues(gpx.folder.selected.path = gpx.folders[1],
                       gpx.folder.selected.name = names(gpx.folders[1]),
                       gpx.file.list.selected   = gpx.files,
                       gpx.file.selected.path   = gpx.files[[1]],
                       gpx.file.selected.name   = names(gpx.files[[1]]),
                       zoom                     = 14,
                       df                       = NULL)

  cat("... populate selectInput: in_gpx_folder\n")
  updateSelectInput(session, "in_gpx_folder", choices = names(gpx.folders))
  
  cat("... populate selectInput: in_gpx_file\n")
  updateSelectInput(session, "in_gpx_file", choices = names(get_gpx_paths(gpx.folders[1])))
  
  # Change choice of gpx files if folder is changed
  observeEvent(input$in_gpx_folder,  {
    cat("\nStart observeEvent: input$in_gpx_folder ...\n")
    rv$gpx.folder.selected.name <- input$in_gpx_folder
    rv$gpx.folder.selected.path <- gpx.folders[rv$gpx.folder.selected.name]
    rv$gpx.file.list.selected <- get_gpx_paths(rv$gpx.folder.selected.path)
    cat("rv$gpx.folder.selected.name\n")
    print(rv$gpx.folder.selected.name)
    cat("rv$gpx.folder.selected.path\n")
    print(rv$gpx.folder.selected.path)
    cat("rv$gpx.file.list.selected\n")
    print(rv$gpx.file.list.selected)
    updateSelectInput(session, "in_gpx_file",
                      choices = names(rv$gpx.file.list.selected))
  }, ignoreInit = TRUE)

  observeEvent(input$zoom, {rv$zoom <- input$zoom})

  observeEvent(input$in_gpx_file, {
    cat("\nStart observeEvent: input$in_gpx_file ...\n")
    rv$gpx.file.selected.name <- input$in_gpx_file
    rv$gpx.file.selected.path <- rv$gpx.file.list.selected[rv$gpx.file.selected.name]
    if (have_internet()) {
      shinyjs::hide(id="plottext")
      output$plottext <- renderText("")
      rv$df <- get.gpx.data(rv$gpx.file.selected.path)
      print(head(rv$df, 4))
      # output$plot <- renderPlot(plot.google.map(rv$df))
      output$plot <- renderPlot(plot.google.map(rv$df, my.zoom=rv$zoom))
    } else {
      shinyjs::show(id="plottext")
      output$plottext <- renderText("No internet connection (required to generate map)")
    }
  }, ignoreInit = TRUE)

  
  
  
  
  
  # gpx.folder.selected <- reactive({
  #   cat("gpx.folder.selected ... \n")
  #   input$in_gpx_folder
  # })
  # updateSelectInput(session, "in_gpx_file",
  #                   choices = names(get_gpx_paths(gpx.folder.selected())))
  
  # Reactive expression to generate the requested distribution ----
  # This is called whenever the inputs change. The output functions
  # defined below then use the value computed from this expression
  # d <- reactive({
  #   print("starting reactive")
  #   dist <- switch(input$dist,
  #                  norm = rnorm,
  #                  unif = runif,
  #                  lnorm = rlnorm,
  #                  exp = rexp,
  #                  rnorm)
  #   
  #   dist(input$n)
  # })
  
  # Generate a plot of the data ----
  # Also uses the inputs to build the plot label. Note that the
  # dependencies on the inputs and the data reactive expression are
  # both tracked, and all expressions are called in the sequence
  # implied by the dependency graph.
  # output$plot <- renderPlot({
  #   dist <- input$dist
  #   n <- input$n
  #   
  #   hist(d(),
  #        main = paste("r", dist, "(", n, ")", sep = ""),
  #        col = "#75AADB", border = "white")
  # })
  
  # Generate a summary of the data ----
  # output$summary <- renderPrint({
  #   summary(d())
  # })
  # 
  # # Generate an HTML table view of the data ----
  # output$table <- renderTable({
  #   d()
  # })
  
})

# Cannot open:
# http://maps.googleapis.com/maps/api/staticmap?center=51.233304,-0.357482&zoom=14&size=640x640&scale=2&maptype=terrain&sensor=false
# http://maps.googleapis.com/maps/api/staticmap?center=51.233304,-0.357482&zoom=14&size=640x640&scale=2&maptype=terrain&sensor=false
# http://maps.googleapis.com/maps/api/staticmap?center=51.233304,-0.357482&zoom=14&size=640x640&scale=2&maptype=terrain&sensor=false
# http://maps.googleapis.com/maps/api/staticmap?center=51.233099,-0.370846&zoom=14&size=640x640&scale=2&maptype=terrain&sensor=false
# Can open:
# http://maps.googleapis.com/maps/api/staticmap?center=51.233304,-0.357482&zoom=14&size=640x640&scale=2&maptype=terrain&sensor=false
# http://maps.googleapis.com/maps/api/staticmap?center=51.233099,-0.370846&zoom=14&size=640x640&scale=2&maptype=terrain&sensor=false
# http://maps.googleapis.com/maps/api/staticmap?center=51.233099,-0.370846&zoom=14&size=640x640&scale=2&maptype=terrain&sensor=false | 2018-04-19-1935
# http://maps.googleapis.com/maps/api/staticmap?center=51.233304,-0.357482&zoom=14&size=640x640&scale=2&maptype=terrain&sensor=false
# 
# curl::curl_download("http://maps.googleapis.com/maps/api/staticmap?center=51.233304,-0.357482&zoom=14&size=640x640&scale=2&maptype=terrain&sensor=false", destfile="tmp.png")
# curl::curl_download("http://maps.googleapis.com/maps/api/staticmap?center=51.233099,-0.370846&zoom=14&size=640x640&scale=2&maptype=terrain&sensor=false", destfile="tmp2.png")
