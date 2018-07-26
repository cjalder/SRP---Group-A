source("load_packages.R")
source("ui.R")

server <- function(input, output) {
  cuff <- readCufflinks("~/BS7120/Group_Project/Pipeline_5/Final/CuffDiff_rn4_FINAL/")
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
  table$x <- as.character(table$x)
  table$x[is.na(table$x)] <- table$Row.names[is.na(table$x)]
  differentialExpressionResults <-
    table %>%
    mutate(
      minusLog10Pvalue = -log10(p_value),
      LogFC = log2_fold_change
    )



  output$volcanoPlot <- renderPlot({
  ggplot(differentialExpressionResults) +
    geom_point(aes(x = LogFC, y = minusLog10Pvalue, colour = cut(LogFC, c(-Inf, -1.5, 1.5, Inf)))) +
    scale_color_manual(name = "Differential Expression", values = c("red","black","green"),
    labels = c( "Downregulated", "No Significant change","Upregulated"))+
    xlim(c(-10, 10)) +
    xlab("log fold change") +
    ylab("-log10(P-value)") +
    theme(legend.position = "bottom")+
    geom_vline(xintercept=c(-1.5,1.5), linetype="dotted", colours("red"))


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
