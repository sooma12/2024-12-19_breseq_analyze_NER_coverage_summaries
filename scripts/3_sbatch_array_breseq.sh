#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=breseq_array
#SBATCH --time=04:00:00
#SBATCH --array=1-9%10
#SBATCH --cpus-per-task=1
#SBATCH --mem=100G
#SBATCH --output=/work/geisingerlab/Mark/breseq/2024-12-19_breseq_analyze_NER_coverage_summaries/logs/%x_%A_%a.out
#SBATCH --error=/work/geisingerlab/Mark/breseq/2024-12-19_breseq_analyze_NER_coverage_summaries/logs/%x_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=soo.m@northeastern.edu

source ./config.cfg

echo "Starting breseq SBATCH script $(date)"

echo "Loading environment and tools"
module load anaconda3/2021.05
eval "$(conda shell.bash hook)"
conda activate /work/geisingerlab/conda_env/breseq_env

echo "Reference genome files: " $REFERENCE_CHR $REFERENCE_PAB1 $REFERENCE_PAB2 $REFERENCE_PAB3
echo "Sample sheet: " $SAMPLE_SHEET
echo "Breseq output saved to: " $BRESEQ_OUTPATH

mkdir -p $BRESEQ_OUTPATH

# Run breseq
# -r options specify reference genome(s)
# Pass fastq files as positional arguments after reference genome files

name=`sed -n "$SLURM_ARRAY_TASK_ID"p $SAMPLE_SHEET |  awk '{print $1}'`
r1=`sed -n "$SLURM_ARRAY_TASK_ID"p $SAMPLE_SHEET |  awk '{print $2}'`
r2=`sed -n "$SLURM_ARRAY_TASK_ID"p $SAMPLE_SHEET |  awk '{print $3}'`

echo "Running breseq on files $r1 and $r2"
breseq -r ${REFERENCE_CHR} -r ${REFERENCE_PAB1} -r ${REFERENCE_PAB2} -r ${REFERENCE_PAB3} -o ${BRESEQ_OUTPATH}/${name} ${r1} ${r2}

echo "breseq script complete $(date)"
