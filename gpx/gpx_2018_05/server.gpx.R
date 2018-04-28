#-------------------------------------------------------------------------------
# Clear memory; Detach packages; Clear console
#-------------------------------------------------------------------------------
rm(list=setdiff(ls(all=TRUE), c("gpx.loc", "scripts.loc", "proj.root", ".Random.seed")))
cat("\014")

#-------------------------------------------------------------------------------
# Load packages
#-------------------------------------------------------------------------------
library(shiny)
library(magrittr)
library(dplyr)
library(xml2)
library(ggmap)
library(raster)

#-------------------------------------------------------------------------------
# Get list of gpx data folders:
#-------------------------------------------------------------------------------
source(paste0(scripts.loc, "/gpx_files.source.R"))
gpx.folders <- get_gpx_folders(gpx.loc)
gpx.folders

#-------------------------------------------------------------------------------
# Define server logic
#-------------------------------------------------------------------------------
shinyServer(function(input, output, session) {
  
  updateSelectInput(session, "in_gpx_folder", choices = gpx.folders)
  gpx.folder.selected <- reactive(input$in_gpx_folder)
  updateSelectInput(session, "in_gpx_file",
                    choices = names(get_gpx_paths(gpx.folder.selected())))
  
  # Reactive expression to generate the requested distribution ----
  # This is called whenever the inputs change. The output functions
  # defined below then use the value computed from this expression
  d <- reactive({
    print("starting reactive")
    dist <- switch(input$dist,
                   norm = rnorm,
                   unif = runif,
                   lnorm = rlnorm,
                   exp = rexp,
                   rnorm)
    
    dist(input$n)
  })
  
  # Generate a plot of the data ----
  # Also uses the inputs to build the plot label. Note that the
  # dependencies on the inputs and the data reactive expression are
  # both tracked, and all expressions are called in the sequence
  # implied by the dependency graph.
  output$plot <- renderPlot({
    dist <- input$dist
    n <- input$n
    
    hist(d(),
         main = paste("r", dist, "(", n, ")", sep = ""),
         col = "#75AADB", border = "white")
  })
  
  # Generate a summary of the data ----
  output$summary <- renderPrint({
    summary(d())
  })
  
  # Generate an HTML table view of the data ----
  output$table <- renderTable({
    d()
  })
  
})