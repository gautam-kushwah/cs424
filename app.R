#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(lubridate)
library(ggplot2)
library(shinydashboard)
library(dplyr)

#read all file names in a temp variable
temp = list.files(pattern="*.tsv")
allData2 <- lapply(temp, read.delim)
allData <- do.call(rbind, allData2)

#converting dates
allData$newDate <- as.Date(allData$date, "%m/%d/%Y")
allData$date <- NULL
halsted <- subset(allData, stationname=="UIC-Halsted")
ohare <- subset(allData, stationname=="O'Hare Airport")
polk <- subset(allData, stationname=="Polk")

listNames <- sort(c("UIC-Halsted","O'Hare Airport", "Polk"  ))
listNamesGood <- listNames[listNames != "rides" & listNames != "newDate" & listNames != "station_id"]
years<-c(2001:2021)
months<-(1:12)
interesting<-c(2021, 2019, 2020)


ui <- dashboardPage(
  dashboardHeader(title="CS424 Project 1"),
  dashboardSidebar(disable = FALSE, collapsed = FALSE,
                   
                   sidebarMenu(
                     menuItem("Dashboard", tabName = "dashboard", icon = NULL),
                     menuItem("", tabName = "cheapBlankSpace", icon = NULL),
                     menuItem("", tabName = "cheapBlankSpace", icon= NULL),
                     menuItem("About", tabName = "about", icon = NULL)),
                   selectInput("year_left", "Select the year to visualize - Left Region", years, selected = 2021),
                   selectInput("month_left", "Select the month to visualize", months, selected = 1),
                   selectInput("station_left", "Select the station to visualize", listNames, selected = "UIC-Halsted"),
                   
                   selectInput("year_right", "Select the year to visualize - Right Region", years, selected = 2021),
                   selectInput("month_right", "Select the month to visualize", months, selected = 1),
                   selectInput("station_right", "Select the station to visualize", listNames, selected = "O'Hare Airport")
                   
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName="dashboard",
              fluidRow(
                column(6,
                       fluidRow(
                         box( title = "Total Entries for each year", solidHeader = TRUE, status = "primary", width = 12,
                              plotOutput("hist1", height = 200)
                              
                         )
                       ), 
                       fluidRow(
                         box( title = "Entries across the year", solidHeader = TRUE, status = "primary", width = 12,
                              plotOutput("hist2", height = 200)
                         )
                       ),
                       fluidRow(
                         box( title = "Entries across the year grouped by months", solidHeader = TRUE, status = "primary", width = 12,
                              plotOutput("hist3", height = 200)
                         )
                       ),
                       fluidRow(
                         box( title = "Entries in a month grouped by Days of the week", solidHeader = TRUE, status = "primary", width = 12,
                              plotOutput("hist4", height = 200)
                         )
                       ),
                       fluidRow(
                         box(title = "10 interesting dates", solidHeader = TRUE, width=12,
                             selectInput("interesting", "10 Interesting dates", c("Lockdown Ended"=2021, "Covid-19"=2020, "CTA Blue line Shutdown"= 2019, "Summer Break" = 2017, "September 11 attacks"=2001, "CTA ridership grows" = 2011, "CTA derailment"=2007, "Fall session starts"= 2015, "Crash at O'Hare Blue line"= 2014, "LollaPalooza Largest Ever crowd"=2011), selected=2021)
                             # selectInput("month_left", "Select the month to visualize", months, selected = 2021),
                             # selectInput("station_left", "Select the station to visualize", listNamesGood, selected = "UIC-Halsted")
                         )
                       )
                ),  
                column(6,
                       fluidRow(
                         box( title = "Total Entries for each year", solidHeader = TRUE, status = "primary", width = 12,
                              plotOutput("hist5", height = 200)
                              
                         )
                       ), 
                       fluidRow(
                         box( title = "Entries across the year", solidHeader = TRUE, status = "primary", width = 12,
                              plotOutput("hist6", height = 200)
                              
                         )
                       ),
                       fluidRow(
                         box( title = "Entries across the year grouped by months", solidHeader = TRUE, status = "primary", width = 12,
                              plotOutput("hist7", height = 200)
                              
                         )
                       ),
                       fluidRow(
                         box(title="Entries in a month grouped by Days of the week", solidHeader=TRUE, status="primary", width=12,
                             plotOutput("hist8", height = 200)
                             
                         )
                         
                       ),
                       fluidRow(
                         # box(title = "RHS Controls", solidHeader = TRUE, width=12
                         #     # selectInput("year_right", "Select the year to visualize", years, selected = 2021),
                         #     # selectInput("month_right", "Select the station to visualize", listNamesGood, selected = "O'Hare Airport")
                         # )
                       )
                )
              )
      ),
      tabItem(tabName="about",
              h2("About"), 
              p("Application written by Gautam Kushwah for CS424 spring 2022 taught by Dr. Andrew Johnson"),
              p("Data taken from https://data.cityofchicago.org/Transportation/CTA-Ridership-L-Station-Entries-Daily-Totals/5neh-572f"),
              p("The app helps visualize CTA L data over the last 20 years and helps uncover trends in data"),
              p("Reference for R functions through https://shiny.rstudio.com/reference/shin")
              
      )
    )
    
    
    
  )
)


