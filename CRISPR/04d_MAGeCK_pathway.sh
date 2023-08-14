#!/bin/bash -l

# Set Project Name
# Set Job Name
#$ -N CRISPR_MAGeCK_pathway
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

cd $HOME/scratch/CRISPR/MAGeCK_pathway_results
ranking_dir=$HOME/scratch/CRISPR/MAGeCK_test_results
gmt_dir=$HOME/projects/CRISPR

#--gene-ranking:		The gene summary file (containing both positive and negative selection tests) generated by the mageck test or mageck mle 
#						Pathway enrichment will be performed in both directions
#--gmt-file:			The pathway file in GMT format. 
#						You can download Hallmark gene set or other sets from here https://www.gsea-msigdb.org/gsea/downloads.jsp
#--ranking-column:		column in gene ranking file corresponding to neg|score. Default is 2. Column_0 = id, Column_1 = num, Column_2 = neg|score
#--ranking-column-2:	column in gene ranking file corresponding to pos|score. Default is 8. Column_0 = id, Column_1 = num, Column_8 = pos|score 
#--sort-criteria:		can be either neg or pos. Default is neg.
#--method:				can be either gsea or rra. Default is gsea.
#--permutation:			Use only if --method gsea. Default value is 1000. 
#--pathway-alpha:		Use only if --method RRA. Default value is 0.25.
#--single-ranking:		Use only if file used in --gene-ranking has either pos or neg selction scores. If it has both, DO NOT use this parameter.

#IMPORTANT: Make sure there are no tabs or blank spaces between \ at end of line and -- at start of next line

mageck pathway \
--gene-ranking $ranking_dir/MAGeCK_test_2D_07.gene_summary.txt \
--gmt-file $gmt_dir/h.all.v7.5.1.symbols.gmt \
--output-prefix MAGeCK_GSEA_pathway_2D_07 \
--ranking-column 2 \
--ranking-column-2 8 \
--sort-criteria neg \
--method gsea \
--permutation 1000
#--pathway-alpha 0.25 \
#--single-ranking		
 

mageck pathway \
--gene-ranking $ranking_dir/MAGeCK_test_2D_14.gene_summary.txt \
--gmt-file $gmt_dir/h.all.v7.5.1.symbols.gmt \
--output-prefix MAGeCK_GSEA_pathway_2D_14 \
--ranking-column 2 \
--ranking-column-2 8 \
--sort-criteria neg \
--method gsea \
--permutation 1000
#--pathway-alpha 0.25 \
#--single-ranking 	

mageck pathway \
--gene-ranking $ranking_dir/MAGeCK_test_3D_07.gene_summary.txt \
--gmt-file $gmt_dir/h.all.v7.5.1.symbols.gmt \
--output-prefix MAGeCK_GSEA_pathway_3D_07 \
--ranking-column 2 \
--ranking-column-2 8 \
--sort-criteria neg \
--method gsea \
--permutation 1000
#--pathway-alpha 0.25 \
#--single-ranking	


mageck pathway \
--gene-ranking $ranking_dir/MAGeCK_test_3D_14.gene_summary.txt \
--gmt-file $gmt_dir/h.all.v7.5.1.symbols.gmt \
--output-prefix MAGeCK_GSEA_pathway_3D_14 \
--ranking-column 2 \
--ranking-column-2 8 \
--sort-criteria neg \
--method gsea \
--permutation 1000
#--pathway-alpha 0.25 \
#--single-ranking

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