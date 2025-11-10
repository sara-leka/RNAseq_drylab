suppressPackageStartupMessages({
  library(tidyverse)
  library(dplyr)
  library(biomaRt)
})

# Loading data and getting TPM and count matrices

output_tpm_file = "final_tpm_matrix.csv"
output_counts_file = "final_counts_matrix.csv"

samples = list.files("rsem")

tpm_matrix = sapply(samples, function(sample){
  file = paste0("rsem/",sample,"/",sample,".genes.results")
  quant = read.csv(file, sep="\t", header=T)
  tpm = setNames(quant$TPM, quant$gene_id)
  return(tpm)
})
tpm_matrix = as.data.frame(tpm_matrix) %>% rownames_to_column(var = "gene_id")
write.csv(tpm_matrix, output_tpm_file, row.names = FALSE)

count_matrix = sapply(samples, function(sample){
  file = paste0("rsem/",sample,"/",sample,".genes.results")
  quant = read.csv(file, sep="\t", header=T)
  tpm = setNames(quant$expected_count, quant$gene_id)
  return(tpm)
})
count_matrix = as.data.frame(count_matrix) %>% rownames_to_column(var = "gene_id")
write.csv(count_matrix, output_counts_file, row.names = FALSE)
