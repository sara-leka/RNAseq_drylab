#!/bin/bash

RAWDATA_DIR="/cluster/scratch/saleka/rawdata"
GENOME_DIR="$RAWDATA_DIR/mm39_genome"
TRIM_DIR="$RAWDATA_DIR/2_trimmed_fastq"
SRA_DIR="$RAWDATA_DIR/0_sra"

STAR_INDEX="$GENOME_DIR/star-index"
GTF_FILE="$GENOME_DIR/mm39.ncbiRefSeq.gtf"
RSEM_REF_PATH="$GENOME_DIR/rsem_index/rsem_mm39"

MAP_DIR="$RAWDATA_DIR/mapping_transcriptome"
RSEM_DIR="$RAWDATA_DIR/rsem"

mkdir -p $MAP_DIR
mkdir -p $RSEM_DIR

CPUS_PER_JOB=10
MEM_PER_CPU="5G"
JOB_TIME="03:00:00"


for sra_file in $SRA_DIR/SRR*; do
  id=$(basename "$sra_file")
  TRIMMED_FILE="$TRIM_DIR/${id}.trimmed.fastq.gz"

  CMD="
    echo 'Job started for $id'
    mkdir -p $MAP_DIR/$id
    mkdir -p $RSEM_DIR/$id

    echo '  Mapping started...'
    STAR --genomeDir $STAR_INDEX \
         --runThreadN $CPUS_PER_JOB \
         --readFilesIn $TRIMMED_FILE \
         --readFilesCommand zcat \
         --sjdbGTFfile $GTF_FILE \
         --quantMode TranscriptomeSAM \
         --outSAMtype BAM SortedByCoordinate \
         --outFileNamePrefix \"$MAP_DIR/$id/\"
    echo '  Mapping done.'

    echo '  RSEM started...'
    rsem-calculate-expression --alignments \
                              -p $CPUS_PER_JOB \
                              \"$MAP_DIR/$id/Aligned.toTranscriptome.out.bam\" \
                              $RSEM_REF_PATH \
                              \"$RSEM_DIR/$id/$id\"
    echo '  RSEM done.'"
  sbatch --job-name="align_$id" \
         --ntasks=1 \
         --cpus-per-task=$CPUS_PER_JOB \
         --mem-per-cpu=$MEM_PER_CPU \
         --time=$JOB_TIME \
         --output="$MAP_DIR/${id}_%j.log" \
         --wrap="conda run -n sysgenomics bash -c \"$CMD\""

done


