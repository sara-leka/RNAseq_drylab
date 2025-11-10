#!/bin/bash

#SBATCH --job-name=trim
#SBATCH --output=logs/trim_%A_%a.out
#SBATCH --error=logs/trim_%A_%a.err
#SBATCH --time=10:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8G

ADAPTER_NEXTERA="CTGTCTCTTATACACATCT"
ADAPTER_TSO="GTACATGGGAAGCAGTGGTATCAACGCAGAGTACATGGGAAGCAGTGGTA"
ADAPTER_TSO_REV="CCCATGTACTCTGCGTTGATACCACTGCTTCCCATGTACTCTGCGTTGAT"
QUALITY_CUTOFF=20
MIN_LENGTH=25

RAW_DIR="$SCRATCH/rawdata/1_fastq"
TRIM_DIR="$SCRATCH/rawdata/2_trimmed_fastq_CORRECTED"

mkdir -p $TRIM_DIR

for file in $RAW_DIR/*.fastq.gz
do
    base=$(basename "$file" .fastq.gz)
    output_file="$TRIM_DIR/${base}.trimmed.fastq.gz"

    cutadapt \
        -a $ADAPTER_NEXTERA \
        -a $ADAPTER_TSO \
	-a $ADAPTER_TSO_REV \
        --poly-a \
        -m $MIN_LENGTH \
        -o "$output_file" \
        "$file"
done

