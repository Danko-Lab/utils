#!/usr/bin/bash
#
while test $# -gt 0; do
        case "$1" in
                -h|--help)
    echo ""
    echo "Takes bam files from ATAC-seq data as input and writes" 
    echo "bigWig files as output to the user-assigned output-dir."
    echo ""
    echo "Requirements in current working directory:"
    echo "samtools, bedtools, and bedGraphToBigWig."
    echo ""
    echo "bash RunOnBamToBigWig.bsh [options]"
    echo ""
    echo "options:"
    echo ""
    echo "To get help:"
    echo "-h, --help             Show this brief help menu."
    echo ""
    echo "Required options:"
    echo "-c, --chrom-info=PATH  Location of the chromInfo table."
    echo ""
    echo "I/O options:"
    echo "-I, --bam=PREFIX.bam   Input bam file. If not specified, will take"
    echo "                       *.bam in the current working directory as input"
    echo "-T, --tmp=PATH         Path to a temporary storage directory."
    echo "-O, --output-dir=DIR   Specify a directory to store output in."
    echo ""
    echo "Optional operations:"
    echo "--thread=1         Number of threads can be used [default: 1]"
    echo ""

                        exit 0
                        ;;

                -c)
                        shift
                        if test $# -gt 0; then
                                export CHINFO=$1
                        else
                                echo "no chromInfo specified"
                                exit 1
                        fi
                        shift
                        ;;
                --chrom-info*)
                        export CHINFO=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -I)
                        shift
                        if test $# -gt 0; then
                                export BAM_INPUT=$1
                        else
                                echo "no input bam file specified."
                                exit 1
                        fi
                        shift
                        ;;
                --bam*)
                        export BAM_INPUT=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -T)
                        shift
                        if test $# -gt 0; then
                                export TMPDIR=$1
                        else
                                echo "no temp folder specified."
                                exit 1
                        fi
                        shift
                        ;;
                --tmp*)
                        export TMPDIR=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -O)
                        shift
                        if test $# -gt 0; then
                                export OUTPUT=$1
                        else
                                echo "no output dir specified."
                                exit 1
                        fi
                        shift
                        ;;
                --output-dir*)
                        export OUTPUT=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                --thread*)
                        export thread=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                *)
                        break
                        ;;
        esac
done



## CHECK ARGUMENTS.
if [ -z "$CHINFO" ]; then
        echo "--chrom-info is required."
        echo " use bash RunOnBamToBigWig.bsh --help."
        exit 1
fi


## INPUT & Parameters
if [ -z "$BAM_INPUT" ]; then
   echo "No input files specified.  Using *.bam"
   BAM_INPUT=`ls *.bam`
fi



# Check input file number
if [[ ${#BAM_INPUT[@]} == 0 ]]; then  # if the length of array is 0
  echo "#####################################"
  echo " No files is in the correct format."
  echo "#####################################"
  exit 1
fi

if [ -z "$OUTPUT" ]; then
  now=$(date +"%m_%d_%Y")
  OUTPUT=./My_output-${now}
  echo No output path specified.  Using ${OUTPUT}
fi

if [ ! -d $OUTPUT ]; then
  mkdir $OUTPUT
fi
if [ -z "$TMPDIR" ]; then
        TMPDIR="./"
fi
if [ ! -d $TMPDIR ]; then
  mkdir $TMPDIR
fi


# bash generate random 32 character alphanumeric string (upper and lowercase).
tmp=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
TMPDIR=$TMPDIR/$tmp

if [ -z "$thread" ]; then
   thread=1
fi



## Check all the bioinformatics tools can be called from current working directory.
for tool in samtools bedtools bedGraphToBigWig sort-bed
do command -v ${tool} >/dev/null 2>&1 || { echo >&2 ${tool}" is required. Please make sure you can call the bioinformatics tools from your current working directoryb.  Aborting."; exit 1; }
done

exec > >(tee ${OUTPUT}/RunOnBamToBigWig.log)
exec 2>&1

## Print out
echo " " 
echo "Processing ..." 

echo ""
echo "Input files/ paths:"
echo "chromInfo                 $CHINFO"

i=1
for name in ${BAM_INPUT[@]}
  do 
echo "input file $i              ${name}"
  let "i++"
done

echo "temp folder               $TMPDIR"
echo "output-dir                $OUTPUT"
echo " "
echo "Optional operations:"
echo "number of threads         $thread"


mkdir ${TMPDIR}

#############################################
## Write out the bigWigs.
echo " "
   for f in ${BAM_INPUT[@]}
    do
    j=`echo $f | awk -F"/" '{print $NF}' | rev | cut -d \. -f 2- |rev `
    echo $j > ${OUTPUT}/${j}.align.log
    echo "Sorting $f"
    samtools sort -n -@ ${thread} $f > ${TMPDIR}/${j}.sort.bam

    bedtools bamtobed -bedpe -mate1 -i ${TMPDIR}/${j}.sort.bam 2> ${TMPDIR}/kill.warnings | awk 'BEGIN{OFS="\t"} ($5 > 20){print $0}' | \
    #    awk 'BEGIN{OFS="\t"} ($6 == "+") {print $1,$2,$2+1,$4,$5,$6}; ($6 == "-") {print $1,$3-1,$3,$4,$5,$6}' | gzip > {TMPDIR}/$j.bed.gz


    bedtools bamtobed -i ${TMPDIR}/${j}.sort.bam 2> ${TMPDIR}/kill.warnings | awk 'BEGIN{OFS="\t"} ($5 > 20){print $0}' | \
        awk 'BEGIN{OFS="\t"} ($6 == "+") {print $1,$2,$2+1,$4,$5,$6}; ($6 == "-") {print $1,$3-1,$3,$4,$5,$6}' | sort-bed - | gzip > ${TMPDIR}/$j.bed.gz
   echo 'Number of mappable reads:' >> ${OUTPUT}/${j}.align.log
   echo `zcat ${TMPDIR}/$j.bed.gz | grep "" -c` >> ${OUTPUT}/${j}.align.log

   ## Convert to bedGraph 
   bedtools genomecov -bg -i ${TMPDIR}/$j.nr.rs.bed.gz -g ${CHINFO} -strand + > ${TMPDIR}/$j\_plus.bedGraph
   bedtools genomecov -bg -i  ${TMPDIR}/$j.nr.rs.bed.gz -g ${CHINFO} -strand - > ${TMPDIR}/$j\_minus.noinv.bedGraph

   ## Invert minus strand and shift reads.
   cat ${TMPDIR}/$j\_minus.noinv.bedGraph | awk 'BEGIN{OFS="\t"} {print $1,$2,$3,-1*$4}' > ${TMPDIR}/$j\_minus_shift.bedGraph 

   ## Shift reads plus strand.
   cat ${TMPDIR}/$j\_plus.bedGraph| awk 'BEGIN{OFS="\t"} {print $1,$2+4,$3+4,$4}' > ${TMPDIR}/$j\_plus_shift.bedGraph  ## Invert read counts on the minus strand.

   ## Then to bigWig
   echo "Writing bigWigs:"
   bedGraphToBigWig ${TMPDIR}/$j\_plus_shift.bedGraph ${CHINFO} ${OUTPUT}/$j\_plus.bw
   bedGraphToBigWig ${TMPDIR}/$j\_minus_shift.bedGraph ${CHINFO} ${OUTPUT}/$j\_minus.bw

 done

rm -rf ${TMPDIR} 
