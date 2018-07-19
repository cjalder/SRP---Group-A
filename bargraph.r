#R Script to create Expression Levels Bargraph of RN4 and RN6 selected genes
library(cummeRbund)
rn4 <- readCufflinks("./CuffDiff_refseq")
rn6 <- readCufflinks("./CuffDiff_RN6")
#User input for gene
input <- "Hivep2"
genern4 <- getGene(rn4,input)
genern6 <- getGene(rn6,input)
fpkmrn4 <- fpkm(genern4)
fpkmrn6 <- fpkm(genern6)
#dont know if this bit is import :P
row.names(fpkmrn4)=fpkmrn4$sample_name
row.names(fpkmrn6)=fpkmrn6$sample_name
bargraph <- rbind(fpkmrn4, fpkmrn6)
bargraph <- bargraph[,2:3]
r <- barplot(bargraph$fpkm, col = rainbow(20),main=input, names.arg =c("RN4 Control","RN4 GEM", "RN6 Control", "RN6 GEM"), xlab = "Sample", ylab = "FPKM")
