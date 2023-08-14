#!/bin/bash -l

#$ -N STAR_Genome_Indexing      # Set Job Name
#$ -l mem_free=40G              # Request memory
#$ -j y                         # Merge standard output and standard error
#$ -cwd                         # Set current working directory
#$ -t 1                         # Submit an array job with 1 task.

proj=RNASeq_TRAMP_GSE79756
species=Mouse
INPUT_DIR=$HOME/NGSTools/RNASeq_Reference_Genomes/$species		#input directory with fa and gtf files of reference genome
OUTPUT_DIR=$HOME/scratch/$proj/indexed_ref_genome	            #output directory to store indexed genome. This will be created by STAR

# Calculate max read length using zcat $HOME/scratch/RNASeq/$proj/raw_reads/*.fq.gz | head -2 | awk 'END {print}'| wc -c
# Even if number of bases is 150, wc -c will give  result as 151. So, we subtract 2 to get 149 from output of wc -c
# If read length is 150bp, set it to 149
#MAX_READ_LENGTH_MINUS_1=$(($(zcat $HOME/scratch/RNASeq_$proj/raw_reads/*q.gz | head -2 | awk 'END {print}'| wc -c)-2))
MAX_READ_LENGTH_MINUS_1=149

# Keep track of information related to the current job
echo "=========================================================="
echo "Start date    : $(date)"
echo "Job name      : $JOB_NAME"
echo "Job ID        : $JOB_ID"  
echo "SGE TASK ID   : $SGE_TASK_ID"
echo "Project       : $proj"
echo "Output Folder : $OUTPUT_DIR"
echo "Read length-1 : $MAX_READ_LENGTH_MINUS_1"
echo "=========================================================="

# To see the sequences alone for first 100 lines
# zcat $HOME/common/NA13_CDH12/nude/N8*R1*.fastq.gz | head -100 | awk 'NR % 4 == 2'
# zcat $HOME/common/NA13_CDH12/nude/N8*R1*.fastq.gz | grep -n TTTGTTGTCTCGCTCA | head -15

# You need to add path for STAR
PATH=$HOME/NGSTools/STAR-2.7.10b/bin/Linux_x86_64_static/:$PATH

# Generate Genome Indices. You can write all lines below in a single line without \ also. 
# Using \ enables us to split the long command into easy to read format.
STAR \
--runMode genomeGenerate \
--genomeDir $OUTPUT_DIR \
--genomeFastaFiles $INPUT_DIR/*.fa \
--sjdbGTFfile $INPUT_DIR/*.gtf \
--sjdbOverhang $MAX_READ_LENGTH_MINUS_1