#!/bin/bash -l

# Set Project Name
# Set Job Name
#$ -N Seurat
# Request memory
# You can find maxvmem from qstat -j <jobid> & adjust mem_free accordingly in final run.
#$ -l mem_free=96G
# Merge standard output and standard error
#$ -j y
# Set current working directory
#$ -cwd 
# Submit an array job with n tasks. Find n using: ls *.fastq.gz | wc -l 
#$ -t 1

# Keep track of information related to the current job
echo "=========================================================="
echo "Start date : $(date)"
echo "Job name   : $JOB_NAME"
echo "Job ID     : $JOB_ID"
echo "TaskID     : $SGE_TASK_ID"
echo "=========================================================="

# To use R version from cluster modules
#module load R/4.1.2

# You need to add path for R and indicate location of R packages (NOT GOOD)
#PATH=$HOME/R/R-4.2.2/bin/:$PATH
#export R_LIBS="/hpc/home/kailasamms/NGSTools/R_packages/4.1.2/"

# To use R from conda, you need to add path for Conda (RECOMMENDED)
PATH=$HOME/miniconda3/bin/:$PATH
# You have to use source activate instead of conda activate
source activate NGS

# Know the location from where Rscript is running
which Rscript

# If the cluster doesnt have a package you need to use, you have to install
# it in your local directory as you dont have root access to install in the clsuter
# There are 2 types of packages: 

# (i) Packages that can be installed from within R scipt that has been submitted as 
# a job Eg: install.pacakges("viridis") works fine

# (ii) Packages that cannot be installed from within R scipt that has been submitted as
# a job Eg: install.package("multtest") will fail. I think this is because some packages are written 
# in C/C++/Fortran and appropriate modules need to be loaded at the time of loading R.

# Packages that belong to type (ii), need to be manually installed before 
# submitting a job. 
# First, create a variable in UNIX to store path to install package i.e. library location 
# Now, there are 2 ways to install

# (i) This method is NOT RECOMMENDED because, you need to download the source code of the R 
# package as well as all the dependencies the package needs. Then, you need to install all
# the dependencies before installing the R package. Else, it will fail. 
# export R_LIBS="/hpc/home/kailasamms/NGSTools/R_packages"
# R CMD INSTALL -l ~/NGSTools/R_packages ~/NGSTools/R_packages/multtest.tar.gz

# (ii) This method is RECOMMENDED as R will automatically install the necessary dependencies.
# export R_LIBS="/hpc/home/kailasamms/NGSTools/R_packages" 
# module load R/4.1.2
# R
# >install.packages("hdf5r", configure.args="--with-hdf5=/hpc/apps/hdf5/1.8.18/bin/h5cc")  #locate where h5cc manually
# >install.packages("harmony")

# The cluster has an R library where Biobase, etc are already available. So, we have to use force = TRUE.
# Else, BiocManager will not install to our local library. 
# Also, set lib = <library location>. Else, BiocManager will not update dependencies of Biobase etc.
# >BiocManager::install("DESeq2", lib = "/hpc/home/kailasamms/NGSTools/R_packages", force = TRUE)
# >install.packages("metap")		# You need to install multtest before metap

# >q()								# Quit R and qsub your bash script to submit the job 

# chmod u+x ~/projects/scRNASeq/02d_scRNASeq_Seurat_HTO_Demux_KMS.R
# chmod u+x ~/projects/scRNASeq/04_scRNASeq_Seurat_Import-FindMarkers.R
# chmod u+x ~/projects/scRNASeq/04_scRNASeq_Seurat_QC.R
chmod u+x ~/projects/scRNASeq/SCENIC_Analysis.R
# chmod u+x ~/projects/scRNASeq/05_scRNA_Seq_Seurat_Annotation-SubtypeFindMarkers_Round1.R
# chmod u+x ~/projects/scRNASeq/06_scRNA_Seq_Seurat_Annotation-SubtypeFindMarkers_Round2.R
# chmod u+x ~/projects/scRNASeq/07_scRNA_Seq_Seurat_SubtypeAnnotation-Visualization.R
# chmod u+x ~/projects/scRNASeq/08_scRNA_Seq_Seurat_DESeq2.R

#Rscript ~/projects/scRNASeq/02d_scRNASeq_Seurat_HTO_Demux_KMS.R
#Rscript ~/projects/scRNASeq/04_scRNASeq_Seurat_Import-FindMarkers.R
Rscript ~/projects/scRNASeq/SCENIC_Analysis.R
#Rscript ~/projects/scRNASeq/04_scRNASeq_Seurat_QC.R
#Rscript ~/projects/scRNASeq/05_scRNA_Seq_Seurat_Annotation-SubtypeFindMarkers_Round1.R
#Rscript ~/projects/scRNASeq/06_scRNA_Seq_Seurat_Annotation-SubtypeFindMarkers_Round2.R
#Rscript ~/projects/scRNASeq/07_scRNA_Seq_Seurat_SubtypeAnnotation-Visualization.R
#Rscript ~/projects/scRNASeq/08_scRNA_Seq_Seurat_DESeq2.R

