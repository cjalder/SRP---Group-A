#!/bin/bash
##Tuxedo Protocol Script

###########################
#                         #
#   To be continued!!     #
#                         #
###########################

#Please run in terminal from the main folder e.g. rn4/ | rn6/

##Files and folders must be arranged within the current working directory as described in readme:
#rn4 or rn6 gtf annotation file (e.g. RefSeq) in folder genes/
#hisat2 index (pre-built) must be located in the folder indexes/ [pre-built indexes for recent assemblies can be acquired at ]
#SRA paired end read samples e.g. SRR1178024_1 must be located in the folder samples/
#mergelist.txt must be prepared before and contain the names of all the .gtf assembly files that will be made for each sample, so they can be merged


#Mapping (output .sam) (20-30 minutes) [-p no. of cores; -1 sample 1 (left); -2 sample 2 (right); -S sam output]
hisat2 -p 4 --dta -x indexes/rn6 -1 samples/SRR1178024_1.fastq -2 samples/SRR1178024_2.fastq -S map/24_rn6.sam
hisat2 -p 4 --dta -x indexes/rn6 -1 samples/SRR1178035_1.fastq -2 samples/SRR1178035_2.fastq -S map/35_rn6.sam
hisat2 -p 4 --dta -x indexes/rn6 -1 samples/SRR1178059_1.fastq -2 samples/SRR1178059_2.fastq -S map/59_rn6.sam

#Sam to Bam (10 minutes) [-S sam input; -b BAM output]
samtools view -S -b map/24_rn6.sam > map/24_rn6_map.bam
samtools view -S -b map/35_rn6.sam > map/35_rn6_map.bam
samtools view -S -b map/59_rn6.sam > map/59_rn6_map.bam

#Sort Bam file (15 minutes) [no bam extension required when sorting]
samtools sort map/24_rn6.bam map/24_rn6_sorted
samtools sort map/35_rn6.bam map/35_rn6_sorted
samtools sort map/59_rn6.bam map/59_rn6_sorted

#Stringtie assembly (less than 30 minutes) [-l sample input]
stringtie map/24_rn6_sorted.bam -l samples/SRR1178024 -p 4 -G genes/rn6.gtf -o assembly/24_rn6.gtf
stringtie map/35_rn6_sorted.bam -l samples/SRR1178035 -p 4 -G genes/rn6.gtf -o assembly/35_rn6.gtf
stringtie map/59_rn6_sorted.bam -l samples/SRR1178059 -p 4 -G genes/rn6.gtf -o assembly/59_rn6.gtf

#Merge Samples (~10 minutes) [-p no. of cores; -G guide annotation; -o output]
stringtie --merge -p 4 -G genes/rn6.gtf -o stringtie_merged.gtf mergelist.txt

# compare the assembled transcripts to known transcripts
gffcompare -r genes/rn6.gtf -G -o merged/merged stringtie_merged.gtf

#Abudance Estimation (~10 minutes) [-eB estimate abundances; ]
stringtie -e -B -p 4 -G stringtie_merged.gtf -o ballgown/SRR1178024/SRR1178024_rn6.gtf map/24_rn6_sorted.bam
stringtie -e -B -p 4 -G stringtie_merged.gtf -o ballgown/SRR1178035/SRR1178035_rn6.gtf map/35_rn6_sorted.bam
stringtie -e -B -p 4 -G stringtie_merged.gtf -o ballgown/SRR1178059/SRR1178059_rn6.gtf map/59_rn6_sorted.bam

#R Protocol - to be addded
