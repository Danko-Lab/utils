proseqHT.bsh is a pipeline that modified from proseq.bsh to process the high through put pair end sequecing protocol.

proseqHT_forShortInsert.bsh is modified from proseqHT.bsh. While proseqHT.bsh processed paired reads, proseqHT_forShortInsert.bsh
trys to merge paired reads (R1 and R2) that have at least 15bp overlap into single reads using SeqPrep. For those reads that cannot be merged by SeqPrep, proseqHT_forShortInsert.bsh will process them in the same way as in proseqHT.bsh.

example.bsh give an example of how to run the pipeline.

