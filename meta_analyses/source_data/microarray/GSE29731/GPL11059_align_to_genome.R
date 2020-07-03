################################################################################
# 29-June-20
################################################################################
# OBJECTIVE ####
################################################################################
# Align sequences from GPL11059 microarray platform to mouse genome and obtain
# gene info.

################################################################################
# WHY? ####
################################################################################
# The platform info provides genbank accession numbers, and many of these
# are now impossible to find in current ID mapping databases
# (biomart, bioconductor)
# Because the GPL11059 info file inlcudes the sequence of ech probe, it should
# be possible to find the matching gene for each probe based on the latest
# data.

################################################################################
# HOW? ####
################################################################################
# rsubread package / align() function

# package.version("Rsubread") # "1.32.4"
# BiocManager::install("Rsubread")
package.version("Rsubread") # "1.32.4"

# help(align, package="Rsubread")

#-------------------------------------------------------------------------------
# Packages
#-------------------------------------------------------------------------------
library(magrittr)
library(dplyr)
library(stringr)
library(Rsubread)

rm(list=ls(all=TRUE))
(this.script <- rstudioapi::getActiveDocumentContext() %>% .$path %>% basename)

#-------------------------------------------------------------------------------
# Load GPL11059 file and save sequences in suitable format
#-------------------------------------------------------------------------------
# (suitable for Rsubread)
# data.dir <- ("~/_Data/IRF8/Diana/TB_PROJECT_Diana/geo.datasets/GSE29731")
gpl <- read.table(file="GPL11059.txt", sep="\t", comment.char = "#", header=T,
                  quote="")
names(gpl) <- stringr::str_remove(names(gpl), "\\.+$") %>%
  stringr::str_remove("^X\\.")
names(gpl)

fasta <- gpl %>%
  mutate(fasta = paste0(">", ID, "\n", SEQUENCE)) %>%
  use_series(fasta)
class(fasta)  # "character"
head(fasta)

out.file.fasta <- "GPL11059_seq_fasta_2020_06_30.txt"
cat("#", this.script, "\n", file=out.file.fasta, append=F)
cat("#", as.character(Sys.time()), "\n", file=out.file.fasta, append=T)
cat("# Input file: GPL11059.txt", "\n", file=out.file.fasta, append=T)
cat(fasta, sep="\n", file=out.file.fasta, append=T)

#-------------------------------------------------------------------------------
# Align to mouse genome
#-------------------------------------------------------------------------------
align.results <- Rsubread::align()
