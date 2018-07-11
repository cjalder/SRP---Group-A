#!/bin/bash
#Script to run Pipeline5 on SRR1178024
#Make Directories
mkdir First_run &&
mkdir ERCC_run &&
mkdir Cufflinks &&
cd First_run &&
/home/cja37/Bioinformatics_Programs/tophat-2.0.0.Linux_x86_64/tophat -r 160 -g 10 ../../Indexes/KnownGene/rn4_knowngenes_dup ../SRR1178024_1.fastq ../SRR1178024_2.fastq &&
cd .. &&
samtools bam2fq ./First_run/tophat_out/unmapped.bam > unmapped.fq &&
cd ERCC_run &&
/home/cja37/Bioinformatics_Programs/tophat-2.0.0.Linux_x86_64/tophat -r 160 -g 10 ../../Indexes/RN4_ERCC/rn4_Genome-ERCC ../unmapped.fq &&
#running cufflinks
cd ../Cufflinks &&
mkdir Known &&
mkdir Unmapped &&
mkdir Merged &&
cd Known &&
cufflinks ../../First_run/tophat_out/accepted_hits.bam &&
cd ../Unmapped &&
cufflinks ../../ERCC_run/tophat_out/accepted_hits.bam &&
cd ../Merged &&
cuffmerge ../../assembly_GTF_list.txt
