## Program that compares log10(fpkm) of RN4 and RN6 genes (Matching genes only) 

library(cummeRbund)
library(shiny)
library(tidyverse)
library(RSQLite)

ui <- fluidPage(
  titlePanel("RN4 vs RN6 FPKM"),
  fluidRow(
    column(
      width = 6,
      plotOutput("FPKM", click = "PlotSelection", height = "500px")
    ),
    column(
      width = 6,
      dataTableOutput("selectedProbesTable")
    )
  )
)

server <- function(input, output) {

#Creating Table for RN4
rn4 <- readCufflinks("./CuffDiff_rn4_FINAL")
diffGeneIDs <- getSig(rn4,level="genes")
diffGenes<-getGenes(rn4,diffGeneIDs)
names<-featureNames(diffGenes)
row.names(names)=names$tracking_id
diffGenesNames<-as.matrix(names)
diffGenesNames<-diffGenesNames[,-1]
fpkmrn4 <- fpkm(diffGenes)
fpkmrn4 <-fpkmrn4[!(fpkmrn4$sample_name == "Controls"),]
row.names(fpkmrn4)=fpkmrn4$gene_id
fpkmrn4<-fpkmrn4[,-1]
fpkmrn4<-merge(diffGenesNames,fpkmrn4,by="row.names")
fpkmrn4 <- fpkmrn4[,c(1,2,3,4)]
#fpkmrn4$x <- as.character(fpkmrn4$x)
#fpkmrn4$x[is.na(fpkmrn4$x)] <- fpkmrn4$Row.names[is.na(fpkmrn4$x)]
fpkmrn4 <- fpkmrn4[!duplicated(fpkmrn4$x), ]

#Creating Table for RN6
rn6 <- readCufflinks("./CuffDiff_rn6_FINAL")
diffGeneIDs_rn6 <- getSig(rn6,level="genes")
diffGenes_rn6<-getGenes(rn6,diffGeneIDs_rn6)
names_rn6<-featureNames(diffGenes_rn6)
row.names(names_rn6)=names_rn6$tracking_id
diffGenesNames_rn6<-as.matrix(names_rn6)
diffGenesNames_rn6<-diffGenesNames_rn6[,-1]
fpkmrn6 <- fpkm(diffGenes_rn6)
fpkmrn6<-fpkmrn6[!(fpkmrn6$sample_name == "Controls"),]
row.names(fpkmrn6)=fpkmrn6$gene_id
fpkmrn6<-fpkmrn6[,-1]
fpkmrn6<-merge(diffGenesNames_rn6,fpkmrn6,by="row.names")
fpkmrn6 <- fpkmrn6[,c(1,2,3,4)]
#fpkmrn6$x <- as.character(fpkmrn6$x)
#fpkmrn6$x[is.na(fpkmrn6$x)] <- fpkmrn6$Row.names[is.na(fpkmrn6$x)]
fpkmrn6 <- fpkmrn6[!duplicated(fpkmrn6$x), ]

#Merging two data sets together
row.names(fpkmrn6) <- NULL
row.names(fpkmrn4) <- NULL
#row.names(fpkmrn6)=fpkmrn6$x
#row.names(fpkmrn4)=fpkmrn4$x
combined <- merge(fpkmrn4,fpkmrn6, by = "x")
final <-
  combined %>%
  mutate(
    log10_fpkmrn4 = log10(fpkm.x),
    log10_fpkmrn6 = log10(fpkm.y)
    )

output$FPKM <- renderPlot({
ggplot(final, aes(x = log10_fpkmrn4, y = log10_fpkmrn6), color="darkred") +
  geom_point() +
  #xlim(c(-5, 5)) +
  xlab("log10(FPKM) - RN4") +
  ylab("log10(FPKM) - RN6") +
  theme(legend.position = "bottom")+
  geom_abline(intercept =0 , slope = 1, linetype="dotted")

  })
  output$selectedProbesTable <- renderDataTable(

    nearPoints(final, input$PlotSelection) %>%
      transmute(
        'Gene' = x,
        `FPKM RN4` = signif(log10_fpkmrn4, digits = 4),
        `FPKM RN6` = signif(log10_fpkmrn6, digits = 4)
      ),

    options = list(dom = "tip", pageLength = 10, searching = FALSE)

    )

}
shinyApp(ui, server, options = list(height = 600))
