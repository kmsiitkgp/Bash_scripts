#!/bin/bash -l

# Set Project Name
# Set Job Name
#$ -N CRISPR_MAGeCK_test
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

cd $HOME/scratch/CRISPR/MAGeCK_test_results

# --count-table: 	output of mageck count
# --treatment-id:	Labels we assigned to fastq file while running mageck count
# --control-id:		Labels we assigned to fastq file while running mageck count
# --norm-method: 	Use "total" or "control". If using "control", use SAFE sgRNAs as "control", not Non-targeting sgRNAs
# --output-prefix:	The prefix to be added o output of mageck test
# --day0-label:		Use this ONLY if you dont specify --control-id. DO NOT use both parameters simultaneously.
# 					If you want to compare more than 2 sets of treated samples (say Day 7 and Day 14) to the same set of control samples (Day 0), then 
# 					use this parameter. If you want to compare only 2 sets of samples: "Day 7 vs Day 0"/"Day 14 vs Day 0"/"Day 7 vs Day 14", use --control id. 
# 					Turns on negative selection QC. Usually day 0 or plasmid sample is given this label. For every other sample label,
#					the negative selection QC will compare it with day0 sample, and estimate the degree of negative selections in essential genes
# --paired: 		Only use if each treatment sample has ONLY one corresponding control sample 
# --control-sgrna: 	Only use if --norm-method is control. Use SAFE sgRNAs
# --control-gene: 	Only use if --norm-method is control. Use genes corresponding to SAFE sgRNAs
# --cnv-norm: 		A matrix of copy number variation data across cell lines to normalize CNV-biased sgRNA scores prior to gene ranking
# --cell-line:		Cell line to be used for cnv normalization. Must match one of the column names in the file provided by --cnv-norm

# IMPORTANT: Sometimes the count table has extra " in sgRNA id and Gene. 
# So, open the count table and replace all " with nothing. Save and re-open in excel to make sure count table is proper.
# sgRNA	Gene	Ctrl_A_1	Ctrl_A_2	Day07_2D_1	Day07_2D_2	Day14_2D_1	Day14_2D_2	Day07_3D_1	Day07_3D_2	Ctrl_B_1	Ctrl_B_2	Day14_3D_1	Day14_3D_2
#"2663	CACNB3"	2142	2959	2542	3192	3759	3277	1339	1152	1340	2252	850	1236
#"4595	CPT2"	210	339	292	300	368	284	85	44	214	281	131	123


#--count-table $HOME/scratch/CRISPR/MAGeCK_count_results/MAGeCK_count.count.txt
mageck test \
--count-table $HOME/scratch/CRISPR/count_results/MAGeCK_kms.count.txt \
--treatment-id Day07_2D_1,Day07_2D_2 \
--control-id Ctrl_A_1,Ctrl_A_2 \
--norm-method control \
--control-gene $HOME/projects/CRISPR/control_genes.txt \
--sort-criteria neg \
--output-prefix MAGeCK_test_2D_07 \
--pdf-report
#--gene-test-fdr-threshold ?? \
#--adjust-method {fdr,holm,pounds} \
#--variance-estimation-samples ?? \
#--remove-zero {none,control,treatment,both,any} \
#--remove-zero-threshold ?? \
#--gene-lfc-method {median,alphamedian,mean,alphamean,secondbest} \
#--control-sgrna ?? \
#--normcounts-to-file \
#--skip-gene ?? \
#--keep-tmp \
#--additional-rra-parameters ?? \
#--cnv-norm ?? \
#--cell-line ?? \
#--cnv-est ??

#--count-table $HOME/scratch/CRISPR/MAGeCK_count_results/MAGeCK_count.count.txt 
mageck test \
--count-table $HOME/scratch/CRISPR/count_results/MAGeCK_kms.count.txt \
--treatment-id Day14_2D_1,Day14_2D_2 \
--control-id Ctrl_A_1,Ctrl_A_2 \
--norm-method control \
--control-gene $HOME/projects/CRISPR/control_genes.txt \
--sort-criteria neg \
--output-prefix MAGeCK_test_2D_14 \
--pdf-report

#--count-table $HOME/scratch/CRISPR/MAGeCK_count_results/MAGeCK_count.count.txt 
mageck test \
--count-table $HOME/scratch/CRISPR/count_results/MAGeCK_kms.count.txt \
--treatment-id Day07_3D_1,Day07_3D_2 \
--control-id Ctrl_A_1,Ctrl_A_2 \
--norm-method control \
--control-gene $HOME/projects/CRISPR/control_genes.txt \
--sort-criteria neg \
--output-prefix MAGeCK_test_3D_07 \
--pdf-report

#--count-table $HOME/scratch/CRISPR/MAGeCK_count_results/MAGeCK_count.count.txt 
mageck test \
--count-table $HOME/scratch/CRISPR/count_results/MAGeCK_kms.count.txt \
--treatment-id Day14_3D_1,Day14_3D_2 \
--control-id Ctrl_B_1,Ctrl_B_2 \
--norm-method control \
--control-gene $HOME/projects/CRISPR/control_genes.txt \
--sort-criteria neg \
--output-prefix MAGeCK_test_3D_14 \
--pdf-report

# mageck test -k ~/scratch/Linda_new/results_mageck/MAGeCK_Count_data.csv -t Pan02_E_PD1_02,Pan02_E_PD1_11,Pan02_E_PD1_22,Pan02_E_PD1_25 -c Pan02_E_IgG_01,Pan02_E_IgG_03,Pan02_E_IgG_05,Pan02_E_IgG_09 -n Pan02_E_PD1_vs_E_IgG --control-gene ~/scratch/Linda_new/results_mageck/ctrl_genes.txt --norm-method total

