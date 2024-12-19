#!/bin/bash
## 2_make_sample_sheet.sh
# Usage: `bash 2_make_sample_sheet.sh`

source ./config.cfg
echo "Fastq files found in: " $FASTQDIR
echo "Sample sheet: " $SAMPLE_SHEET

# Create .list files with R1 and R2 fastqs.  Sort will put them in same orders, assuming files are paired
find $FASTQDIR -maxdepth 1 -name "*.fastq.gz"  ! -name "*MSA55*" | grep -e "_R1" | sort > R1.list ;
find $FASTQDIR -maxdepth 1 -name "*.fastq.gz"  ! -name "*MSA55*" | grep -e "_R2" | sort > R2.list ;

# For debug purposes... delete sample sheet if it exists
if [ -f "${SAMPLE_SHEET}" ] ; then
  rm "${SAMPLE_SHEET}"
fi

# make sample sheet from R1 and R2 files.  Format on each line looks like (space separated):
# MSA# /path/to/MSA#_R1.fastq /path/to/MSA#_R2.fastq
# from sample sheet, we can access individual items from each line with e.g. `awk '{print $3}' sample_sheet.txt`
paste R1.list R2.list | while read R1 R2 ;
do
    outdir_root=$(basename "${R2}" | cut -f1 -d"_") ;
    sample_line="${outdir_root} ${R1} ${R2}" ;
    echo "${sample_line}" >> $SAMPLE_SHEET
done

rm R1.list
rm R2.list

echo 'Sample sheet contents:'
cat $SAMPLE_SHEET
