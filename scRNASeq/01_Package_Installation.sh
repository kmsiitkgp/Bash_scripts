#!/usr/bin/env bash

###***Run this script ONLY once***###
### If you already installed latest versions, DO NOT run this script again!
### Run this from login node. Some commands like unzip dont work in computing node.
### When you run scripts on login node, you need to indicate PATH in .bashrc file (as described above)
### When you run scripts on computing node, you need to indicate PATH within the script as computing nodes cant access your .bashrc file.
OUTPUT_DIR=$HOME/NGSTools

#***************************Cell Ranger***************************#
# Download and unpack CellRanger 7.1.0 to NGSTools folder
wget -P $OUTPUT_DIR "https://cf.10xgenomics.com/releases/cell-exp/cellranger-7.1.0.tar.gz?Expires=1671166706&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1leHAvY2VsbHJhbmdlci03LjEuMC50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2NzExNjY3MDZ9fX1dfQ__&Signature=bukaULMa2YUttBZMDXiTtW~g4wdz-2hICmvP~31EQiwntBU3NgXCOLwcphbW1RJ1ZSZ7cGvA4PQLbo5xjmWnWQxinb5ITkaJ4PBIDQ~SlWZXEE~HDYCXZR07027qBXEkdQB~ehWLmeeDkMYk6Lm~KiMe40a9s31M9g0tylro7xROSLZ-Xggrr6DO8IwhC-lM6FsRLSl8A5NCkl9I36YI~c5VlGboyIV7d5JD9QSYCrAkMrjOz1N-ZCouCwqXQY8-R77LareXMB6vIlY~ncfAK0-8MfREHqXbpHDHBGVrhUJXpBXh5ouqvfwamkOFjOddlIXEhgZ2rZMDlYUW2EId4A__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"

tar -xzvf $OUTPUT_DIR/cellranger-7.1.0.tar.gz -C $OUTPUT_DIR

# Download and unpack human reference genome to NGSTools folder
wget -P $OUTPUT_DIR https://cf.10xgenomics.com/supp/cell-exp/refdata-gex-GRCh38-2020-A.tar.gz
tar -xzvf $OUTPUT_DIR/refdata-gex-GRCh38-2020-A.tar.gz -C $OUTPUT_DIR

# Download and unpack mouse reference genome to NGSTools folder
wget -P $OUTPUT_DIR https://cf.10xgenomics.com/supp/cell-exp/refdata-gex-mm10-2020-A.tar.gz
tar -xzvf $OUTPUT_DIR/refdata-gex-mm10-2020-A.tar.gz -C $OUTPUT_DIR

# Prepend the Cell Ranger directory to your $PATH. This will allow you to invoke the cellranger command in this session ONLY.
export PATH=$OUTPUT_DIR/cellranger-7.1.0/bin/:$PATH

# Alternatively, add PATH to bashrc to automatically invoke every session
# vim ~/.bashrc --> i --> PATH=$HOME/NGSTools/cellranger-7.0.1/bin/:$PATH --> Escape key  --> :wq! --> Enter key --> source .bashrc (to reload bashrc)

# Verify if CellRanger is installed properly
cellranger --help
cellranger testrun --id=tiny

#********************************STAR********************************#
# Download, unpack and compile STAR to NGSTools folder
wget -P $OUTPUT_DIR https://github.com/alexdobin/STAR/archive/2.7.10b.tar.gz
tar -xzvf $OUTPUT_DIR/STAR-2.7.10b.tar.gz -C $OUTPUT_DIR
cd $OUTPUT_DIR/STAR-2.7.10b/source
make STAR

# Add PATH to bashrc to automatically invoke every session
# vim ~/.bashrc --> i --> PATH=$HOME/NGSTools/cellranger-7.0.1/bin/:$PATH --> Escape key  --> :wq! --> Enter key --> source .bashrc (to reload bashrc)

# Verify if STAR is installed properly
STAR --help

#********************************Java********************************#
# Download, unpack and compile Java to NGSTools folder
# There is no link to wget java. Download to desktop and copy to cluster.
tar -xzvf $OUTPUT_DIR/jdk-16.0.2+7.tar.gz -C $OUTPUT_DIR

# Add PATH to bashrc to automatically invoke every session
# vim ~/.bashrc --> i --> PATH=$HOME/NGSTools/jdk-16.0.2+7/bin/:$PATH --> Escape key  --> :wq! --> Enter key --> source .bashrc (to reload bashrc)

# Verify if Java is installed properly
java --help

#********************************FastQC********************************#
# FastQC needs a JRE (Java Runtime Environment). So, install Java first and then FastQC

wget -P $OUTPUT_DIR https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip --no-check-certificate 
unzip $OUTPUT_DIR/fastqc_v0.11.9.zip -d $OUTPUT_DIR
chmod u+x $OUTPUT_DIR/FastQC/fastqc

