do_analysis:
	bash preprocess.bsh
	bash align.bsh  
	for i in `ls *.sort.bam`; do bash proseqBamToBigWig.bsh $i; done
