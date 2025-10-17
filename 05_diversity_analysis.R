# File: 05_diversity_analysis.R

# --- Load libraries ---
library(vegan)
library(ggplot2)

# --- Load data ---
abundance_matrix <- read.csv("abundance_matrix.csv", row.names = 1)
metadata <- read.csv("metadata.csv")

# --- Alpha Diversity ---
# Transpose matrix so samples are rows
abundance_matrix_t <- t(abundance_matrix)

alpha_diversity <- data.frame(
  shannon = diversity(abundance_matrix_t, index = "shannon"),
  richness = specnumber(abundance_matrix_t),
  SampleID = rownames(abundance_matrix_t)
)
alpha_diversity <- merge(alpha_diversity, metadata, by = "SampleID")

# Plot Shannon Diversity
shannon_plot <- ggplot(alpha_diversity, aes(x = Group, y = shannon, fill = Group)) +
  geom_boxplot(width = 0.5) +
  geom_point(size = 4) +
  labs(title = "Alpha Diversity (Shannon Index)", y = "Shannon Index") +
  theme_minimal() +
  theme(legend.position = "none")

print(shannon_plot)

# --- Beta Diversity ---
# Calculate Bray-Curtis dissimilarity
bray_dist <- vegdist(abundance_matrix_t, method = "bray")

# Perform Principal Coordinate Analysis (PCoA)
pcoa <- cmdscale(bray_dist, k = 1, eig = TRUE)
pcoa_df <- as.data.frame(pcoa$points)
colnames(pcoa_df) <- "PCoA1"
pcoa_df$SampleID <- rownames(pcoa_df)
pcoa_df <- merge(pcoa_df, metadata, by = "SampleID")

# Plot PCoA
pcoa_plot <- ggplot(pcoa_df, aes(x = PCoA1, y = 0, color = Group, shape = Group)) +
  geom_point(size = 7, alpha = 0.8) +
  labs(title = "Beta Diversity (PCoA of Bray-Curtis)", x = "PCoA Axis 1", y = "") +
  theme_classic() +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())

print(pcoa_plot)

# Statistical test (PERMANOVA)
permanova_result <- adonis2(bray_dist ~ Group, data = metadata)
print("PERMANOVA Results:")
print(permanova_result)
