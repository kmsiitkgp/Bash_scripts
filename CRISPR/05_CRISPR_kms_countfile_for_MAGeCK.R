#!/usr/bin/env Rscript

#********************STEP 1: SET UP THE WORKING ENVIRONMENT********************#

#*********************STEP 1A: INSTALL NECESSARY PACKAGES**********************#

.libPaths("/hpc/home/kailasamms/NGSTools/R_packages")
.libPaths()
chooseCRANmirror(ind=1)

# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install('multtest')        #Needed for installing metap
# install.packages('metap')               #Needed for using FindConservedMarkers
# BiocManager::install("AnnotationHub")   #Needed for accessing gene databases
# BiocManager::install("ensembldb")       #Needed for using ensembl database
# BiocManager::install("DESeq2")
# BiocManager::install("apelgm")
# BiocManager::install("limma")

# install.packages("Seurat")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("cowplot")
# install.packages("viridis")
# install.packages("stringr")
# install.packages("purrr")
# install.packages("ashr")
# install.packages("pheatmap")
# install.packages("RColorBrewer")
# install.packages("tibble")
# install.packages("readxl")
# install.packages("openxlsx")
# install.packages("ggrepel")

#*********************STEP 1B: LOAD THE NECESSARY PACKAGES*********************#

library("metap", lib.loc="/hpc/home/kailasamms/NGSTools/R_packages")
library("AnnotationHub")
library("DESeq2")
#library("apeglm")
library("Seurat")
library("dplyr")
library("ggplot2")		# Useful for plotting all types of graphs
library("cowplot")		# Useful for plotting multiple panels in same plot
library("viridis")		# Useful for making plots colorful
library("stringr")		# Useful for wrapping long labels in ggplot
library("purrr")		# Has map()
library("ashr")			# Needed for DESeq2
library("pheatmap")		# Useful for plotting heatmaps
library("RColorBrewer")
library("tibble")
library("readxl")		
library("openxlsx")		# Useful for reading and writing xlsx files
library("ggrepel")

#***************STEP 1C: STORE PATHS OF DIRECTORIES IN VARIABLES***************#

# Store path of parent directory containing individual folders for analysis
# Store path of results directory where DESeq2 output will be stored
# Store path of diagnostics directory where QC figures will be stored

parent_path <- "C:/Users/KailasammS/Box/Saravana@cedars/05. Bioinformatics/CRISPR/"
results_path <- "C:/Users/KailasammS/Box/Saravana@cedars/05. Bioinformatics/CRISPR/"
diagnostics_path <- "C:/Users/KailasammS/Box/Saravana@cedars/05. Bioinformatics/CRISPR/"

#*************************CREATE COUNT DATA FOR MAGeCK*************************# 

meta_table <- openxlsx::read.xlsx(xlsxFile = paste0(parent_path, "Jinfen/Jinfen_Metadata.xlsx"))
labels <- meta_table$Sampletype


# Create a  single dataframe containing counts of all genes from all samples 
# from individual csv files. We start by creating an empty dataframe with 0's
read_table <- data.frame(0)

count_folder <- paste0(parent_path, "Jinfen/1a. Counts (from KMS)/")
files <- list.files(path=count_folder)

# Create the reads table 
for (i in 1:length(files)){
  
  # Read the csv file
  temp_file <- read.table(file = paste0(count_folder, files[i]), header = TRUE, sep = ",")     
  
  # Append count column to counts table. Check if it is column 2 or column 3
  # and adjust  temp_file[,2] or  temp_file[,3]
  read_table <- bind_cols(read_table, temp_file[,6])                      
  
  # Rename the column names to sample names
  colnames(read_table)[i+1] <- files[i]     
}

# Check if all count files have same order of genes in the rows so that files can be merged together
gene_list <- temp_file[, 1]
for (i in 1:length(files)){
  
  temp_file <- read.table(file = paste0(count_folder, files[i]), header = TRUE, sep = ",")
  genes <- temp_file[, 1]
  
  if (identical(gene_list, genes)){ 
    print("Gene order is same between count files")
  } else {
    print("Gene order is different between the count files")
  }
}

# Add gene names to 1st column
read_table[, 1] <- gene_list

# If first cell has "Byte-Order-Mark" (BOM), correct it
read_table[1,1] <- stringr::str_replace(read_table[1,1], "ï»¿","")

# Add Gene column name to appropiate column
colnames(read_table)[1] <- "Gene"

# Create a column with sgRNA id as 1st column
read_table <- rownames_to_column(read_table, "sgRNA")

# Correct rest of column names to appropriate --treatment-id label and 
# --control-id labels used in MAGeCK test() and MAGeCK mle()
for (i in 1:ncol(read_table)){
  for (j in 1:length(labels)){
    if (stringr::str_detect(colnames(read_table)[i], meta_table$Sample.Name[j])){
      colnames(read_table)[i] <- labels[j]
    }
  }
}

# Save the count data as txt file for use in mageck test() and mageck mle()
write.table(x = read_table, file=paste0(parent_path, "Jinfen/MAGeCK_kms.count.txt"), sep = "\t",
            row.names = FALSE)

# Open the file and replace all " with blank