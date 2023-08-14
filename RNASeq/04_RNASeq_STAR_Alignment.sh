#!/bin/bash -l

#$ -N STAR_Align_Reads          # Set Job Name
#$ -l mem_free=40G              # Request memory
#$ -j y                         # Merge standard output and standard error
#$ -cwd                         # Set current working directory
#$ -t 1-18                      # Submit an array job with n tasks where n = number of samples = number of fastq files/2 if paired end

# Follow / at end of variables declareed below to avoid errors in array.
proj=RNASeq_Hany_LOY
OUTPUT_DIR=$HOME/scratch/$proj/STAR_alignment_results		#output directory to store read alignment results
INPUT_DIR=$HOME/scratch/$proj/raw_reads					    #input directory with trimmed/raw reads
#INPUT_DIR=$HOME/common/LOY
GENOME_INDICES=$HOME/scratch/$proj/indexed_ref_genome/		#directory containing genome indices from previous step

# Create an array of read1 and read2 filenames with path. If single end, then there will be no read2.
input1=($INPUT_DIR/*_1*.gz)
input2=($INPUT_DIR/*_2*.gz)

# Verify if the array stores correctly
# echo ${input1[*]}

# Number of items in array
# echo ${#input2[*]}

# Create an array of filenames with output path
# These are prefix with output path. STAR will append "SortedByCoordinate.bam" to filename 
read1=(${input1[*]//$INPUT_DIR/$OUTPUT_DIR})
output=(${read1[*]//_1.*/})

# Use the SGE_TASK_ID environment variable to select the appropriate input file from bash array
# Bash array index starts from 0, so we need to subtract one from SGE_TASK_ID value
index=$(($SGE_TASK_ID-1))

# Declare input and output filenames with path for each job
taskinput1=${input1[$index]}
taskinput2=${input2[$index]}
taskoutput=${output[$index]}

# Keep track of information related to the current job
echo "=========================================================="
echo "Start date   : $(date)"
echo "Job name     : $JOB_NAME"
echo "Job ID       : $JOB_ID"  
echo "SGE TASK ID  : $SGE_TASK_ID"
echo "Task input1  : $taskinput1"
echo "Task input2  : $taskinput2"
echo "Task output  : $taskoutput"
echo "=========================================================="

# You need to add path for STAR
PATH=$HOME/NGSTools/STAR-2.7.10b/bin/Linux_x86_64_static/:$PATH

# Generate Genome Indices. You can write all lines below in a single line without \ also. 
# Using \ enables us to split the long command into easy to read format.
# outFilterMismatchNoverReadLmax 0.05 means mismatch/readlength = 0.05 i.e. 5 mismatch per 100 base
if((${#input2[*]}>1)) 
 then  
 STAR \
--runMode alignReads \
--genomeDir $GENOME_INDICES \
--readFilesIn $taskinput1 $taskinput2 \
--readFilesCommand zcat \
--outFileNamePrefix $taskoutput \
--outFilterMultimapNmax 10 \
--outFilterMismatchNoverReadLmax 0.04 \
--alignIntronMin 20 \
--alignIntronMax 1000000 \
--alignMatesGapMax 1000000 \
--quantMode GeneCounts \
--outSAMtype BAM SortedByCoordinate 
elif((${#input2[*]}==1)) 
 then  
 STAR \
--runMode alignReads \
--genomeDir $GENOME_INDICES \
--readFilesIn $taskinput1 \
--readFilesCommand zcat \
--outFileNamePrefix $taskoutput \
--outFilterMultimapNmax 10 \
--outFilterMismatchNoverReadLmax 0.04 \
--alignIntronMin 20 \
--alignIntronMax 1000000 \
--alignMatesGapMax 1000000 \
--quantMode GeneCounts \
--outSAMtype BAM SortedByCoordinate
fi