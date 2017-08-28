proseqHT.bsh is a pipeline that is modified from the original proseq.bsh pipeline to process high-throughput paired-end sequencing data.

proseqHT_forShortInsert.bsh is modified from proseqHT.bsh to more accurately remove duplicate reads from paired-end data with short inserts. proseqHT_forShortInsert.bsh trys to merge paired-end reads (R1 and R2) that have at least 15bp overlap into single reads using SeqPrep. For those reads that cannot be merged by SeqPrep, proseqHT_forShortInsert.bsh will process them in the same way as in proseqHT.bsh.

example.bsh gives an example of how to run the pipeline.

