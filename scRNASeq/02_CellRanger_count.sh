#!/bin/bash -l

#$ -N CellRanger_count        # Set Job Name
#$ -l mem_free=64G            # Request memory
#$ -j y                       # Merge standard output and standard error
#$ -cwd                       # Set current working directory
#$ -t 1-10                    # Submit an array job with n tasks
# NOTE: n = number of samples; not number of fastqs. Each sample may 
# have 2 fastqs L001 and L002 if each sample was run on 2 lanes

# NOTE: You need to run cellranger count from your preferred directory as 
# there is no option to store output to a specific directory.
proj=scRNASeq_BBN_Nude
cd $HOME/scratch/$proj/cellranger_results

FASTQ_DIR=$HOME/common/Nude
#GENOME_DIR=$HOME/NGSTools/refdata-gex-GRCh38-2020-A   # use for human
GENOME_DIR=$HOME/NGSTools/refdata-gex-mm10-2020-A      # use for mouse

# Create an array of samples using R2 fastq files. Use ${array_name[index]} to verify
# NOTE: L001 and L002 means same library was run on 2 lanes. So, both these fastqs
# must be processed simultaneously for each sample. Although we specify only 1 of 
# these fastqs as inputs, we use the basename() to get filename and %%_* to remove
# all characters following _ in the filename from end of string. This was we feed
# the sample name that is common to both L001 and L002 fastqs to cellranger.
# Also, R2 file is the one that has our sequence not R1 or I1 fastqs.
# https://www.linuxjournal.com/content/bash-arrays
inputs=($FASTQ_DIR/*L001_R2*.gz)
# Check if inputs are correct using "echo ${inputs[*]}"

# Use the SGE_TASK_ID environment variable to select the appropriate input file from bash array
# Bash array index starts from 0, so we need to subtract one from SGE_TASK_ID value.
# Mathematical calculations MUST be enclosed in double round brackets ((5-4)).
# Also, use $ for assigning the computed value to a variable 
# Extract only the sample ID using basename(). basename() cannot be run on multiple files. 
# So, we do it individually. Note that filename is no longer an array.
# https://tldp.org/LDP/abs/html/string-manipulation.html
# ${string##substring} Deletes longest match of $substring from front of $string.
# ${string%%substring} Deletes longest match of $substring from back of $string.
# If string = "N5_S5_L001_R2_001.fastq.gz", substring = "_*", means possible matches are:
# "_S5_L001_R2_001.fastq.gz", "_L001_R2_001.fastq.gz", "_R2_001.fastq.gz" & "_001.fastq.gz"
# So, longest substring "_S5_L001_R2_001.fastq.gz" is removed and we are left with "N5"   

index=$(($SGE_TASK_ID-1))
#filename=$(basename "${inputs[index]}")
filename=$(basename ${inputs[index]})
taskinput=${filename%%_*}

# Keep track of information related to the current job
echo "=========================================================="
echo "Start date : $(date)"
echo "Job name   : $JOB_NAME"
echo "Job ID     : $JOB_ID"  
echo "TaskID     : $SGE_TASK_ID"
echo "index      : $index"
echo "filename   : $filename"
echo "taskinput  : $taskinput"
echo "=========================================================="

# You need to add path for Cellranger
PATH=$HOME/NGSTools/cellranger-7.1.0:$PATH

# Run cellranger count (we use no-bam to save space, nosecondary as we use Seurat)
# https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/count
# All analysis before CellRanger 7 had --include-introns=false by default. RECOMMENDED to set true.
# DO NOT use --no-bam. velocyto needs bam files created by cell ranger count.
# Also, DO NOT use --nosecondary. We can see clusters generated by cellranger using html file.
cellranger count \
--id=$taskinput \
--fastqs=$FASTQ_DIR  \
--sample=$taskinput \
--transcriptome=$GENOME_DIR \
--include-introns=true \
--chemistry=auto \
--check-library-compatibility=true
#--expect-cells=7000

# # Once cellranger count is complete, run the code below once to 
# # copy the raw_feature_bc_matrix folders for Seurat analysis
# # (${array[*]/%/suffix}) to add suffix to add array elements
# # (${array[*]/#/prefix}) to add prefix to add array elements
# LOCATION=$HOME/scratch/$proj
# SAMPLES=($(ls $LOCATION/cellranger_results/))
# SAMPLES_WITH_PATH=($(ls $LOCATION/cellranger_results/* -d))
# CURRENT_SAMPLES_WITH_PATH=(${SAMPLES_WITH_PATH[*]/%//outs/raw_feature_bc_matrix}) 
# NEW_SAMPLES_WITH_PATH=(${SAMPLES[*]/#/$LOCATION/raw_feature_bc_matrix/})

# for index in ${!SAMPLES[*]}
# do
  # cp -r ${CURRENT_SAMPLES_WITH_PATH[$index]} ${NEW_SAMPLES_WITH_PATH[$index]}
# done
