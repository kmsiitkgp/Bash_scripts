# Check number of reads in bam file and other statistics
~/NGSTools/sambamba-0.8.2-linux-amd64-static  flagstat ~/scratch/ChIPSeq/STAR_alignment_results/ChIP_AR_SRR11467745.fastqAligned.sortedByCoord.out.bam

# The output of the above command is as follows:
# 29642046 + 0 in total (QC-passed reads + QC-failed reads)  <----TOTAL NUMBER OF ALIGNMENTS (PRIMARY +SECONDARY) 
# 4519256 + 0 secondary                                      <----NUMBER OF SECONDARY ALIGNMENTS
# 0 + 0 supplementary
# 0 + 0 duplicates
# 29642046 + 0 mapped (100.00%:N/A)
# 0 + 0 paired in sequencing
# 0 + 0 read1
# 0 + 0 read2
# 0 + 0 properly paired (N/A:N/A)
# 0 + 0 with itself and mate mapped
# 0 + 0 singletons (N/A:N/A)
# 0 + 0 with mate mapped to a different chr
# 0 + 0 with mate mapped to a different chr (mapQ>=5)

# PRIMARY ALIGNMENT for a read is the alignment with best MAPQ score. So, there will be only 1 PRIMARY ALIGNMENT for every mapped read irrespective of unique or multimapped read.
# SECONDARY ALIGNMENT for a read consists of all possible alignments. Unique mapped reads will have NO SECONDARY ALIGNMENT. Multimapped reads will have 1 or more SECONDARY ALIGNMENT.
# NUMBER OF PRIMARY ALIGNMENTS = 1 best alignment for each unique mapped reads + 1 best aligment for each multimapped read.
# In our case, NUMBER OF PRIMARY ALIGNMENTS = 29642046 - 4519256 = 25122790 = 23485281 unique mapped reads (see STAR output below) + 1637509 best aligned read for multimapped reads (see STAR output below)
# There are multiple ways to extract these UNIQUE READS. MAPQ=255 or NH=1 can be used to extract these unique reads from bam file.
# By default, STAR doesnt output unampped reads

# The STAR output from "SRR11467745.fastqLog.final.out" file is as follows:
                                 # Started job on |	Feb 10 17:16:54
                             # Started mapping on |	Feb 10 17:21:08
                                    # Finished on |	Feb 10 17:52:02
       # Mapping speed, Million of reads per hour |	53.33

                          # Number of input reads |	27463731       <------TOTAL READS
                      # Average input read length |	50
                                    # UNIQUE READS:
                   # Uniquely mapped reads number |	23485281  	   <------UNIQUELY MAPPED READS   
                        # Uniquely mapped reads % |	85.51%
                          # Average mapped length |	49.91
                       # Number of splices: Total |	49
            # Number of splices: Annotated (sjdb) |	49
                       # Number of splices: GT/AG |	43
                       # Number of splices: GC/AG |	4
                       # Number of splices: AT/AC |	0
               # Number of splices: Non-canonical |	2
                      # Mismatch rate per base, % |	0.15%
                         # Deletion rate per base |	0.00%
                        # Deletion average length |	1.00
                        # Insertion rate per base |	0.00%
                       # Insertion average length |	1.42
                             # MULTI-MAPPING READS:
        # Number of reads mapped to multiple loci |	1637509		   <------MULTI MAPPED READS
             # % of reads mapped to multiple loci |	5.96%
        # Number of reads mapped to too many loci |	470540         <------MULTI MAPPED READS
             # % of reads mapped to too many loci |	1.71%
                                  # UNMAPPED READS:
  # Number of reads unmapped: too many mismatches |	0
       # % of reads unmapped: too many mismatches |	0.00%
            # Number of reads unmapped: too short |	932513         <------UNMAPPED READS (These reads are not output in SAM or BAM files by default)
                 # % of reads unmapped: too short |	3.40%
                # Number of reads unmapped: other |	937888         <------UNMAPPED READS (These reads are not output in SAM or BAM files by default)
                     # % of reads unmapped: other |	3.42%
                                  # CHIMERIC READS:
                       # Number of chimeric reads |	0
                            # % of chimeric reads |	0.00%

# This doesnt correctly identify unique mapped reads. It identifies all primary alignments which is NOT useful for ChIPSeq analysis.
~/NGSTools/sambamba-0.8.2-linux-amd64-static view --filter "not (unmapped or duplicate or chimeric or supplementary or secondary_alignment)" --format bam --with-header --valid --show-progress --output-filename ~/test.bam ~/scratch/ChIPSeq/STAR_alignment_results/ChIP_AR_SRR11467745.fastqAligned.sortedByCoord.out.bam

~/NGSTools/sambamba-0.8.2-linux-amd64-static  flagstat ~/test.bam

#This correctly identifies unique mapped reads
~/NGSTools/sambamba-0.8.2-linux-amd64-static view --filter "[NH] == 1" --format bam --with-header --valid --show-progress --output-filename ~/test1.bam ~/scratch/ChIPSeq/STAR_alignment_results/ChIP_AR_SRR11467745.fastqAligned.sortedByCoord.out.bam

~/NGSTools/sambamba-0.8.2-linux-amd64-static  flagstat ~/test1.bam

#This correctly identifies unique mapped reads
~/NGSTools/sambamba-0.8.2-linux-amd64-static view --filter "mapping_quality == 255" --format bam --with-header --valid --show-progress --output-filename ~/test2.bam ~/scratch/ChIPSeq/STAR_alignment_results/ChIP_AR_SRR11467745.fastqAligned.sortedByCoord.out.bam

~/NGSTools/sambamba-0.8.2-linux-amd64-static  flagstat ~/test2.bam

samtools flagstat ~/scratch/ChIPSeq/STAR_alignment_results/ChIP_AR_SRR11467745.fastqAligned.sortedByCoord.out.bam
