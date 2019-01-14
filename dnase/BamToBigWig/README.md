# BamToBigWig function for DNase-I-seq data
Takes bam files from DNase-I sequencing data as input and writes plus and minus strand bigWig files as output to the user-assigned output-dir.

## Dependencies: 

The pipelines depend on several common bioinformatics tools: 
- [ ] samtools (http://www.htslib.org/download/)
- [ ] bedtools (http://bedtools.readthedocs.org/en/latest/)
- [ ] bedGraphToBigWig (from the Kent source utilities http://hgdownload.cse.ucsc.edu/admin/exe/)

Please make sure you can call the bioinformatics tools from your current working directory.  

## Usage

```
Takes bam files from DNase-I-seq data as input and writes bigWig files as output to the user-assigned output-dir.
    
Requirements in current working directory:
samtools, bedtools, and bedGraphToBigWig.
    
bash RunOnBamToBigWig.bsh [options]
    
options:
    
To get help:
-h, --help             Show this brief help menu.
    
Required options:
-c, --chrom-info=PATH  Location of the chromInfo table.
-SE, --SEQ=SE          Bam file from Single-end sequencing.
-PE, --SEQ=PE          Bam file from Paired-end sequencing.
    
I/O options:
-I, --bam=PREFIX.bam   Input bam file. If not specified, will take
                           *.bam in the current working directory as input
-T, --tmp=PATH         Path to a temporary storage directory.
-O, --output-dir=DIR   Specify a directory to store output in.
    
Optional operations:
--thread=1         Number of threads can be used [default: 1]
```