# mageck test -k ~/scratch/Linda_new/results_mageck/MAGeCK_Count_data.csv -t Pan02_L_PD1_04,Pan02_L_PD1_07,Pan02_L_PD1_10,Pan02_L_PD1_13,Pan02_L_PD1_16 -c Pan02_L_IgG_06,Pan02_L_IgG_12,Pan02_L_IgG_14,Pan02_L_IgG_15,Pan02_L_IgG_23 -n Pan02_L_PD1_vs_L_IgG --control-gene ~/scratch/Linda_new/results_mageck/ctrl_genes.txt --norm-method total

# mageck test -k ~/scratch/Linda_new/results_mageck/MAGeCK_Count_data.csv -t Pan02_L_PD1_04,Pan02_L_PD1_07,Pan02_L_PD1_10,Pan02_L_PD1_13,Pan02_L_PD1_16 -c Pan02_E_PD1_02,Pan02_E_PD1_11,Pan02_E_PD1_22,Pan02_E_PD1_25 -n Pan02_L_PD1_vs_E_PD1 --control-gene ~/scratch/Linda_new/results_mageck/ctrl_genes.txt --norm-method total

# mageck test -k ~/scratch/Linda_new/results_mageck/MAGeCK_Count_data.csv -t Pan02_L_IgG_06,Pan02_L_IgG_12,Pan02_L_IgG_14,Pan02_L_IgG_15,Pan02_L_IgG_23 -c Pan02_E_IgG_01,Pan02_E_IgG_03,Pan02_E_IgG_05,Pan02_E_IgG_09 -n Pan02_L_IgG_vs_E_IgG --control-gene ~/scratch/Linda_new/results_mageck/ctrl_genes.txt --norm-method total

# mageck test -k ~/scratch/Linda_new/results_mageck/MAGeCK_Count_data.csv -t CT2A_E_PD1_04,CT2A_E_PD1_08,CT2A_E_PD1_20 -c CT2A_E_IgG_02,CT2A_E_IgG_03,CT2A_E_IgG_21 -n CT2A_E_PD1_vs_E_IgG --control-gene ~/scratch/Linda_new/results_mageck/ctrl_genes.txt --norm-method total

# mageck test -k ~/scratch/Linda_new/results_mageck/MAGeCK_Count_data.csv -t CT2A_L_PD1_07,CT2A_L_PD1_14,CT2A_L_PD1_22 -c CT2A_L_IgG_10,CT2A_L_IgG_13,CT2A_L_IgG_16 -n CT2A_L_PD1_vs_L_IgG --control-gene ~/scratch/Linda_new/results_mageck/ctrl_genes.txt --norm-method total

# mageck test -k ~/scratch/Linda_new/results_mageck/MAGeCK_Count_data.csv -t CT2A_L_PD1_07,CT2A_L_PD1_14,CT2A_L_PD1_22 -c CT2A_E_PD1_04,CT2A_E_PD1_08,CT2A_E_PD1_20 -n CT2A_L_PD1_vs_E_PD1 --control-gene ~/scratch/Linda_new/results_mageck/ctrl_genes.txt --norm-method total

# mageck test -k ~/scratch/Linda_new/results_mageck/MAGeCK_Count_data.csv -t CT2A_L_IgG_10,CT2A_L_IgG_13,CT2A_L_IgG_16 -c CT2A_E_IgG_02,CT2A_E_IgG_03,CT2A_E_IgG_21 -n CT2A_L_IgG_vs_E_IgG --control-gene ~/scratch/Linda_new/results_mageck/ctrl_genes.txt --norm-method total

# mageck test -k ~/scratch/Linda_new/results_mageck/MAGeCK_Count_data.csv -t RM1_E_PD1_01,RM1_E_PD1_09,RM1_E_PD1_12,RM1_E_PD1_19,RM1_E_PD1_20 -c RM1_E_IgG_02,RM1_E_IgG_05,RM1_E_IgG_14,RM1_E_IgG_18,RM1_E_IgG_25 -n RM1_E_PD1_vs_E_IgG --control-gene ~/scratch/Linda_new/results_mageck/ctrl_genes.txt --norm-method total

# mageck test -k ~/scratch/Linda_new/results_mageck/MAGeCK_Count_data.csv -t RM1_L_PD1_06,RM1_L_PD1_08,RM1_L_PD1_13,RM1_L_PD1_15,RM1_L_PD1_17 -c RM1_L_IgG_04,RM1_L_IgG_07,RM1_L_IgG_10,RM1_L_IgG_11,RM1_L_IgG_21 -n RM1_L_PD1_vs_L_IgG --control-gene ~/scratch/Linda_new/results_mageck/ctrl_genes.txt --norm-method total

# mageck test -k ~/scratch/Linda_new/results_mageck/MAGeCK_Count_data.csv -t RM1_L_PD1_06,RM1_L_PD1_08,RM1_L_PD1_13,RM1_L_PD1_15,RM1_L_PD1_17 -c RM1_E_PD1_01,RM1_E_PD1_09,RM1_E_PD1_12,RM1_E_PD1_19,RM1_E_PD1_20 -n RM1_L_PD1_vs_E_PD1 --control-gene ~/scratch/Linda_new/results_mageck/ctrl_genes.txt --norm-method total

# mageck test -k ~/scratch/Linda_new/results_mageck/MAGeCK_Count_data.csv -t RM1_L_IgG_04,RM1_L_IgG_07,RM1_L_IgG_10,RM1_L_IgG_11,RM1_L_IgG_21 -c RM1_E_IgG_02,RM1_E_IgG_05,RM1_E_IgG_14,RM1_E_IgG_18,RM1_E_IgG_25 -n RM1_L_IgG_vs_E_IgG --control-gene ~/scratch/Linda_new/results_mageck/ctrl_genes.txt --norm-method total
