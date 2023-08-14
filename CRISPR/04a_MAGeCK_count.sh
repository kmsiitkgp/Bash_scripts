#!/bin/bash -l

# Set Project Name
# Set Job Name
#$ -N CRISPR_MAGeCK_count
# Request memory. You can find maxvmem from qstat -j <jobid> & adjust mem_free accordingly in final run.
#$ -l mem_free=8G
# Merge standard output and standard error
#$ -j y
# Set current working directory
#$ -cwd
# Submit an array job with n tasks where n = 1 as we are running one by one
#$ -t 1

# Keep track of information related to the current job
echo "=========================================================="
echo "Start date : $(date)"
echo "Job name : $JOB_NAME"
echo "Job ID : $JOB_ID  $SGE_TASK_ID "
echo "=========================================================="

# You need to add path for Python3 for MAGeCK to run
PATH=$HOME/Python3/bin/:$PATH

raw_dir=$HOME/scratch/CRISPR/raw_reads
cd $HOME/scratch/CRISPR/MAGeCK_count_results

# --list-seq: 			csv file containing unique_id, sgRNA sequence and corresponding gene
# --fastq:				Fastq files of biological replicates separated by space. Each file must have a sample-label.
# 						Technical replicates of each biological replicate MUST be separated by comma comma (,)
# --sample-label: 		Each fastq file must have an unique sample label. NO SPACE is allowed between sample labels. These labels will be 
#						saved in the output file. We will assign some of these labels as --control-id and others as --treatment-id 
#						while running mageck test.
# --day0-label:			Turns on negative selection QC. Usually day 0 or plasmid sample is given this label. All samples without this
#						label will be compared with day0 sample to estimate the degree of negative selections in known essential genes
# --norm-method: 		Use "total" or "control". If using "control", use SAFE sgRNAs as "control", not Non-targeting sgRNAs
# --output-prefix: 		The prefix to be added o output of mageck count
# --reverse-complement:	Reverse complement the sequences in library for read mapping
#						Use this ONLY if reverse complement of guide is present in the reads. 
# --pdf-report:         Generate pdf report of the fastq files
# --count-table:		The read count table file if fastq is not provided
# --control-sgrna: 		Only use if --norm-method is control. Use SAFE sgRNAs
# --control-gene: 		Only use if --norm-method is control. Use genes corresponding to SAFE sgRNAs



mageck count \
--list-seq $HOME/projects/CRISPR/Jinfen_guides_MAGeCK.csv \
--fastq $raw_dir/H1_21_1.fq.gz $raw_dir/H2_68_1.fq.gz $raw_dir/H7_1_69_1.fq.gz $raw_dir/H7_2_70_1.fq.gz \
$raw_dir/H14_1_71_1.fq.gz $raw_dir/H14_2_72_1.fq.gz $raw_dir/H3D7_1_75_1.fq.gz $raw_dir/H3D7_2_76_1.fq.gz \
$raw_dir/H3DS1_73_1.fq.gz $raw_dir/H3DS2_41_1.fq.gz $raw_dir/H3D14_1_77_1.fq.gz $raw_dir/H3D14_2_78_1.fq.gz \
--sample-label Ctrl_A_1,Ctrl_A_2,Day07_2D_1,Day07_2D_2,Day14_2D_1,Day14_2D_2,Day07_3D_1,Day07_3D_2,Ctrl_B_1,Ctrl_B_2,Day14_3D_1,Day14_3D_2 \
--norm-method total \
--output-prefix MAGeCK_count \
--reverse-complement \
--pdf-report
#--day0-label Ctrl_A_1, Ctrl_A_2
#--count-table ??\
#--control-sgrna ?? \ 
#--control-gene ??\




#mageck count --list-seq ~/scratch/Linda_new/results_mageck/DTA_MAGeCK.csv --output-prefix result --sample-label EPD1_1,EPD1_2,EPD1_3,EPD1_4,EIgG_1,EIgG_2,EIgG_3,EIgG_4  --fastq ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_E_PD1_02.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_E_PD1_11.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_E_PD1_22.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_E_PD1_25.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_E_IgG_01.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_E_IgG_03.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_E_IgG_05.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_E_IgG_09.fastq.gz

