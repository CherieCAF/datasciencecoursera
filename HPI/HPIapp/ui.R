library(shiny)
library(ggplot2)
library(dplyr)
library(SmarterPoland)

tmp <- getEurostatRCV("teicp270") 
tmp <- tmp[complete.cases(tmp),]

tmp <- filter(tmp, unit=="I2010_NSA")
tmp$geo <- as.character(tmp$geo)
countries <- sort(unique(tmp$geo)) 

shinyUI(pageWithSidebar(
        
        headerPanel('European Housing Price Index'),
        
        sidebarPanel(
                helpText ("This simple app allows you to view the House Price Index for a country in the EU."),
                
                helpText("The House Price Index (HPI) measures price changes of all residential properties 
                          purchased by households (flats, detached houses, terraced houses, etc.), 
                          both new and existing, independently of their final use and their previous owners. 
                          Only market prices are considered, self-build dwellings are therefore excluded. 
                          The land component is included."),
                hr(),
                helpText ("Try it out and select one of the abbreviated country codes:"),
                countries <-sort(unique(tmp$geo)),
                hr(),
                selectInput('geo', 'Give it a go and select a country:', countries),
                hr(),
                helpText("Data from EuroStat - House Price Index (2010 =100) - quarterly data.")
                                                
                ),
        
        mainPanel(
                h4('The Property Price Index for your selected country is reflected below'),
                plotOutput('plot')
        )
))
