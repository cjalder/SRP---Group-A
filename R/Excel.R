##Creating a table to export to excel of DEG from cuffdiff data set.
library(cummeRbund)
library(xlsx)
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
table <-table[!is.na(table$x),]
# removes genes not deemed differentially expressed
table <-table[!(table$log2_fold_change > -1.5 & table$log2_fold_change < 1.5 ),]
table <- table[,c(1,2,6,7,8,10)]
row.names(table) <- NULL
## List of old row names and their replacements
oldrows <- c("Row.names","x","value_1","value_2","log2_fold_change","p_value")
newrows <- c("Cufflinks_Gene_ID","Gene_Symbol","FPKM_Controls", "FPKM_GEM", "Log2FC","P_Value")
## Loop to change names
for(i in 1:6) colnames(table)[colnames(table) == oldrows[i]] = newrows[i]
## Export to Excel
write.xlsx(table, "DEG_RN4.xlsx")
