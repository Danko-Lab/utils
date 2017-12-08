#!/usr/bin/python
import sys
import gzip

if len(sys.argv) < 4: 
	sys.exit( "usage: python sepIndex.py file_R1.fastq file_R2.fastq output_prefix" )

in_fastq_R1 = sys.argv[1]
in_fastq_R2 = sys.argv[2]
out_prefix  = sys.argv[3]

print "Separating distinct index fastq files."
print "Fastq files:   " + in_fastq_R1 + " " + in_fastq_R2
print "Output prefix: " + out_prefix

## Reverse complement function.
def revComp(seq):
	seq_dict = {'A':'T','T':'A','G':'C','C':'G','N':'N'}
	return "".join([seq_dict[base] for base in reversed(seq)])

## http://stackoverflow.com/questions/29550290/how-to-open-a-list-of-files-in-python
idxids    = ['ATGC', 'TCGT', 'CGAT', 'GACG', 'GCAC', 'TGCA', 'CATG', 'GTCA', 'AGTC', 'TACT', 'CTAG', 'GCTG', 'NNNN']
revComp_idxids = [revComp(idx) for idx in idxids]
counts    = [0] * len(idxids)
discard   = 0
total     = 0

## Constant values.
i1        = 0  ## Indices of barcode
i2        = 4 
trimLeft  = 2 
trimRight = 10 




## Open input fastq files.
fastq1 = {revComp(idx): gzip.open(out_prefix+'_'+idx+'_R1.fastq.gz', 'wb') for idx in idxids}
fastq2 = {revComp(idx): gzip.open(out_prefix+'_'+idx+'_R2.fastq.gz', 'wb') for idx in idxids}

## Read through the fastq file.
r1=open(in_fastq_R1)
r2=open(in_fastq_R2)




while True:
	## File 1 
	r1_name = r1.readline()
	r1_seq  = r1.readline()
	r1_plus = r1.readline()
	r1_qual = r1.readline()
	
	## File 2
	r2_name = r2.readline()
	r2_seq  = r2.readline()
	r2_plus = r2.readline()
	r2_qual = r2.readline()

	## Check EOF
	if not r1_name: break #EOF
	if not r2_name: break 

	## Then record the entry!
	total += 1

	#####################################################################################
	## Trim 3' end of each read, if necessary because we have read through entire read 
	## and UMI is repeated on 3' end.

	## Does the reverse complement of the final 4 bases of R1 equal the first 4 of R2?
	## This code works iff adapters have already been clipped, but then should be pretty robust.
	#if revComp(r1_seq[-5:-1]) == r2_seq[:4] and revComp(r2_seq[-11:-1]) == r1_seq[:10]: ## The final character in the line is the newline character, so -5:-1.
	#	r1_seq = r1_seq[:-5] + "\n"
	#	r2_seq = r2_seq[:-11] + "\n"

	##############################################
	## Separate distinct 5' barcodes.  ID idx.
	try:
		fastq1[r2_seq[i1:i2]].write(r1_name+r1_seq[trimLeft:]+r1_plus+r1_qual[trimLeft:])
		fastq2[r2_seq[i1:i2]].write(r2_name+r2_seq[trimRight:]+r2_plus+r2_qual[trimRight:])
		fileidx = revComp_idxids.index(r2_seq[i1:i2])
		counts[fileidx] += 1
	except (KeyError, ValueError) as e:
		fastq1['NNNN'].write(r1_name+r1_seq+r1_plus+r1_qual)
		fastq2['NNNN'].write(r2_name+r2_seq+r2_plus+r2_qual)
		discard +=1
		continue


## Close
for file in fastq1.values():
	file.close()

for file in fastq2.values():
	file.close()

print "Distinct index fastq files are Separated from:"
print "Fastq files:   " + in_fastq_R1 + " " + in_fastq_R2
print "Output prefix: " + out_prefix

## Print debug information
for i in range(len(counts)): 
	print str(idxids[i]) + ": " + str(counts[i]) + " of " + str(total) + "(" + str(float(counts[i])/float(total)*100) + "%)."

print "No idex: " + str(discard) + " of " + str(total) + "(" + str(float(discard)/float(total)*100) + "%)."


