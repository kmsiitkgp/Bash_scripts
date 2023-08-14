#!/bin/bash -l

#$ -N Get_Fastq       # Set Job Name
#$ -l mem_free=8G     # Request memory
#$ -j y               # Merge standard output and standard error
#$ -cwd               # Set current working directory
#$ -t 1-12            # Submit an array job with n tasks. Set n to number of SRR ids in the SRR_Acc_List.txt

# You need to add path for fasterq-dump to run
PATH=$HOME/NGSTools/sratoolkit.3.0.2-centos_linux64/bin/:$PATH
proj=RNA_Seq_TRAMP_GSE79756
OUTPUT_DIR=$HOME/scratch/$proj

#  There are 25 human tumor samples.
# However, all cells belonging to each sample were labelled with a hashtag oligo.
# 6 hashtag oligos were used and samples were labelled in 10 batches.
# Batch 0 with hashtag oligos 1, 2 and 3: Sample#1246
# Batch 1 with hashtag oligos 1, 2 and 3: Sample#54
# Batch 1 with hashtag oligos 4, 5 and 6: Sample#674
# Batch 2 with hashtag oligos 1, 2 and 3: Sample#702
# Batch 2 with hashtag oligos 4, 5 and 6: Sample#752
# Batch 4 with hashtag oligos 1, 2 and 3: Sample#896
# Batch 4 with hashtag oligos 4, 5 and 6: Sample#912
# Batch 6A, 6B with hashtag oligos 1: Sample#489
# Batch 6A, 6B with hashtag oligos 2: Sample#59
# Batch 6A, 6B with hashtag oligos 3: Sample#590
# Batch 6A, 6B with hashtag oligos 4: Sample#824
# Batch 6A, 6B with hashtag oligos 5: Sample#36
# Batch 6A, 6B with hashtag oligos 6: Sample#72
# Batch 7A, 7B with hashtag oligos 1: Sample#739
# Batch 7A, 7B with hashtag oligos 2: Sample#763
# Batch 7A, 7B with hashtag oligos 3: Sample#913
# Batch 7A, 7B with hashtag oligos 4: Sample#1126
# Batch 7A, 7B with hashtag oligos 5: Sample#1204
# Batch 7A, 7B with hashtag oligos 6: Sample#371
# Batch 8A, 8B with hashtag oligos 1: Sample#593
# Batch 8A, 8B with hashtag oligos 2: Sample#419
# Batch 8A, 8B with hashtag oligos 3: Sample#446
# Batch 8A, 8B with hashtag oligos 4: Sample#435
# Batch 8A, 8B with hashtag oligos 5: Sample#518
# Batch 8A, 8B with hashtag oligos 6: Sample#8

# There are 2 types of fastq files: mRNA/gene expression (GEX) sequence and hashtag oligo (HTO) sequence
# We got the raw_feature_matrix folder for the mRNA sequence from Kenny [Cell Ranger Count output]
# However, we don't have the raw_feature_matrix folder for the hashtag sequence [CITE Seq Count output]
# So, we are now downloading the fastq files for the HTO. We will first filter the cells and extract the barcodes
# of filtered cells to be used as whitelist. Then, we will run CITESeq Count.
# Then, we use Seurat HTO Demultiplexing script to allocate the cells to different tumor samples after removing doublet cells.
# After this step, we can use normal seurat scripts, we already have.

# Find SRR numbers (not SRX, SAMN, GSM numbers) for each sample from
# https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE169379 and 
# https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA716349&o=bytes_l%3Aa
# Save SRR numbers to a text file SRR_Acc_List.txt
  
# Read a file line by line and store each line as an array
readarray -t input < $OUTPUT_DIR/SRR_Acc_List.txt
#mapfile -t input < $OUTPUT_DIR/SRR_Acc_List.txt

# Verify if the array stores correctly
# echo ${input[0]}

# Use the SGE_TASK_ID environment variable to select the appropriate input file from bash array
# Bash array index starts from 0, so we need to subtract one from SGE_TASK_ID value
index=$(($SGE_TASK_ID-1))
taskinput=${input[$index]}

# Keep track of information related to the current job
echo "=========================================================="
echo "Start date : $(date)"
echo "Job name   : $JOB_NAME"
echo "Job ID     : $JOB_ID"  
echo "TaskID     : $SGE_TASK_ID"
echo "index      : $index"
echo "taskinput  : $taskinput"
echo "=========================================================="

# https://edwards.flinders.edu.au/fastq-dump/
# https://github.com/ncbi/sra-tools/wiki/HowTo:-fasterq-dump
# https://www.biostars.org/p/12047/  What is a spot in SRA format?
# Spot is location on flowcell which was imaged during sequencing.
# If you did paired end sequencing with 6bp barcode, 12 bp primer, there
# would be 4 reads coming from the spot:  1 read for barcode,
# 1 read for primer, 1 forward and 1 reverse read. All 4 reads are
# merged as spot in SRA format
# Using \ enables us to split the long command into easy to read format.

# NOTE: If "prefetch SRR3316476" works but "prefetch $taskinput" doesnt work. 
# make sure the text file has Unix (LF) and not Windows (CR LF) by opening in
# Notepad++

# NCBI recommends running prefetch, then faster-dump or fastq-dump.
prefetch \
--resume yes \
--verify yes \
--progress \
--output-directory $OUTPUT_DIR/raw_reads $taskinput

fasterq-dump $taskinput \
--split-3 \
--skip-technical \
--progress \
--outdir $OUTPUT_DIR/raw_reads

gzip $OUTPUT_DIR/raw_reads/$taskinput*.fastq

# Remove prefetch folders and unpaired reads. 
# Single ends reads will have _1.fastq.gz. Sometimes, they dont have _1 suffix.
# Paired end reads will have _1.fastq.gz and _2.fastq.gz
rm -r $OUTPUT_DIR/raw_reads/$taskinput

# prefetch+faster-dump+gzip results are SAME as fastq-dump results below. Only
# file sizes are larger with faster-dump.

# fastq-dump \
# --split-3 \
# --skip-technical \
# --origfmt \
# --clip \
# --readids \
# --dumpbase \
# --read-filter pass \
# --gzip \
# --outdir $OUTPUT_DIR/raw_reads $taskinput