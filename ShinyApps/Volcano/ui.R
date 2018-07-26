

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