# Add PATH to bashrc to automatically invoke every session 
# vim ~/.bashrc --> i  --> PATH=$HOME/NGSTools/FastQC/:$PATH --> Escape key --> :wq --> Enter key --> source .bashrc

# Verify if fastqc is installed properly
fastqc --help

#********************************GDC Client********************************#

# Download and unpack GDC Data Transfer Tool Client (not GDC Data Transfer Tool UI) for Ubuntu x64 to NGSTools folder
wget -P $OUTPUT_DIR https://gdc.cancer.gov/files/public/file/gdc-client_v1.6.1_Ubuntu_x64.zip
unzip $OUTPUT_DIR/gdc-client_v1.6.1_Ubuntu_x64.zip -d $OUTPUT_DIR

# Create new folder "gdc-client_v1.6.1_Ubuntu_x64" and move "gdc-client.exe" to it

# Add PATH to bashrc to automatically invoke every session 
# vim ~/.bashrc --> i  --> PATH=$HOME/NGSTools/gdc-client_v1.6.1_Ubuntu_x64/:$PATH --> Escape key --> :wq --> Enter key --> source .bashrc

# Verify if gdc-client is installed properly
gdc-client --help
gdc-client download --help

#***************************SRA Toolkit***************************#
# Download SRA Toolkit using download link from https://www.ncbi.nlm.nih.gov/sra
# We are downloading the CentOS Linux x64 version

wget -P $OUTPUT_DIR https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.0.2/sratoolkit.3.0.2-centos_linux64.tar.gz 
tar -xzvf $OUTPUT_DIR/sratoolkit.3.0.2-centos_linux64.tar.gz  -C $OUTPUT_DIR

# Add PATH to bashrc to automatically invoke every session 
# vim ~/.bashrc --> i  --> PATH=$HOME/NGSTools/sratoolkit.3.0.2-centos_linux64/bin/:$PATH --> Escape key --> :wq --> Enter key --> source .bashrc

# Verify if fastq-dump is installed properly
which fastq-dump
fastq-dump --help

# If you get error asking you to run "vdb-config --interactive", do it.
# Simply exit by pressing "X" key and now try if fastq-dump is working
vdb-config --interactive
fastq-dump --help

# Now download the "Accession List" and copy it to cluster using Cyberduck.
# We can now run fastq-dump on each of the SRR accession numbers listed in the "Accession List"

#********************************Sambamaba********************************#
# Download and unpack Sambamba to NGSTools folder
wget -P $OUTPUT_DIR https://github.com/biod/sambamba/releases/download/v0.8.2/sambamba-0.8.2-linux-amd64-static.gz
gunzip -c $OUTPUT_DIR/sambamba-0.8.2-linux-amd64-static.gz > $OUTPUT_DIR/sambamba
# Create new folder "sambamba-0.8.2-linux-amd64-static" and move "sambamba.exe" to it
chmod u+x $OUTPUT_DIR/sambamba-0.8.2-linux-amd64-static/sambamba

# Add PATH to bashrc to automatically invoke every session 
# vim ~/.bashrc --> i  --> PATH=$HOME/NGSTools/sambamba-0.8.2-linux-amd64-static/:$PATH --> Escape key --> :wq --> Enter key --> source .bashrc

# Verify if sambamba is installed properly
sambamba --help

#********************************Samtools********************************#
# Download and unpack Sambamba to NGSTools folder
wget -P $OUTPUT_DIR https://github.com/samtools/samtools/releases/download/1.16.1/samtools-1.16.1.tar.bz2
tar -xvf $OUTPUT_DIR/samtools-1.16.1.tar.bz2 -C $OUTPUT_DIR
cd $OUTPUT_DIR/samtools-1.16.1
./configure --prefix=$OUTPUT_DIR/samtools-1.16.1
make
make install

# Add PATH to bashrc to automatically invoke every session 
# vim ~/.bashrc --> i  --> PATH=$HOME/NGSTools/samtools-1.16.1/bin/:$PATH --> Escape key --> :wq --> Enter key --> source .bashrc

# Verify if samtools is installed properly
samtools --help

# #********************************R (base)********************************#
# # R needs lots of dependencies. If you get error, install the necessary dependencies to R folder and see if error if fixed

# # # Download and unpack PCRE2 to R folder
# # wget -P $HOME/R https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.42/pcre2-10.42.tar.gz
# # tar -xzvf $HOME/R/pcre2-10.42.tar.gz -C $HOME/R
# # cd $HOME/R/pcre2-10.42
# # ./configure --prefix=$HOME/R/pcre2-10.42 ./configure --enable-jit
# # make
# # make install

