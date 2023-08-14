#!/bin/bash -l

# Compile the CRISPR scripts (DO NOT uncomment below 2 lines. Copy and run the below 3 lines in shell. 
# Then, qsub this bash script)
# module load gcc
# g++ $HOME/projects/CRISPR/03_CRISPR_shRNA_Map_Count/*.cpp -std=c++2a -o $HOME/projects/CRISPR/CRISPR

# Set Project Name
# Set Job Name
#$ -N CRISPR_Map_Count
# Request memory
#$ -l mem_free=8G
# Merge standard output and standard error
#$ -j y
# Set current working directory
#$ -cwd
# Submit an array job with n tasks where n = number of forward read fastq.gz files 
#$ -t 1-5

# Follow the backslash / at end of variables declared below to avoid errors in array.
INPUT_DIR=$HOME/scratch/CRISPR/raw_reads/
OUTPUT_DIR=$HOME/scratch/CRISPR/count_results/counts_
metafile=$HOME/projects/CRISPR/Jinfen_guides.csv

# Create an array of input filenames with path before decompression
preinput=($INPUT_DIR*_1.fq.gz)

# Create an array of input filenames with path after decompression 
input=(${preinput[*]//.gz/})

# Use the SGE_TASK_ID environment variable to select the appropriate input file from bash array
# Bash array index starts from 0, so we need to subtract one from SGE_TASK_ID value
index=$(($SGE_TASK_ID-1))

# Declare input and output filenames with path for gunzip for each job
taskpreinput=${preinput[$index]}
taskinput=${input[$index]}
gunzip -c $taskpreinput > $taskinput

# Declare the input variables
preoutput=(${input[*]//$INPUT_DIR/$OUTPUT_DIR})
output=(${preoutput[*]//.fq/.csv})
taskoutput=${output[$index]}
headtrim=0
tailtrim=0
threshold=3
orientation="R"

# Keep track of information related to the current job
echo "=========================================================="
echo "Start date : $(date)"
echo "Job name : $JOB_NAME"
echo "Job ID : $JOB_ID  $SGE_TASK_ID  $taskinput  $taskoutput"
echo "=========================================================="

$HOME/projects/CRISPR/CRISPR $taskinput $taskoutput $metafile $headtrim $tailtrim $threshold $orientation

