## R
args <- commandArgs(trailingOnly = TRUE)
prefix <- args[2]
data <- read.table("stdin")

pdf(paste(prefix, "readLengthDist.pdf", sep=""))
 hist(args$V1, main=prefix)
dev.off()
