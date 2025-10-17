# File: 06_composition_pie_charts.R

# --- Load libraries ---
library(dplyr)
library(ggplot2)
library(patchwork) # To combine plots
library(ggrepel)   # For clean labels

# --- Load and prepare data ---
abundance_matrix <- read.csv("abundance_matrix.csv", row.names = 1)
abundance_matrix$species_name <- rownames(abundance_matrix)

# Aggregate counts by genus
genus_abundance <- abundance_matrix %>%
  group_by(genus = sapply(strsplit(species_name, " "), `[`, 1)) %>%
  summarise(SRR5983442 = sum(SRR5983442), # Crohn's
            SRR5983443 = sum(SRR5983443)) # Healthy

# --- Prepare data & Plot for Crohn's Sample ---
s1_data <- genus_abundance %>%
  select(genus, SRR5983442) %>%
  arrange(desc(SRR5983442)) %>%
  mutate(genus_plot = ifelse(row_number() <= 6, genus, "Other")) %>%
  group_by(genus_plot) %>%
  summarise(counts = sum(SRR5983442)) %>%
  mutate(percentage = counts / sum(counts) * 100,
         label = paste0(genus_plot, "\n(", round(percentage, 1), "%)"))

p1 <- ggplot(s1_data, aes(x = "", y = percentage, fill = genus_plot)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  theme_void() +
  geom_label_repel(aes(label = label), size = 3.5, show.legend = FALSE, nudge_x = 1) +
  labs(title = "Crohn's Disease Sample") +
  theme(plot.title = element_text(hjust = 0.5, size = 14))

# --- Prepare data & Plot for Healthy Sample ---
s2_data <- genus_abundance %>%
  select(genus, SRR5983443) %>%
  arrange(desc(SRR5983443)) %>%
  mutate(genus_plot = ifelse(row_number() <= 6, genus, "Other")) %>%
  group_by(genus_plot) %>%
  summarise(counts = sum(SRR5983443)) %>%
  mutate(percentage = counts / sum(counts) * 100,
         label = paste0(genus_plot, "\n(", round(percentage, 1), "%)"))

p2 <- ggplot(s2_data, aes(x = "", y = percentage, fill = genus_plot)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  theme_void() +
  geom_label_repel(aes(label = label), size = 3.5, show.legend = FALSE, nudge_x = 1) +
  labs(title = "Healthy Sample") +
  theme(plot.title = element_text(hjust = 0.5, size = 14))

# --- Display plots side-by-side ---
p1 + p2
