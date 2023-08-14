#!/bin/bash -l

## Get latest version of Java for linux_64, transfer it NGSTools directory using cyberduck, unzip and load java module
##*******Install latest version of Java*******##
tar -xzvf $OUTPUT_DIR/jre-8u271-linux-x64.tar.gz -C $OUTPUT_DIR

##*******Install latest version of Trimmomatic*******##
wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip -P $OUTPUT_DIR/
unzip $OUTPUT_DIR/Trimmomatic-0.39.zip -d $OUTPUT_DIR

