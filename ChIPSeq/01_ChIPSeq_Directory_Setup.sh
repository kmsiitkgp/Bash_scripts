#!/bin/bash -l

OUTPUT_DIR=$HOME/scratch/ChIPSeq
# Make these directories for each analysis.
# DO NOT create a indexed_ref_genome directory. STAR will create it.
# If you create it before STAR, STAR will give error.

mkdir $OUTPUT_DIR
mkdir $OUTPUT_DIR/raw_reads
mkdir $OUTPUT_DIR/trimmed_reads
mkdir $OUTPUT_DIR/ref_genome
#mkdir $OUTPUT_DIR/indexed_ref_genome ## DO NOT CREATE. STAR will create this folder automatically.
mkdir $OUTPUT_DIR/fastqc_results
mkdir $OUTPUT_DIR/STAR_alignment_results
mkdir $OUTPUT_DIR/Sambamba_results
mkdir $OUTPUT_DIR/HTSeq_count_results
mkdir $OUTPUT_DIR/MACS2_results
mkdir $OUTPUT_DIR/ChIPQC_results

## Get latest version of "UNMASKED (not sm or rm versions), PRIMARY ASSEMBLY (not top level version)" Human Reference Genome (Fasta file)
wget http://ftp.ensembl.org/pub/release-105/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz -P $OUTPUT_DIR/ref_genome/
gunzip $OUTPUT_DIR/ref_genome/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz 

## Get latest version of Human Reference Genome (GTF file)
wget http://ftp.ensembl.org/pub/release-105/gtf/homo_sapiens/Homo_sapiens.GRCh38.105.gtf.gz -P $OUTPUT_DIR/ref_genome/
gunzip $OUTPUT_DIR/ref_genome/Homo_sapiens.GRCh38.105.gtf.gz

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
