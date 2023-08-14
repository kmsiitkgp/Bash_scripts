#!/bin/bash -l

proj=scRNASeq_BBN_Nude
OUTPUT_DIR=$HOME/scratch/$proj
# Make these directories for each analysis.
# DO NOT create a indexed_ref_genome directory. STAR will create it.
# If you create it before STAR, STAR will give error.

mkdir $OUTPUT_DIR
#mkdir $OUTPUT_DIR/raw_reads
#mkdir $OUTPUT_DIR/fastqc_results
mkdir $OUTPUT_DIR/logs
mkdir $OUTPUT_DIR/raw_feature_bc_matrix
mkdir $OUTPUT_DIR/raw_hto_bc_matrix
mkdir $OUTPUT_DIR/cellranger_results
mkdir $OUTPUT_DIR/CITESeq_results
mkdir $OUTPUT_DIR/diagnostics
mkdir $OUTPUT_DIR/results_demux
mkdir $OUTPUT_DIR/results_cellphonedb
mkdir $OUTPUT_DIR/results_pyscenic
mkdir $OUTPUT_DIR/results_scvelo
mkdir $OUTPUT_DIR/results_seurat
mkdir $OUTPUT_DIR/results_velocyto
#mkdir $OUTPUT_DIR/ARACNE_results

# To run this script, use "sh $HOME/projects/scRNASeq/00_scRNASeq_Directory_Setup.sh"
# You can use "./projects/scRNASeq/00_scRNASeq_Directory_Setup.sh" to run your script 
# but script has be to be made executable using "chmod u+x ./projects/scRNASeq/00_scRNASeq_Directory_Setup.sh"