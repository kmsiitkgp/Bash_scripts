#!/bin/bash -l

#$ -N CITE_Seq_count       # Set Job Name
#$ -l mem_free=64G         # Request memory.
#$ -j y                    # Merge standard output and standard error
#$ -cwd                    # Set current working directory
#$ -t 1-4                  # Submit an array job with n tasks where n = number of unique SRR ids.
# This MUST also be equal to the number of *whitelist.csv files that have barcode info for each batch

# NOTE: First, run CellRanger count on GEX fastq.gz 
# Next, use barcodes from filtered cells as whitelist input for CITE-seq-Count
# Then, run CITE-seq-Count on HTO fastq.gz
# Finally, demux the cells using R
# NOTE: You might get this error. If so, uninstall current version of pandas and install pandas=1.4.4
# Traceback (most recent call last):
  # File "/home/kailasamms/miniconda3/envs/NGS/bin/CITE-seq-Count", line 8, in <module>
    # sys.exit(main())
  # File "/home/kailasamms/miniconda3/envs/NGS/lib/python3.10/site-packages/cite_seq_count/__main__.py", line 603, in main
    # io.write_dense(
  # File "/home/kailasamms/miniconda3/envs/NGS/lib/python3.10/site-packages/cite_seq_count/io.py", line 48, in write_dense
    # pandas_dense = pd.DataFrame(sparse_matrix.todense(), columns=columns, index=index)
  # File "/home/kailasamms/miniconda3/envs/NGS/lib/python3.10/site-packages/pandas/core/frame.py", line 639, in __init__
    # raise ValueError("columns cannot be a set")
# ValueError: columns cannot be a set

FASTQ_DIR=$HOME/common/NA13_CDH12/nude/DZ-16898--04--14--2022
HTO_TAGS=$HOME/projects/scRNASeq/NA13_CDH12_Nude_HTO_tags.csv
WHITELIST_DIR=$HOME/projects/scRNASeq
OUTPUT_DIR=$HOME/scratch/scRNASeq/NA13_CDH12_Nude/CITESeq_results

# Create an array of R1 and R2 fastq.gz files with path.
input1=($FASTQ_DIR/*R1*.gz)
input2=($FASTQ_DIR/*R2*.gz)
input3=($WHITELIST_DIR/NA13_CDH12_Nude_*whitelist.csv)

# Verify if the array stores correctly
# echo ${input1[0]}
# echo ${input2[0]}
# echo ${input3[0]}

# Use the SGE_TASK_ID environment variable to select the appropriate input file from bash array
# Bash array index starts from 0, so we need to subtract one from SGE_TASK_ID value
index=$(($SGE_TASK_ID-1))
taskinput1=${input1[$index]}
taskinput2=${input2[$index]}
whitelist=${input3[$index]}
barcode_count=$(cat $whitelist | wc -l)

# Create an array of whitelist filenames with path
files=(${input3[*]//_whitelist.csv/})
folder=$(basename ${files[$index]})
taskoutput=$OUTPUT_DIR/$folder/
mkdir $taskoutput

# Keep track of information related to the current job
echo "======================================================================================================="
echo "Start date   : $(date)"
echo "Job name     : $JOB_NAME"
echo "Job ID       : $JOB_ID"  
echo "SGE TASK ID  : $SGE_TASK_ID"
echo "Task input 1 : $taskinput1"
echo "Task input 2 : $taskinput2"
echo "Task output  : $taskoutput"
echo "Whitelist    : $whitelist"
echo "Barcode      : $barcode_count" 
echo "======================================================================================================="

# You need to add path for Conda
PATH=$HOME/miniconda3/bin/:$PATH
# You have to use source activate instead of conda activate
source activate NGS
# Check which version of htseq-count is being used
# htseq-count is a python package. We can use conda to invoke htseq-count
which CITE-seq-Count
CITE-seq-Count --version

# Using \ enables us to split the long command into easy to read format.
# Set UMI_ERRORS=1 instead of default value of 2 and set BC_ERRORS=1 as cellranger count uses 
# hamming distance of 1 for UMI as well as barcode correction.
# Use ONLY 1 thread. Else, it will split file into multiple parts and map quickly but use 800GB+
# memory while merging the parts back together and cluster will kill the job.

# DO NOT use "_" in names of tags in HTO_tags.csv. Use "HTO-A" instead of "HTO_A" in HTO_tags.csv file.
# If you use "HTO_A", it automatically gets changed to "HTO-A" in next step of analysis and will create
# problems later. So, best use "HTO-A" from the beginning.

# First test with 2 million reads. If you get low % of unmapped reads, proceed with full data set
# --first_n 1000000. Check the yaml file to see % mapped vs unmapped
# Check with and without sliding window to see if unmapped reads is reduced significantly

CB_FIRST=1
CB_LAST=16
UMI_FIRST=17
UMI_LAST=28
BC_ERRORS=1
UMI_ERRORS=1
FIRST_N=2000000

CITE-seq-Count \
--read1 $taskinput1 \
--read2 $taskinput2 \
--tags $HTO_TAGS \
--cell_barcode_first_base $CB_FIRST \
--cell_barcode_last_base $CB_LAST \
--umi_first_base $UMI_FIRST \
--umi_last_base $UMI_LAST \
--bc_collapsing_dist $BC_ERRORS \
--umi_collapsing_dist $UMI_ERRORS \
--expected_cells $barcode_count \
--whitelist $whitelist \
--threads 1 \
--unmapped-tags unmapped.csv \
--unknown-top-tags 100 \
--output $taskoutput

#--first_n $FIRST_N \
#--sliding-window \

# Once citeseq count is complete, run the code below once to 
# copy the umi_count folders for HTODemux analysis
# (${array[*]/%/suffix}) to add suffix to add array elements
# (${array[*]/#/prefix}) to add prefix to add array elements 
LOCATION=$HOME/scratch/scRNASeq/NA13_CDH12_Nude
SAMPLES=($(ls $LOCATION/CITESeq_results/))
SAMPLES_WITH_PATH=($(ls $LOCATION/CITESeq_results/* -d))
CURRENT_SAMPLES_WITH_PATH=(${SAMPLES_WITH_PATH[*]/%//umi_count})
NEW_SAMPLES_WITH_PATH=(${SAMPLES[*]/#/$LOCATION/raw_hto_bc_matrix/})

# for index in ${!SAMPLES[*]}
# do
  # cp -r ${CURRENT_SAMPLES_WITH_PATH[$index]} ${NEW_SAMPLES_WITH_PATH[$index]}
# done  
