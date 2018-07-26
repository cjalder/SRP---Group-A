library(cummeRbund)
library(shiny)
library(tidyverse)
library(RSQLite)


ui <- fluidPage(
  titlePanel("Volcano Plot"),
  fluidRow(
    column(
      width = 6,
      plotOutput("volcanoPlot", click = "volcanoPlotSelection", height = "500px")
    ),
    column(
      width = 6,
      dataTableOutput("selectedProbesTable")
    )
  )
)

server <- function(input, output) {
  cuff <- readCufflinks()
  diffGeneIDs <- getSig(cuff,level="genes",alpha=0.05)
  diffGenes<-getGenes(cuff,diffGeneIDs)
  names<-featureNames(diffGenes)
  row.names(names)=names$tracking_id
  diffGenesNames<-as.matrix(names)
  diffGenesNames<-diffGenesNames[,-1]
  table <- diffData(diffGenes)
  row.names(table)=table$gene_id
  table<-table[,-1]
  table<-merge(diffGenesNames,table,by="row.names")
  differentialExpressionResults <-
    table %>%
    mutate(
      minusLog10Pvalue = -log10(p_value),
      LogFC = log2_fold_change
    )



  output$volcanoPlot <- renderPlot({
  ggplot(differentialExpressionResults, aes(x = LogFC, y = minusLog10Pvalue), colour=my_palette) +
    geom_point() +
    xlim(c(-5, 5)) +
    xlab("log fold change") +
    ylab("-log10(P-value)") +
    theme(legend.position = "bottom")


  })

  output$selectedProbesTable <- renderDataTable(

    nearPoints(differentialExpressionResults, input$volcanoPlotSelection) %>%
      transmute(
        'Gene' = x,
        `log fold change` = signif(LogFC, digits = 2),
        `p-value` = signif(p_value, digits = 2)
      ),

    options = list(dom = "tip", pageLength = 10, searching = FALSE)
  )
}

shinyApp(ui, server, options = list(height = 600))
