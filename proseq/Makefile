hg19:
	bash preprocess.bsh /workdir
	bash align.bsh  /local/storage/data/short_read_index/hg19/bwa.rRNA-0.7.5a-r405/hg19.rRNA /workdir
	for i in `ls *.sort.bam`; do bash proseqBamToBigWig.bsh $i /local/storage/data/hg19/hg19.chromInfo /workdir; done
