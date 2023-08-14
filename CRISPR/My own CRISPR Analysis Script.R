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

library("metap")
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

path="C:/Users/KailasammS/Box/Saravana@cedars/05. Bioinformatics/Linda_CRISPRScreen/!KMS Analysis/1a. Counts (from KMS)/"
# Store the xlsx filename within venn folder that has data to be analyzed as a list
file <- list.files(path=path)

# Prepare a master dataframe with all read counts
combined_data <- data.frame(NA)
col_ids <- c("Gene")
for (i in file){
  data <- read.table(paste0(path,i), header = FALSE, sep = ",", encoding="UTF-8")
  new_data <- data[,c(1,6)]
  j <- str_replace(i,"counts_","")
  j <- str_replace(j, ".fastq.csv", "")
  col_ids <- append(col_ids, j)
  combined_data <- cbind(combined_data, new_data[,2])
}
colnames(combined_data) <- col_ids
combined_data$Gene <- new_data$V1

# Subset data of interest
cancer <- "CT2A"
treatment <- "E_PD1"
control <- "E_IgG"
subset_data <- combined_data %>% select(contains(cancer) & Gene & (contains(treatment) | (contains(control))))
subset_data <- subset_data %>% dplyr::filter(rowSums(.)  != 0)
subset_data <- scale(subset_data, center = FALSE)
treatment_data <- as.data.frame(subset_data) %>% select(contains(cancer) & (contains(treatment)))
control_data <- as.data.frame(subset_data) %>% select("Gene", contains(cancer) & (contains(control)))