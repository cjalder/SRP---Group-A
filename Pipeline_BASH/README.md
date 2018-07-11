I have created a BASH script to run Pipeline5 up to the merging of the 2 assemblies, before the final run of cufflinks using the merged assemblies as the annotation. 

The BASH script runs using the directory tree outlined on the PDF file provided. If your own directories are set up differently please adjust the BASH script accordingly. Please note that you will have to input the direct path where you have placed tophat for the BASH script to work, even if you have added the program to your .bashrc PATH

The BASH script provided is for the SRR1178024 data set run, so adjust the file names in the first tophat run (line 8) appropriately. 

I have also provided the RN4_knowngenes_dup file, with duplicates reads removed via seqkit, which appeared to be the cause of the problem with the original runs. You will need to build bowtie indexes from this for the first run. The indexes used in the second run (The whole_assembly with ERCC spikes) are still fine to use. 
