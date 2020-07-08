# Run this script from command line in case it takes a while:
# screen -S download_hum_archs4 R -f archs4_download_human_mx.R

setwd("~/_Data/IRF8/TB_Project_4/meta_analysis/source_data/rna_seq/archs4")

destination_file = "archs4_human_matrix_2020_07_03.h5"

if(!file.exists(destination_file)){
  print("Downloading compressed gene expression matrix.")
  url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix.h5"
  download.file(url, destination_file, quiet = FALSE)
} else{
  print("Local file already exists.")
}
