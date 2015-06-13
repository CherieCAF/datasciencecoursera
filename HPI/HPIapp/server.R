library(shiny)
library(ggplot2)
library(dplyr)
library(SmarterPoland)

tmp <- getEurostatRCV("teicp270") 
tmp <- tmp[complete.cases(tmp),]

tmp <- filter(tmp, unit=="I2010_NSA")
tmp$geo <- as.character(tmp$geo)
countries <- sort(unique(tmp$geo)) 

function(input, output) {
        
        dat <- reactive({
                filter(tmp, geo==input$geo)
        })
        
        output$plot <- renderPlot({
                
                p <- ggplot(dat(), aes(x=time, y=value, group=geo, colour=geo))
                p <- p + geom_line() + facet_wrap(~geo, nrow=6) + theme(legend.position="none")
                p <- p + geom_smooth(linetype="dotted", col="black")
                
                print(p)
                
        }, height=700)
}
