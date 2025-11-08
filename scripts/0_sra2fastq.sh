#!/bin/bash

#SBATCH --job-name=sra2fastq
#SBATCH --output=logs/sra_to_fastq_%A_%a.out
#SBATCH --error=logs/sra_to_fastq_%A_%a.err
#SBATCH --time=10:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --array=1-24

module load sratoolkit

SRA_DIR="$SCRATCH/rawdata"
SRA_FILES=($(find "$SRA_DIR" -name "*.sra"))
OUT_DIR="$SCRATCH/rawdata/fastq"

mkdir -p $OUTDIR

CURRENT_SRA_FILE="${SRA_FILES[$SLURM_ARRAY_TASK_ID-1]}"

echo "Processing SRA File: $CURRENT_SRA_FILE"

fasterq-dump "$CURRENT_SRA_FILE" \
    --progress \
    -e "$SLURM_CPUS_PER_TASK" \
    --split-files
    -O $OUTDIR

echo "Finished for SRA File $CURRENT_SRA_FILE"
