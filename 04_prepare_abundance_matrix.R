# File: 04_prepare_abundance_matrix.R

# --- Load libraries ---
library(dplyr)
library(tidyr)

# --- Read in Bracken data ---
sample1_df <- read.table("SRR5983442_bracken_species.txt", header = TRUE, sep = "\t")
sample2_df <- read.table("SRR5983443_bracken_species.txt", header = TRUE, sep = "\t")

# --- Clean and merge data ---
s1_counts <- sample1_df %>%
  select(name, new_est_reads) %>%
  rename(SRR5983442 = new_est_reads)

s2_counts <- sample2_df %>%
  select(name, new_est_reads) %>%
  rename(SRR5983443 = new_est_reads)

# Merge into a single matrix, keeping all species from both samples
abundance_matrix <- full_join(s1_counts, s2_counts, by = "name") %>%
  # Replace NA (species not found in a sample) with 0
  replace_na(list(SRR5983442 = 0, SRR5983443 = 0)) %>%
  # Set species names as row names
  tibble::column_to_rownames(var = "name")

# --- Save the final matrix for later use ---
write.csv(abundance_matrix, "abundance_matrix.csv")

print("Abundance matrix created and saved as abundance_matrix.csv")