#mageck test --count-table result.count.txt -t EPD1_1,EPD1_2,EPD1_3,EPD1_4 -c EIgG_1,EIgG_2,EIgG_3,EIgG_4 --output-prefix result


#mageck count --list-seq ~/scratch/Linda_new/results_mageck/DTA_MAGeCK.csv --output-prefix result --sample-label LPD1_1,LPD1_2,LPD1_3,LPD1_4,LPD1_5,LIgG_1,LIgG_2,LIgG_3,LIgG_4,LIgG_5  --fastq ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_PD1_04.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_PD1_07.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_PD1_10.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_PD1_13.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_PD1_16.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_IgG_06.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_IgG_12.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_IgG_14.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_IgG_15.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_IgG_23.fastq.gz

#mageck test --count-table result.count.txt -t LPD1_1,LPD1_2,LPD1_3,LPD1_4,LPD1_5 -c LIgG_1,LIgG_2,LIgG_3,LIgG_4,LIgG_5 --output-prefix result


#mageck count --list-seq ~/scratch/Linda_new/results_mageck/DTA_MAGeCK.csv --output-prefix result --sample-label LPD1_1,LPD1_2,LPD1_3,LPD1_4,LPD1_5,EPD1_1,EPD1_2,EPD1_3,EPD1_4  --fastq ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_PD1_04.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_PD1_07.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_PD1_10.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_PD1_13.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_PD1_16.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_E_PD1_02.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_E_PD1_11.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_E_PD1_22.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_E_PD1_25.fastq.gz

#mageck test --count-table result.count.txt -t LPD1_1,LPD1_2,LPD1_3,LPD1_4,LPD1_5 -c EPD1_1,EPD1_2,EPD1_3,EPD1_4 --output-prefix result


#mageck count --list-seq ~/scratch/Linda_new/results_mageck/DTA_MAGeCK.csv --output-prefix result --sample-label LIgG_1,LIgG_2,LIgG_3,LIgG_4,LIgG_5,EIgG_1,EIgG_2,EIgG_3,EIgG_4  --fastq ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_IgG_06.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_IgG_12.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_IgG_14.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_IgG_15.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_L_IgG_23.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_E_IgG_01.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_E_IgG_03.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_E_IgG_05.fastq.gz ~/scratch/Linda_new/raw_reads/Pan02_DTA/Pan02_E_IgG_09.fastq.gz

#mageck test --count-table result.count.txt -t LIgG_1,LIgG_2,LIgG_3,LIgG_4,LIgG_5 -c EIgG_1,EIgG_2,EIgG_3,EIgG_4 --output-prefix result

#-----------------------------

#mageck count --list-seq ~/scratch/Linda_new/results_mageck/DTA_MAGeCK.csv --output-prefix result --sample-label EPD1_1,EPD1_2,EPD1_3,EIgG_1,EIgG_2,EIgG_3 --fastq ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_E_PD1_04.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_E_PD1_08.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_E_PD1_20.fastq.gz  ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_E_IgG_02.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_E_IgG_03.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_E_IgG_21.fastq.gz

#mageck test --count-table result.count.txt -t EPD1_1,EPD1_2,EPD1_3 -c EIgG_1,EIgG_2,EIgG_3 --output-prefix result


#mageck count --list-seq ~/scratch/Linda_new/results_mageck/DTA_MAGeCK.csv --output-prefix result --sample-label LPD1_1,LPD1_2,LPD1_3,LIgG_1,LIgG_2,LIgG_3 --fastq ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_L_PD1_07.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_L_PD1_14.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_L_PD1_22.fastq.gz  ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_L_IgG_10.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_L_IgG_13.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_L_IgG_16.fastq.gz

#mageck test --count-table result.count.txt -t LPD1_1,LPD1_2,LPD1_3 -c LIgG_1,LIgG_2,LIgG_3 --output-prefix result


#mageck count --list-seq ~/scratch/Linda_new/results_mageck/DTA_MAGeCK.csv --output-prefix result --sample-label LPD1_1,LPD1_2,LPD1_3,EPD1_1,EPD1_2,EPD1_3 --fastq ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_L_PD1_07.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_L_PD1_14.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_L_PD1_22.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_E_PD1_04.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_E_PD1_08.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_E_PD1_20.fastq.gz