# # # Add PATH to bashrc to automatically invoke every session 
# # # vim ~/.bashrc --> i  --> PATH=$HOME/R/pcre2-10.42/bin/:$PATH --> Escape key --> :wq --> Enter key --> source .bashrc

# # # Verify if pcre2 is installed properly
# # pcre2test --help

# # Download and unpack latest version of R to R folder
# wget -P $HOME/R https://cran.r-project.org/src/base/R-4/R-4.2.2.tar.gz
# tar -xzvf $HOME/R/R-4.2.2.tar.gz -C $HOME/R
# cd $HOME/R/R-4.2.2
# ./configure --prefix=$HOME/R/R-4.2.2 --with-x=no --with-pcre1
# # Unless you do not want to view graphs on-screen (or use macOS) you need ‘X11’ installed,
# # including its headers and client libraries. For recent Fedora/RedHat distributions it means (at
# # least) RPMs ‘libX11’, ‘libX11-devel’, ‘libXt’ and ‘libXt-devel’. On Debian/Ubuntu we
# # recommend the meta-package ‘xorg-dev’. If you really do not want these you will need to
# # explicitly configure R without X11, using --with-x=no
# make
# make install

# # Add PATH to bashrc to automatically invoke every session 
# # vim ~/.bashrc --> i  --> PATH=$HOME/R/R-4.2.2/bin/:$PATH --> Escape key --> :wq --> Enter key --> source .bashrc

# # Verify if R is installed properly
# R --help
# Rscript --help
# which R
# R --version

# #**********************************HDF5 Library files**********************#
# # Download latest version HDF5 from https://www.hdfgroup.org/downloads/hdf5/source-code/# and copy to cluster
# tar -xzvf $OUTPUT_DIR/hdf5-1.12.2.tar.gz  -C $OUTPUT_DIR
# cd $OUTPUT_DIR/hdf5-1.12.2
# ./configure --prefix=$OUTPUT_DIR/hdf5-1.12.2
# make
# make install
# make check-install

# #********************************CMake, FFTW********************************#
# # CMake is needed for installing several R packages like ggpubr
# # Download and unpack CMake to NGSTools folder
# wget -P $OUTPUT_DIR https://github.com/Kitware/CMake/releases/download/v3.25.1/cmake-3.25.1.tar.gz
# tar -xvf $OUTPUT_DIR/cmake-3.25.1.tar.gz -C $OUTPUT_DIR
# cd $OUTPUT_DIR/cmake-3.25.1
# ./configure --prefix=$OUTPUT_DIR/cmake-3.25.1
# make
# make install

# Add PATH to bashrc to automatically invoke every session 
# vim ~/.bashrc --> i  --> PATH=$HOME/NGSTools/cmake-3.25.1/bin/:$PATH --> Escape key --> :wq --> Enter key --> source .bashrc

# # Verify if cmake is installed properly
# cmake --help

# # FFTW is needed for installing several R packages like metap [STILL UNABLE TO INSTALL fgsea, enrichplot, clusterprofiler, seurat, survminer}
# wget -P $OUTPUT_DIR https://www.fftw.org/fftw-3.3.10.tar.gz --no-check-certificate
# tar -xvf $OUTPUT_DIR/fftw-3.3.10.tar.gz -C $OUTPUT_DIR
# cd $OUTPUT_DIR/fftw-3.3.10
# ./configure --prefix=$OUTPUT_DIR/fftw-3.3.10
# gmake 
# # If gmake doesnt work use:
# #make
# #make install

# # Add PKG_CONFIG_PATH of "fftw3.pc" to bashrc to automatically invoke every session
# # vim ~/.bashrc --> i  --> PKG_CONFIG_PATH=$HOME/NGSTools/fftw-3.3.10/:$PKG_CONFIG_PATH --> Escape key --> :wq --> Enter key --> source .bashrc

#********************************R (base)********************************#

# Installing R base directly is easy but several R packages will need CMake, fftw3, hdf5 etc
# and other dependencies. Fixing each of these is a headache and doesnt work most of the
# time. Several packages like Seurat couldnt be installed if R base is installed directly.
# However, Seurat was installed easily through miniconda.

# BEST option is to install R through miniconda.
# IMPORTANT: Install python in the environment during creation 
# r-essentails has over 100 extra non-R packages and ~175 R packages installed as compared to r-base (NOT RECOMMENDED)
# Use conda forge channel rather than default Anaconda channel
# https://stackoverflow.com/questions/39857289/should-conda-or-conda-forge-be-used-for-python-environments
conda create --name R python=3.9
conda activate R
conda search r-base
conda install -c conda-forge r-base           # install from channel conda forge

# Then type R to enter R and install packages as you normally do in R

#********************************Python********************************#
# https://conda.io/projects/conda/en/stable/user-guide/getting-started.html#managing-conda

