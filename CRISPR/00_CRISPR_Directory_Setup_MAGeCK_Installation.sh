#!/bin/bash -l

OUTPUT_DIR=$HOME/scratch/CRISPR
# Make these directories for each analysis.
# DO NOT create a indexed_ref_genome directory. STAR will create it.
# If you create it before STAR, STAR will give error.

mkdir $OUTPUT_DIR
mkdir $OUTPUT_DIR/raw_reads
mkdir $OUTPUT_DIR/fastqc_results
mkdir $OUTPUT_DIR/count_results
mkdir $OUTPUT_DIR/MAGeCK_count_results
mkdir $OUTPUT_DIR/MAGeCK_test_results
mkdir $OUTPUT_DIR/MAGeCK_mle_results
mkdir $OUTPUT_DIR/MAGeCK_pathway_results

# # Download latest version of MAGeCK from https://sourceforge.net/projects/mageck/files/0.5/mageck-0.5.9.5.tar.gz/download 
# # Copy it $HOME/NGSTools/ using cyberduck
# wget https://sourceforge.net/projects/mageck/files/0.5/mageck-0.5.9.5.tar.gz -P $HOME/NGSTools/ --no-check-certificate
# tar xvzf $HOME/NGSTools/mageck-0.5.9.5.tar.gz -C $HOME/NGSTools/
# mv $HOME/NGSTools/liulab-mageck-c491c3874dca $HOME/NGSTools/mageck-0.5.9.5
# cd $HOME/NGSTools/mageck-0.5.9.5
# python setup.py install --user

# ## Copy and paste PYTHONPATH to .bashrc file using vim. 
# #(vim ~/.bashrc --> i  --> PYTHONPATH=$HOME/Python3/lib/python3.9/site-packages/mageck-0.5.9.5-py3.9.egg-info --> Escape key 
# # --> :wq --> Enter key --> source .bashrc

# mageck --help

#MAGeCK Tutorial here:
#https://sourceforge.net/p/mageck/wiki/Home/#:~:text=code%20on%20Latch!-,Model%2Dbased%20Analysis%20of%20Genome%2Dwide%20CRISPR%2DCas9%20Knockout,screens%20(or%20GeCKO)%20technology.



# Download latest version of MAGeCKFlute using R
# export R_LIBS="/hpc/home/kailasamms/NGSTools/R_packages" 
# module load R/4.1.2
# R
# >if (!require("BiocManager", quietly = TRUE))
    # install.packages("BiocManager")

# >BiocManager::install("MAGeCKFlute", lib = "/hpc/home/kailasamms/NGSTools/R_packages", force = TRUE)


# Extract exons from GTF file and save it to annotation.txt
# cat $HOME/scratch/Hany/ref_genome/Mus_musculus.GRCm38.102.gtf | awk '{if($3 == "exon") print $1,$3,$4,$5,$7,$20,$24}' | sed 's/"//g' | sed 's/;//g' > annotation.txt

# To  print reads that have adapters:
# zcat ~/scratch/Neeraj/raw_reads/NA13R181_1.fq.gz | head -1000000 | awk /AGATCGGAAGAGCACACGTCTGAACTCCAGTCA/ | head -10
# zcat ~/scratch/Neeraj/raw_reads/NA13R181_1.fq.gz | awk /AGATCGGAAGAGCACACGTCTGAACTCCAGTCA/ | wc -l

# To check if trimming was successful and adapters removed in reads
# zcat ~/scratch/Neeraj/trimmed_reads/P_NA13R181_1.fq.gz | awk /AGATCGGAAGAGCACACGTCTGAACTCCAGTCA/ | wc -l

# To read the sequence of particular readID if cpp program gives segmentation fault etc
#zcat ~/scratch/Neeraj/raw_reads/NA13Ca1R_1.fq.gz | awk '/A00261:107:HHKJ2DMXX:2:1101:27163:30405/{print;getline;print;}'

# To find first 2 line numbers where string is present
# cat ~/scratch/Neeraj/ref_genome/Mus_musculus.GRCm38.dna_sm.primary_assembly.fa | awk '/Na/{print NR}' | head -2

# To get sequence between 2 lines and blast them to verify if seq matches with gene in gtf file
# cat -n ~/scratch/Neeraj/ref_genome/Mus_musculus.GRCm38.dna_sm.primary_assembly.fa | awk '{if((NR>53558)&&(NR<53563)) print}'

# To find read length i.e. number of bases in each read
# zcat ~/scratch/Neeraj/raw_reads/NA13Ca1R_1.fq.gz | head -2 | awk 'END {print}'| wc -c