#mageck test --count-table result.count.txt -t LPD1_1,LPD1_2,LPD1_3 -c EPD1_1,EPD1_2,EPD1_3 --output-prefix result


#mageck count --list-seq ~/scratch/Linda_new/results_mageck/DTA_MAGeCK.csv --output-prefix result --sample-label LIgG_1,LIgG_2,LIgG_3,EIgG_1,EIgG_2,EIgG_3 --fastq ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_L_IgG_10.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_L_IgG_13.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_L_IgG_16.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_E_IgG_02.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_E_IgG_03.fastq.gz ~/scratch/Linda_new/raw_reads/CT2A_DTA/CT2A_E_IgG_21.fastq.gz

#mageck test --count-table result.count.txt -t LIgG_1,LIgG_2,LIgG_3 -c EIgG_1,EIgG_2,EIgG_3 --output-prefix result

#-----------------------------

#mageck count --list-seq ~/scratch/Linda_new/results_mageck/DTA_MAGeCK.csv --output-prefix result --sample-label EPD1_1,EPD1_2,EPD1_3,EPD1_4,EPD1_5,EIgG_1,EIgG_2,EIgG_3,EIgG_4,EIgG_5 --fastq ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_PD1_01.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_PD1_09.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_PD1_12.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_PD1_19.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_PD1_20.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_IgG_02.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_IgG_05.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_IgG_14.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_IgG_18.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_IgG_25.fastq.gz

#mageck test --count-table result.count.txt -t EPD1_1,EPD1_2,EPD1_3,EPD1_4,EPD1_5 -c EIgG_1,EIgG_2,EIgG_3,EIgG_4,EIgG_5 --output-prefix result


#mageck count --list-seq ~/scratch/Linda_new/results_mageck/DTA_MAGeCK.csv --output-prefix result --sample-label LPD1_1,LPD1_2,LPD1_3,LPD1_4,LPD1_5,LIgG_1,LIgG_2,LIgG_3,LIgG_4,LIgG_5 --fastq ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_PD1_06.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_PD1_08.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_PD1_13.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_PD1_15.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_PD1_17.fastq.gz  ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_IgG_04.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_IgG_07.fastq.gz  ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_IgG_10.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_IgG_11.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_IgG_21.fastq.gz

#mageck test --count-table result.count.txt -t LPD1_1,LPD1_2,LPD1_3,LPD1_4,LPD1_5 -c LIgG_1,LIgG_2,LIgG_3,LIgG_4,LIgG_5 --output-prefix result


#mageck count --list-seq ~/scratch/Linda_new/results_mageck/DTA_MAGeCK.csv --output-prefix result --sample-label LPD1_1,LPD1_2,LPD1_3,LPD1_4,LPD1_5,EPD1_1,EPD1_2,EPD1_3,EPD1_4,EPD1_5 --fastq ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_PD1_06.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_PD1_08.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_PD1_13.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_PD1_15.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_PD1_17.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_PD1_01.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_PD1_09.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_PD1_12.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_PD1_19.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_PD1_20.fastq.gz

#mageck test --count-table result.count.txt -t LPD1_1,LPD1_2,LPD1_3,LPD1_4,LPD1_5 -c EPD1_1,EPD1_2,EPD1_3,EPD1_4,EPD1_5 --output-prefix result


# mageck count --list-seq ~/scratch/Linda_new/results_mageck/DTA_MAGeCK.csv --output-prefix result --sample-label LIgG_1,LIgG_2,LIgG_3,LIgG_4,LIgG_5,EIgG_1,EIgG_2,EIgG_3,EIgG_4,EIgG_5 --fastq ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_IgG_04.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_IgG_07.fastq.gz  ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_IgG_10.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_IgG_11.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_L_IgG_21.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_IgG_02.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_IgG_05.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_IgG_14.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_IgG_18.fastq.gz ~/scratch/Linda_new/raw_reads/RM1_DTA/RM1_E_IgG_25.fastq.gz

#mageck test --count-table result.count.txt -t LIgG_1,LIgG_2,LIgG_3,LIgG_4,LIgG_5 -c EIgG_1,EIgG_2,EIgG_3,EIgG_4,EIgG_5 --output-prefix result
