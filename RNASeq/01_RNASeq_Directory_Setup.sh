#!/bin/bash -l

proj=RNA_Seq_TRAMP_GSE79756
OUTPUT_DIR=$HOME/scratch/$proj
GENOME_DIR=$HOME/NGSTools/RNASeq_Reference_Genomes

# Make these directories for each analysis.
# DO NOT create a indexed_ref_genome directory. STAR will create it.
# If you create it before STAR, STAR will give error.
mkdir $OUTPUT_DIR
mkdir $OUTPUT_DIR/fastqc_results
mkdir $OUTPUT_DIR/raw_reads
mkdir $OUTPUT_DIR/STAR_alignment_results
mkdir $OUTPUT_DIR/HTSeq_count_results

##Get latest version of "UNMASKED (not sm or rm versions), PRIMARY ASSEMBLY (not top level version)" Human Reference Genome (Fasta file)
wget -P $GENOME_DIR/Human/ https://ftp.ensembl.org/pub/release-109/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz --no-check-certificate
gunzip $GENOME_DIR/Human/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz

## Download and unpack the latest version of Human Reference Genome (GTF file)
wget -P $GENOME_DIR/Human/ https://ftp.ensembl.org/pub/release-109/gtf/homo_sapiens/Homo_sapiens.GRCh38.109.gtf.gz --no-check-certificate
gunzip $GENOME_DIR/Human/Homo_sapiens.GRCh38.109.gtf.gz


##Get latest version of "UNMASKED (not sm or rm versions), PRIMARY ASSEMBLY (not top level version)" Mouse Reference Genome (Fasta file)
wget -P $GENOME_DIR/Mouse/ https://ftp.ensembl.org/pub/release-108/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna.primary_assembly.fa.gz --no-check-certificate
gunzip $GENOME_DIR/Mouse/Mus_musculus.GRCm39.dna.primary_assembly.fa.gz

## Download and unpack the latest version of Mouse Reference Genome (GTF file)
wget -P $GENOME_DIR/Mouse/ https://ftp.ensembl.org/pub/release-108/gtf/mus_musculus/Mus_musculus.GRCm39.108.gtf.gz --no-check-certificate
gunzip $GENOME_DIR/Mouse/Mus_musculus.GRCm39.108.gtf.gz

# It is HIGHLY RECOMMENDED to run one qsub at a time although it is ok to qsub 04,05 and 06 simultaneously by sh (running) this script
# Below all jobs will be submitted one after another WITHOUT waiting for previous job to finish.
# This is fine for FastQC, FAT_Trimming and STAR_Genome_Indexing as they dont depend on each other.
# STAR_Alignment however, depends on results of STAR_Genome_Indexing and FAT_Trimming. So, best to run it separately on console.
# Similarly, HTSeq depends on results of STAR_Alignment. So, best to run it separately on console. 

qsub ~/projects/RNASeq/02_RNASeq_FastQC.sh
qsub ~/projects/RNASeq/03_RNASeq_STAR_Genome_Indexing.sh
qsub ~/projects/RNASeq/04_RNASeq_STAR_Alignment.sh
qsub ~/projects/RNASeq/05_RNASeq_HTSeq_Read_Counting.sh
# Run 09_RNA_Seq_DESeq2.R in RStudio, not UNIX.

# https://dnatech.genomecenter.ucdavis.edu/faqs/when-should-i-trim-my-illumina-reads-and-how-should-i-do-it/
#qsub ~/projects/RNASeq/05_RNASeq_FAT_Trimming.sh  #TRIMMING READS NOT REQUIRED ANYMORE

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

# Use this to figure out how many bases in each read
# zcat ~/scratch/Neeraj/raw_reads/NA13Ca1R_1.fq.gz | head -2 | awk 'END {print}'| wc -c

# I am pretty sure that your guess is correct and HTseq counts the total number of multimapping alignments rather the reads.
# You can check it by counting the number of multimapping lines yourself, e.g. with
# awk 'substr($1,1,1)!="@" && substr($12,6)>1 {n++} END {print n}' ~/scratch/RNASeq/Mukta_NA13_MB49/STAR_alignment_results/MB49_OE1Aligned.sortedByCoord.out.bam
# This should be equal to the HTseq number for "alignment_not_unique".