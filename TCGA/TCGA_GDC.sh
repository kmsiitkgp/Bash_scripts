#!/usr/bin/env bash

MANIFEST_FILE=gdc_manifest_2023-04-17.txt

# Download the TCGA data into data folder
gdc-client download --dir $HOME/projects/TCGA_GDC/data --manifest $HOME/projects/TCGA_GDC/$MANIFEST_FILE --latest

# If the downloaded files are in .gz format, use code below to extract them and store in counts folder 
gunzip -c $HOME/projects/TCGA-GDC/data/*/*.htseq.counts.gz > $HOME/projects/TCGA-GDC/counts/

# Run either above line (i.e. gunzip -c ... > ... ) (OR) below 2 lines
# gunzip $HOME/projects/TCGA_GDC/data/*/*.htseq.counts.gz
# mv $HOME/projects/TCGA_GDC/data/*/*_star_* $HOME/projects/TCGA_GDC/counts/

# # If the downloaded files are already in .tsv format, just copy them to counts folder 
mv $HOME/projects/TCGA_GDC/data/*/*_star_*.tsv $HOME/projects/TCGA_GDC/counts/

# Download the counts folder and analyze in R

# You can run this script using code below
#sh ~/projects/TCGA-GDC/TCGA_GDC.sh




