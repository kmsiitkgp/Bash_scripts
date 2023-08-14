#!/bin/bash -l

# Install ChIPQC package for R
export R_LIBS="/hpc/home/kailasamms/NGSTools/R_packages" 
module load R/4.1.2
R
>BiocManager::install("ChIPQC", lib = "/hpc/home/kailasamms/NGSTools/R_packages", force = TRUE)
>q()