library(shiny)
library(shinyWidgets)
library(DT)
library(leaflet)
#library(sf)
library(leaflet.extras)
#library(rcartocolor)
source("dataset.R")

# Define UI for application that shows ratings of London restaurants
shinyApp(
ui <- fillPage(
  tags$head(
    tags$style(
      ".control-label {margin-left: 1%; width: 400px; font-family: Lato; color:gray; }",
      ".item {font-family: Lato; color:dimgray;}",
      ".row {height: 100%; width: 100vw; background: #ffffff;}",
      "#mymap{ background:#ffffff ; outline: 0; margin-top:20px}",
      "div.form-group.shiny-input-container {height: 40px; }",
      "div.info.legend.leaflet-control {font-weight:100; font-family: Lato; color: gray; font-size:10px }",
      "#desc {margin-left: 2%; color: gray; font-family: Lato, width: 300px;}",
      "#helptext {margin-left: 2%; color: gray; font-family: Lato, width: 300px;}",
      "html, body {width:100%;height:100%;overflow:visible;}"
    )
  ),
  
  h3(id="big-heading", "Where should you eat in the UK?"),
  tags$style(HTML("#big-heading{margin-left: 2%; color: gray; font-family: Lato, width: 400px; margin-bottom: 5px}")),
  p(id ="helptext", helpText("Knowing restaurant's food hygiene ratings could help.")),
  tags$style(HTML("#helptext{margin-left: 2%; color: gray; font-family: Lato, width: 400px; margin-bottom: 5px}")),
  
  
  mainPanel(
    tags$head(tags$style(HTML('.container-fluid {width: 100vw; padding: 0, margin 0 auto;}'))),
    fluidRow(
      column(4,
             selectInput('region', 'Select Region', unique(rest_data$RegionName), selectize = TRUE)),
         
    column(4,
           selectInput('county', '', choices = NULL, selectize = TRUE)),
    
    column(4,
           selectInput('type', '', choices = NULL, selectize = TRUE))
  ),
  
    fluidRow(column(width = 12,
                    leafletOutput("mymap", "100%", "600"))),
    
    fluidRow(column(width = 5,
                    p(textOutput("desc")))),
  
  h6(id ="helptext1", helpText("Source: Food Standards Agency")),
  tags$style(HTML("#helptext1{margin-left: 2%; color: lightgray; font-family: Lato, width: 400px; margin-bottom: 5px}"))
  
  )
),

# Define server logic required to draw a histogram
server <- function(input, output, session) {

  observeEvent(input$region,{
    updateSelectInput(session,'county',
                      choices=c("Select County", rest_data %>% 
                                  filter(RegionName == input$region) %>% 
                                  distinct(Authority))) })
  
  observeEvent(input$county,{
    updateSelectInput(session,'type',
                      choices=c("Select type", rest_data %>% 
                                  filter(Authority == input$county) %>% 
                                  distinct(type))) })
      
  
  # This reactive expression represents the palette function,
  # which changes as the user makes selections in UI.
  
output$mymap <- renderLeaflet({
  
    leaflet(rest_data) %>% 
    addProviderTiles(providers$OpenStreetMap.DE) %>% 
    setView(lng = 1.1743, lat = 52.3555, zoom = 6)
       
   })


filteredData <- reactive({

  df <- rest_data %>% 
      filter(RegionName == input$region) %>% 
      filter(Authority == input$county) %>% 
      filter(type == input$type)
  return (df)    
      
    })


observe({
  
  getColor <- function(data) {
    sapply(filteredData()$Ratings, function(Ratings) {
      if(Ratings <= 3) {
        "red"
      } 
      else if(Ratings == 4) {
        "orange" }
      
      else if(Ratings == 5) {
        "green" }
    })
  }
  
  icons <- awesomeIcons(
    icon = 'ios-close',
    iconColor = 'black',
    library = 'ion',
    markerColor = getColor(filteredData())
  )
  
  mymap_proxy <- leafletProxy("mymap", data = filteredData()) %>% 
    clearMarkers() %>% 
    addAwesomeMarkers(filteredData()$long, filteredData()$lat, icon = icons, popup = paste("<b>",filteredData()$name,"</b>", "<br>",
                                                                                          "<b>","Type:","</b>", filteredData()$type, "<br>",
                                                                                          "<b>","Food hygiene ratings:","</b>",filteredData()$Ratings, "<br>",
                                                                                          "<b>","Postcode:","</b>", filteredData()$postcode)%>% lapply(htmltools::HTML)) %>% 
    flyToBounds(lng1 = max(filteredData()$long), lng2 = min(filteredData()$long),
              lat1 = max(filteredData()$lat), lat2 = min(filteredData()$lat))

})

})

#add labels
#add rankings
#color restaurant as per ranking
# Run the application 
shinyApp(ui = ui, server = server)

