#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=fastqc
#SBATCH --time=04:00:00
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --output=/work/geisingerlab/Mark/breseq/2024-12-19_breseq_analyze_NER_coverage_summaries/logs/%x-%j.out
#SBATCH --error=/work/geisingerlab/Mark/breseq/2024-12-19_breseq_analyze_NER_coverage_summaries/logs/%x-%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=soo.m@northeastern.edu

echo "Starting fastqc SBATCH script $(date)"

echo "Loading environment and tools"
#fastqc requires OpenJDK/19.0.1
module load OpenJDK/19.0.1
module load fastqc/0.11.9

source ./config.cfg

echo "Project directory: " $BASE_DIR
echo "List file containing samples to FASTQC: " $FASTQ_FILE_LIST
echo "Fastqc output: " $FASTQC_OUT_DIR

mkdir -p $FASTQC_OUT_DIR

echo "Running fastqc on files listed in $FASTQ_FILE_LIST"
while read file; do
  fastqc $file
done <$FASTQ_FILE_LIST

echo "Cleaning up logs and output files"

mkdir -p $FASTQC_OUT_DIR/fastqc_html $FASTQC_OUT_DIR/fastqc_zip
mv $FASTQDIR/*fastqc.html $FASTQC_OUT_DIR/fastqc_html
mv $FASTQDIR/*fastqc.zip $FASTQC_OUT_DIR/fastqc_zip
