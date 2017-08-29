Danko lab template for high-throughput paired-end PRO-seq reads trimming and alignment.
=============================================
* proseqHT.bsh is a pipeline that is modified from the original proseq.bsh pipeline to process high-throughput paired-end sequencing data.

* proseqHT_forShortInsert.bsh is modified from proseqHT.bsh to more accurately remove duplicate reads from paired-end data with short inserts. proseqHT_forShortInsert.bsh trys to merge paired-end reads (R1 and R2) that have at least 15bp overlap into single reads using SeqPrep. For those reads that cannot be merged by SeqPrep, proseqHT_forShortInsert.bsh will process them in the same way as in proseqHT.bsh.

* sepIndex.py - required for both proseqHT.bsh and proseqHT_forShortInsert.bsh.
* sepIndex_MergedReads.py - only required for proseqHT_forShortInsert.bsh to process the merged reads.
* example.bsh - gives an example of how to run the pipeline.

Dependencies: 
-------------

In addition to the in-house scripts provided, the pipelines depend on several common bioinformatics tools: 
Please make sure you can call the bioinformatics tools from your current working directory
- [ ] SeqPrep (only required for proseqHT_forShortInsert.bsh)
- [ ] cutadapt
- [ ] prinseq-lite.pl
- [ ] bwa
- [ ] samtools
- [ ] bedtools
- [ ] bedGraphToBigWig (from the Kent source utilities)
    
    
