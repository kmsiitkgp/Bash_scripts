#!/bin/bash -l

#$ -N FastQC                    # Set Job Name
#$ -l mem_free=8G               # Request memory
#$ -j y                         # Merge standard output and standard error
#$ -cwd                         # Set current working directory
#$ -t 1-12                      # Submit an array job with 1 task for each fq.gz file. 
# Find n using: ls $HOME/scratch/RNASeq_$proj/raw_reads/*.gz | wc -l
# Note: Adjust number of input files properly

proj=RNASeq_TRAMP_GSE79756
OUTPUT_DIR=$HOME/scratch/$proj/fastqc_results/   #output directory to store fastqc results

# Create an array of input files
#input=($HOME/common/LOY/*.gz)
input=($HOME/scratch/$proj/raw_reads/*.gz)

# Use the SGE_TASK_ID environment variable to select the appropriate input file from bash array
# Bash array index starts from 0, so we need to subtract one from SGE_TASK_ID value
index=$(($SGE_TASK_ID-1))
taskinput=${input[$index]}

# Keep track of information related to the current job
echo "=========================================================="
echo "Start date    : $(date)"
echo "Job name      : $JOB_NAME"
echo "Job ID        : $JOB_ID"  
echo "SGE TASK ID   : $SGE_TASK_ID"
echo "Index         : $index"
echo "Task input    : $taskinput"
echo "Project       : $proj"
echo "Output Folder : $OUTPUT_DIR"
echo "=========================================================="

# You need to add path for FastQC as well as java
PATH=$HOME/NGSTools/FastQC/:$PATH
PATH=$HOME/NGSTools/jdk-16.0.2+7/bin/:$PATH

# --outdir=~/Hany/fastqc_results/ wont work. ~ isnt recognized by fastqc
fastqc $taskinput --outdir=$OUTPUT_DIR