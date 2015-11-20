## R
args <- commandArgs(trailingOnly = TRUE)
data <- read.table(args[1])
prefix <- args[2]

pdf(paste(prefix, "readLengthDist.pdf", sep=""))
 hist(args$V1, main=prefix)
dev.off()
