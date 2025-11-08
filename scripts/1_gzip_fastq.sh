#!/bin/bash

#SBATCH --job-name=gzip_fastq
#SBATCH --output=logs/gzip_fastq_%A_%a.out
#SBATCH --error=logs/gzip_fastq_%A_%a.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=4G

FILES_TO_ZIP=($(find . -maxdepth 1 -name "*.fastq"))
CURRENT_FILE="${FILES_TO_ZIP[$SLURM_ARRAY_TASK_ID-1]}"

echo "STARTING: Compressing file: $CURRENT_FILE"
gzip "$CURRENT_FILE"
echo "FINISHED: Successfully compressed $CURRENT_FILE.gz"
