library(tidyverse)
library(dplyr)
library(biomaRt)

setwd("/Users/saraleka/Desktop/CBB/Systems\ Genomics/RNAseq_drylab")

samples <- list.files("rsem")
expr <- sapply(samples, function(sample){
  file <- paste0("rsem/",sample,"/",sample,".genes.results")
  quant <- read.csv(file, sep="\t", header=T)
  tpm <- setNames(quant$TPM, quant$gene_id)
  return(tpm)
})