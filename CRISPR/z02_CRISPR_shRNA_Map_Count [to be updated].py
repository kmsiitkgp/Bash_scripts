#!/usr/bin/env python3

import pandas
import gzip
import sys
import time

# The metafile must have (i) no headers (ii) gene names on first column (iii) guide sequence on 2nd column
# If headers are present, then add header=0 in pandas.read_csv()
start_time = time.time()
input_fastq_file_with_path = sys.argv[1]
output_fastq_file_with_path = sys.argv[2]
start = int(sys.argv[3])   # number of bases to ignore at 5' end of read before starting search for guide or shRNA
end = int(sys.argv[4])     # number of bases to ignore at 3' end of read before starting search for guide or shRNA
meta_file_with_path = sys.argv[5]   # the metafile with guide or shRNA sequence and gene to which they belong

count_file = pandas.read_csv(meta_file_with_path, names=["GENE","GUIDE","GUIDE_RC","START","END","COUNTS"])
reference = "X"
reference_rc = "X"
index = 0

for guide in count_file['GUIDE']:
  l = len(guide)
  rc_guide = ""
  for j in guide:
    if j == "A":
      rc_guide = "T" + rc_guide
    elif j == "T":
      rc_guide = "A" + rc_guide
    elif j == "G":
      rc_guide = "C" + rc_guide
    elif j == "C":
      rc_guide = "G" + rc_guide

  count_file.loc[index, 'GUIDE_REV'] = rc_guide.strip()
  reference = reference + guide + "X"
  reference_rc = reference_rc + rc_guide + "X"
  count_file.loc[index, 'START'] = reference.find(guide)
  count_file.loc[index, 'END'] = count_file.loc[index, 'START'] + l - 1
  count_file.loc[index, 'COUNT'] = 0
  index = index + 1
print("COUNTS TABLE INITIALIZED")

file = gzip.open(input_fastq_file_with_path,"r")
line_count = 0
seed_len = 5
threshold = 3   #maximum number of mismatches allowed
pseudogenome = reference_rc

for line in file:
  if line_count % 4 == 1:                 # every 2nd line is the read
    line = line.decode("utf-8").strip()
    read = line[start:end]                #trim the read based on user input
    while read.find("N") >= 0:              #remove all bases before N
      read = read[read.find("N")+1:]
    #print(read)

    for n in range(1, int(len(read) / seed_len)):
      seed_seq = read[(n - 1)*seed_len:n*seed_len]          # declare initial seed_seq = read[0:5]
      counts = pseudogenome.count(seed_seq)                    # find number of occurrences of seed_seq

      base = 0                                              # base variable tracks position of base beyond seed_seq
      while counts > 1 and (n*seed_len)+base < len(read):   # loop through till counts = 0 or end of read is reached
        base = base + 1
        counts = pseudogenome.count(read[(n - 1) * seed_len:(n * seed_len) + base])

      # If while loop was exited as end of read was reached, counts could be > 0. In this case, we dont reduce base by 1
      # Note that we NEED base > 0 condition because counts can be 0 even without going through while loop
      # Also, we NEED to execute, "if base > 0 and counts > 0:" block before "if base > 0 and counts == 0:" block
      # because, if we do it the other way, counts will always be > 0 and both blocks will be executed
      if base > 0 and counts > 0:
        seed_seq = read[(n - 1) * seed_len:(n * seed_len) + base]
        counts = pseudogenome.count(seed_seq)

      # If while loop was exited as counts = 0, reduce base by 1 so that counts is now >= 1
      # Note that we NEED base > 0 condition because counts can be 0 even without going through while loop
      if base > 0 and counts == 0:
        base = base - 1
        seed_seq = read[(n - 1)*seed_len:(n*seed_len)+base]
        counts = pseudogenome.count(seed_seq)

      #print("n:",n)
      #print("seed_seq:", seed_seq)
      #print("counts:", counts)
      # Now, we record all positions in reference where seed_seq matches
      # Then, compare read and reference sequences from each match position.
      # If we end up with ONLY 1 of these match postions having less than 2 mismatch, we exit loop.
      # Else, we compare next 5 bases i.e. start of for loop

      legit_match_pos = []
      if counts > 0:                # if counts >0, we record all starting positions where seed_seq occurs in reference
        match_pos = [0]*counts      # initialize a list of 0 equal to number of counts

        for i in range(0,counts):
          if i == 0:
            match_pos[i] = pseudogenome.find(seed_seq)
            #if line_count == 190105:
              #print(match_pos[i])
              #print(seed_seq)
          else:
            match_pos[i] = match_pos[i-1]+len(seed_seq)+pseudogenome[match_pos[i-1]+len(seed_seq):].find(seed_seq)
            #if line_count == 190105:
              #print(len(seed_seq))
              #print(seed_seq)
              #print(match_pos[i])

          read_match_pos = read.find(seed_seq)

          j = 0                   # keeps track of number of bases that have been compared upstream of match position
          mismatch = 0
          while read_match_pos + seed_len + base + j < len(read) and pseudogenome[match_pos[i] + seed_len +base+ j] != 'X':
            if read[read_match_pos+seed_len+base+j] == pseudogenome[match_pos[i] + seed_len +base+ j]:
              j = j + 1
            elif mismatch < threshold:
              mismatch = mismatch + 1
              j = j + 1
            else:
              break

          k = 1                   # keeps track of number of bases that have been compared downstream of match position
          while read_match_pos - k >= 0 and pseudogenome[match_pos[i] - k] != 'X':
            if read[read_match_pos - k] == pseudogenome[match_pos[i] - k]:
              k = k + 1
            elif mismatch < threshold:
              mismatch = mismatch + 1
              k = k + 1
            else:
              break

          #print("j:",j)
          #print("k:",k)
          # if more than 3 bases have been compared, record mismatch
          if j+k > 2 and mismatch < threshold:
            legit_match_pos.append(match_pos[i])

        #print("legit_match_pos:", legit_match_pos)
        #print(read[read_match_pos - k:read_match_pos + seed_len + base + j])

      #if line_count == 190105:
        #print(line_count, "\n", match_pos, "\n", legit_match_pos, "\n", seed_seq, "\n", read, "\n", read_match_pos)
      if len(legit_match_pos) == 1:
        e = count_file.index[(count_file['START'] <= legit_match_pos[0]) & (count_file['END'] >= legit_match_pos[0])].tolist()
        count_file.loc[e[0], 'COUNT'] = count_file.loc[e[0], 'COUNT'] + 1
        break

  #if line_count == 190105:
    #break
  line_count=line_count+1

print("--- %s seconds ---" % (time.time() - start_time))
#df2 = pandas.DataFrame({"READ":reads[:100],"MAPPED":read_mapped,"GENE":read_gene})
#print(df2)
count_file.to_csv(output_fastq_file_with_path)
#count_file.to_csv("a.csv")
