# Read the output file into a dataframe
# Use fill= TRUE, so that blank fields are added if rows have enequal length
# Use skip=6, to remove first 6 lines of txt file
c <- read.table("C:/Users/KailasammS/Desktop/venn/LINDA_NeW.o171052.txt",header=FALSE,sep=":", fill = TRUE, comment.char= "",skip=6)

# Remove last 2 lines that have metadata
c <- c[1:(nrow(c)-2),]

# Remove all \t
c <- data.frame(lapply(c, function(x) {gsub("\t","", x)}))

# Remove all X
c <- data.frame(lapply(c, function(x) {gsub("X","", x)}))

#Create blank dataframe
d <- data.frame(0,0)

# Check if reference is present in read. If not, add it to dataframe
for (i in 0:(nrow(c)/3)){
  if(!grepl(c[i*3+1,2],c[i*3+2,2])){
    add_entry_1 <- c(c[i*3+1,1],c[i*3+1,2])
    add_entry_2 <- c(c[i*3+2,1],substr(c[i*3+2,2],1,30))
    add_entry_3 <- c("","")
    d <- rbind(d,add_entry_1,add_entry_2,add_entry_3)
    print(i+1)
  }
}

# Export list of reads that didnt match exactly with reference
# These reads have insertions, deletions, mismatches etc
write.csv(d[1048576:nrow(d),],file="mismatch.csv")