# Define server logic required to draw a histogram
server <- function(input, output, session) {
  year_left <- reactive({input$year_left})
  station_left <- reactive({input$station_left})
  station_right <- reactive({input$station_right})
  month_left <- reactive({input$month_left})
  year_right <- reactive({input$year_right})
  month_right <- reactive({input$month_right})
  justOneYearReactiveLeft <- reactive({subset(halsted, year(halsted$newDate)==input$year_left)})
  justOneYearReactiveRight <- reactive({subset(ohare, year(ohare$newDate)==input$year_right)})
  interesting_date <-reactive({input$interesting})
  
  output$hist1 <- renderPlot({
    # justOneYear <- justOneYearReactive()
    
    if(station_left() == 'UIC-Halsted'){
      df_l <- halsted
    }else if(station_left() == "Polk"){
      df_l <- polk
    }else{
      df_l <- ohare
    }
    
    
    by_year <- aggregate(rides~year(newDate),
                         data=df_l,FUN=sum)
    colnames(by_year)[1] <- "newYears"
    ggplot(by_year, aes(x=newYears, y=rides)) +
      labs(x="Years", y = "Number of entries") + geom_bar(stat="identity", fill="steelblue") +ggtitle(paste("Station Name: ", input$station_left))
  })
  
  output$hist2 <- renderPlot({
    # justOneYear <- justOneYearReactive()
    # year_left_selected <- year_left()
    if(station_left() == 'UIC-Halsted'){
      df_l <- halsted
    }else if(station_left() == "Polk"){
      df_l <- polk
    }else{
      df_l <- ohare
    }
    
    
    # justOneYear <- justOneYearReactiveLeft()
    justOneYear <- subset(df_l, year(df_l$newDate)==year_left())
    ggplot(justOneYear, aes(x=newDate, y=rides)) +
      labs(x="Dates ", y = "Total number of entries") + geom_bar(stat="identity", fill="steelblue")  + ggtitle(paste("Station Name: ", input$station_left))
  })
  
  output$hist3 <- renderPlot({
    if(station_left() == 'UIC-Halsted'){
      df_l <- halsted
    }else if(station_left() == "Polk"){
      df_l <- polk
    }else{
      df_l <- ohare
    }
    
    
    # justOneYear <- justOneYearReactiveLeft()
    justOneYear <- subset(df_l, year(df_l$newDate)==year_left())
    by_months <- justOneYear %>% group_by(month(newDate))
    colnames(by_months)[6] <- "newMonths"
    
    ggplot(by_months, aes(x=newMonths, y=rides)) +labs(x="Months (1 = Jan, 12=Dec)", y="Total number of entries")+ geom_bar(stat="identity", fill="steelblue") + scale_x_continuous(breaks = seq(1, 12, by = 1)) + ggtitle(paste("Station Name: ", input$station_left), subtitle=paste("Year", input$year_left))
  })
  
  output$hist4 <- renderPlot({
    if(station_left() == 'UIC-Halsted'){
      df_l <- halsted
    }else if(station_left() == "Polk"){
      df_l <- polk
    }else{
      df_l <- ohare
    }
    
    
    # justOneYear <- justOneYearReactiveLeft()
    justOneYear <- subset(df_l, year(df_l$newDate)==year_left())
    justOneYear$day <- weekdays((justOneYear$newDate))
    by_day <- justOneYear %>% group_by(justOneYear$day)
    colnames(by_day)[7] <- "days_of_week"
    by_day$days_of_week <- factor(by_day$days_of_week, levels = c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'))
    by_day_in_month <- subset(by_day, month(newDate)==month_left())
    
    ggplot(by_day_in_month, aes(x=days_of_week, y=rides)) + labs(x="Days of the week", y="Number of entries") + geom_bar(stat="identity", fill="steelblue") + ggtitle(paste("Station Name: ", input$station_left), subtitle=paste("Month", input$month_left))
    
    
  })
  
  
  ################################################# LEFT PANEL CODE ENDS  ##########################################
  
  # ########## RIDE PANEL CODE ##################
  
  output$hist5 <- renderPlot({
    # justOneYear <- justOneYearReactive()
    
    if(station_right() == 'UIC-Halsted'){
      df_r <- halsted
    }else if(station_right() == "Polk"){
      df_r <- polk
    }else{
      df_r <- ohare
    }
    
    
    by_year <- aggregate(rides~year(newDate),
                         data=df_r,FUN=sum)
    colnames(by_year)[1] <- "newYears"
    ggplot(by_year, aes(x=newYears, y=rides)) +
      labs(x="Years", y = "Number of entries") + geom_bar(stat="identity", fill="steelblue") + ggtitle(paste("Station Name: ", input$station_right))
  })
  
  output$hist6 <- renderPlot({
    # justOneYear <- justOneYearReactive()
    # year_left_selected <- year_left()
    if(station_right() == 'UIC-Halsted'){
      df_r <- halsted
    }else if(station_right() == "Polk"){
      df_r <- polk
    }else{
      df_r <- ohare
    }
    
    
    # justOneYear <- justOneYearReactiveLeft()
    justOneYear <- subset(df_r, year(df_r$newDate)==year_right())
    ggplot(justOneYear, aes(x=newDate, y=rides)) +
      labs(x="Dates", y = "Total number of entries") + geom_bar(stat="identity", fill="steelblue") + ggtitle(paste("Station Name: ", input$station_right))
  })
  
  output$hist7 <- renderPlot({
    if(station_right() == 'UIC-Halsted'){
      df_r <- halsted
    }else if(station_right() == "Polk"){
      df_r <- polk
    }else{
      df_r <- ohare
    }
    
    
    # justOneYear <- justOneYearReactiveLeft()
    justOneYear <- subset(df_r, year(df_r$newDate)==year_right())
    by_months <- justOneYear %>% group_by(month(newDate))
    colnames(by_months)[6] <- "newMonths"
    
    ggplot(by_months, aes(x=newMonths, y=rides)) + labs(x="Months (1 = Jan, 12=Dec)", y="Total number of entries")+ geom_bar(stat="identity", fill="steelblue") + scale_x_continuous(breaks = seq(1, 12, by = 1)) + ggtitle(paste("Station Name: ", input$station_right), subtitle=paste("Year", input$year_right))
  })
  
  output$hist8 <- renderPlot({
    if(station_right() == 'UIC-Halsted'){
      df_r <- halsted
    }else if(station_right() == "Polk"){
      df_r <- polk
    }else{
      df_r <- ohare
    }
    
    
    # justOneYear <- justOneYearReactiveLeft()
    justOneYear <- subset(df_r, year(df_r$newDate)==year_right())
    justOneYear$day <- weekdays((justOneYear$newDate))
    by_day <- justOneYear %>% group_by(justOneYear$day)
    colnames(by_day)[7] <- "days_of_week"
    by_day$days_of_week <- factor(by_day$days_of_week, levels = c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'))
    by_day_in_month <- subset(by_day, month(newDate)==month_right())
    
    ggplot(by_day_in_month, aes(x=days_of_week, y=rides)) +labs(x="Days of the week", y="Number of entries") + geom_bar(stat="identity", fill="steelblue") + ggtitle(paste("Station Name: ", input$station_right), subtitle=paste("Month", input$month_right))
    
    
  })
  
  
  #############################
  #
  ##########
  #Code for interesting dates
  # observe({
  #     x <- input$interesting
  
  #     # Can use character(0) to remove all choices
  #     if (is.null(x))
  #       x <- character(0)
  
  #     # Can also set the label and select items
  #     updateSelectInput(session, "year_right",
  #       # label = paste("Select input label", length(x)),
  #       # choices = x,
  #       selected = tail(x, 1)
  #     )
  #   })
  
  
  observeEvent(input$interesting, {
    updateSelectInput(inputId = "year_right", selected= input$interesting)
    updateSelectInput(inputId = "year_left", selected= input$interesting)
  })  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)





