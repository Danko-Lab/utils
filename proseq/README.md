Danko lab pipeline for PRO-seq alignment/ QC.
=============================================

This pipeline is intended for use with data from the standard PRO-seq protocol.  Note that the recommended steps are slightly different for GRO-seq

Dependencies: 
-------------

Depends on several common bioinformatics tools: 
(1) bedtools
(2) bedops
(3) bedGraphToBigWig (from the Kent source utilities)

Instructions:
-------------

(1) Checkout a local copy with git clone.
(2) Edit files/ paths.  Certain common files are hard-coded to Danko lab HPC paths for convenience.  Change: 
    (a) $bwaindex and $scratch variables in align.bsh 
    (b) $chromInfo and $scratch variables in proseqBamToBigWig.bsh
    (c) The adapter sequence, if necessary, in preprocess.bsh


Notes: 
------

* The standard steps are slightly different for GRO-seq.  GRO-seq libraries should not be reverse complemented.
* Any others?
