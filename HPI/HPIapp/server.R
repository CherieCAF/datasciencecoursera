library(shiny)
library(ggplot2)
library(dplyr)
library(eurostat)

tmp <- get_eurostat("teicp270", update_cache=TRUE)
tmp <- tmp[complete.cases(tmp),]
tmp <- filter(tmp, unit=="I2010_NSA")
tmp1 <- label_eurostat(tmp)
tmp1$geo <- as.character(tmp1$geo)
countries <- sort(unique(tmp1$geo))

function(input, output) {
        
        dat <- reactive({
                filter(tmp1, geo==input$geo)
        })
        
        output$plot <- renderPlot({
                
                p <- ggplot(dat(), aes(x=time, y=values, group=geo, colour=geo))
                p <- p + geom_line() + facet_wrap(~geo, nrow=6) + theme(legend.position="none")
                p <- p + geom_smooth(linetype="dotted", col="black")
                
                print(p)
                
        }, height=700)
}