mkdir $HOME/miniconda3
wget -P $HOME/miniconda3 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash $HOME/miniconda3/Miniconda3-latest-Linux-x86_64.sh -b -u -p $HOME/miniconda3
# -b to be able to run unattended, which means that all of the agreements are automatically accepted without user prompt. 
# -u updates any existing installation in the directory of install if there is one.
# -p is the directory to install into
# PATH is automatically added for miniconda and all python packages.
# Hence, you do not need to edit .bashrc file 

# Verify if conda is installed properly
conda --help
conda --version

# To update conda
conda update conda

# To automatically activate conda's base environment each time you login
# RECOMMENDED: You should create separate environment and not use base environment 
conda config --set auto_activate_base true
source .bashrc

# To manually, activate conda's base environment after logging in 
conda activate

# Create and activate new conda environment. Use deactivate to exit
conda create --name NGS
conda activate NGS

# To see all environements you created
conda info --envs

# Check if an environment "hany_proj" has package "beautifulsoup4".
# If not install it and see all installed packages in "hany_proj"
conda activate hany_proj
conda search beautifulsoup4
conda install beautifulsoup4
conda install pandas=1.4.4  # to install a specific version
conda list

# Remove package (in conda list if channel = pypi for a given package, use pip)
conda remove pandas
pip uninstall pandas

#**********************CITE-seq-Count (through conda)**********************#
# Install and upgrade to latest version of CITESeq-count through miniconda
conda activate NGS   #NGS environment was created for all NGS work
conda install pip  #This will install pip to NGS environment. 
# If you do not do this, pip from base environment will be used and pacakge
# will be installed in base environment's bin folder
pip install CITE-seq-Count==1.4.5
pip install CITE-seq-Count --upgrade

# Verify if CITE-seq-Count is installed properly
CITE-seq-Count --help

# PATH is automatically added for miniconda and all python packages.
# Hence, you do not need to edit .bashrc file 

#**********************HTSeq (through conda)**********************#
# Install and upgrade to latest version of HTSeq through miniconda
conda activate NGS   #NGS environment was created for all NGS work
conda install pip  #This will install pip to NGS environment. 
# If you do not do this, pip from base environment will be used and pacakge
# will be installed in base environment's bin folder
pip install HTSeq

# Verify if HTSeq is installed properly 
htseq-count --help

# PATH is automatically added for miniconda and all python packages.
# Hence, you do not need to edit .bashrc file 

#**********************MACS3 (through conda)**********************#
# Install and upgrade to latest version of MACS3 through miniconda
conda activate NGS   #NGS environment was created for all NGS work
conda install pip  #This will install pip to NGS environment. 
# If you do not do this, pip from base environment will be used and package
# will be installed in base environment's bin folder
pip install macs3

# Verify if macs3 is installed properly 
macs3 --help

# PATH is automatically added for miniconda and all python packages.
# Hence, you do not need to edit .bashrc file 

#**********************leidenalg (through conda)**********************#
# Install leidenalg needed for FindClusters() of Seurat through miniconda
conda activate NGS   #NGS environment was created for all NGS work
conda install pip    #This will install pip to NGS environment. 
# If you do not do this, pip from base environment will be used and package
# will be installed in base environment's bin folder
pip install leidenalg

# PATH is automatically added for miniconda and all python packages.
# Hence, you do not need to edit .bashrc file 

########################NOT NECESSARY AS WE USE MINICONDA
# mkdir $HOME/Python3
# wget -O $HOME/Python3/Python-3.11.1.tgz https://www.python.org/ftp/python/3.11.1/Python-3.11.1.tgz
# tar -xzvf $HOME/Python3/Python-3.11.1.tgz -C $HOME/Python3/
# cd $HOME/Python3/Python-3.11.1/
# $HOME/Python3/Python-3.11.1/configure --prefix=$HOME/Python3/    
# make
# make install
# ## Copy and paste PATH to .bashrc file using vim. (vim ~/.bashrc --> i  --> Escape key --> :wq --> Enter key --> source .bashrc (to reload bashrc)
# #PATH=$HOME/Python3/Python-3.9.1/:$PATH
# ## Copy and paste PYTHONPATH to .bashrc file using vim.
# #PYTHONPATH=$HOME/Python3/Python-3.9.1/
# # Verify if Python installed properly using which and version
# which python
# python --version

# ##*******Install latest version of pip*******##
# wget https://bootstrap.pypa.io/get-pip.py -P $HOME/Python3/
# python $HOME/Python3/get-pip.py --user
# #Upgrade pip, setuptools and wheel
# python -m pip install --upgrade pip setuptools wheel
# ## Copy and paste PATH to .bashrc file using vim.	PATH=$HOME/.local/bin/:$PATH
# # Verify if Python installed properly using which and version
# which pip
# pip --version