# Comparative Gut Metagenome Analysis: Crohn's Disease vs. Healthy Control

This repository contains the complete bioinformatics workflow for a comparative analysis of two gut microbiome samples from the Human Microbiome Project 2 (HMP2), focusing on identifying differences in taxonomic composition and diversity between a patient with Crohn's Disease and a healthy individual.

---

## 🔬 Project Overview

The goal of this project is to process raw metagenomic sequencing data to:
1.  **Assess and improve** the quality of the raw sequencing reads.
2.  **Perform taxonomic classification** to identify the microbial species present in each sample.
3.  **Estimate the relative abundance** of these species.
4.  **Analyze and compare** the microbial diversity (alpha and beta diversity) between the two conditions.
5.  **Visualize** the results in a clear and interpretable manner.

---

## 🧬 Data Source

The raw sequencing data used in this analysis originates from the **Human Microbiome Project 2 (HMP2)**. The overall study design involved sequencing the total genomic DNA content of fecal samples to infer the functional potential and taxonomic composition of the gut microbial community.

-   **Parent Study**: HMP2 Inflammatory Bowel Disease Multi-omics Database (IBDMDB)
-   **Sequencing Platform**: Illumina HiSeq 2000 (2x100 bp paired-end reads)

The broader HMP2 study generated 4.59 G-nucleotides across 300 samples from 117 participants. On average, metagenomes contained 30.6 million reads per sample before quality filtering and 28.2 million reads afterward.

The two specific samples used in this workflow are:

| SRA Run ID    | Condition           | HMP2 Subject ID |
| :----------   | :----------------   | :-------------- |
| `SRR5983442`  | **Crohn's Disease** | `C3013`         |
| `SRR5983443`  | **Healthy Control** | `H4020`         |

---

## 🚀 Analysis Workflow

The analysis is broken down into a series of sequential steps, from raw reads to final plots.

### **1. Quality Control (`fastp`)**

Raw `.fastq.gz` files were processed using `fastp` to remove adapters, filter out low-quality reads, and generate a quality report for each sample.
Healthy Sample: https://trace.ncbi.nlm.nih.gov/Traces?run=SRR5983443
IBD Sample: https://trace.ncbi.nlm.nih.gov/Traces?run=SRR5983442

```bash
fastp -i SRR5983442.fastq.gz -o fastp_out/SRR5983442_1.trimmed.fastq.gz ...
```

### **2. Taxonomic Classification (`Kraken`)**

The quality-controlled reads were classified using **Kraken**, a k-mer-based tool that assigns taxonomic labels to sequences by matching them against a pre-built database (MiniKraken 4GB).

```bash
kraken --db ~/mgenome/minikraken_20171013_4GB --paired SRR5983442_1.trimmed.fastq ...
```

### **3. Abundance Estimation (`Bracken`)**

**Bracken** (Bayesian Reestimation of Abundance with KrakEN) was used to re-estimate species abundances from the Kraken report. This provides more accurate abundance estimates at specific taxonomic levels (Species, Genus, etc.).

```bash
bracken -d ~/mgenome/minikraken_20171013_4GB -i SRR5983442_kraken_report.txt -l S ...
```

### **4. Statistical Analysis & Visualization (`R`)**

All downstream analysis was performed in R. The key steps included:
-   **Data Preparation**: Merging the Bracken outputs into a single abundance matrix.
-   **Alpha Diversity**: Calculating the within-sample diversity using the Shannon Index.
-   **Beta Diversity**: Comparing the community composition between samples using Bray-Curtis dissimilarity and visualizing with Principal Coordinate Analysis (PCoA).
-   **Taxonomic Composition**: Generating pie charts to show the relative abundance of the top genera in each sample.

### **5. Interactive Visualization (`Krona`)**

Finally, Krona was used to generate interactive HTML plots, allowing for a detailed, multi-layered exploration of the taxonomic hierarchy of each sample.

```bash
ktImportTaxonomy -o SRR5983442_krona.html SRR5983442_kraken_report.txt
```

---

📊 In-Depth Biological Interpretation of Metagenomic Findings
This document provides a detailed analysis of the microbial community structures derived from two gut metagenome samples: one from a patient with Crohn's Disease (SRR5983442) and one from a healthy control subject (SRR5983443). The results clearly illustrate a profound state of microbial dysbiosis in the Crohn's disease sample, characterized by a catastrophic loss of diversity and the dominance of a single opportunistic genus.

## 1. Executive Summary: A Tale of Two Gut Ecosystems
The comparison between the two samples reveals a stark contrast. The healthy gut microbiome resembles a balanced, diverse ecosystem, rich with various beneficial species performing essential functions. In sharp contrast, the Crohn's disease gut microbiome appears to have collapsed into a low-diversity state, dominated by a single genus, which is a classic microbial signature of Inflammatory Bowel Disease (IBD). This dysbiosis is not merely a compositional shift but implies a significant loss of crucial metabolic functions and a potential increase in pro-inflammatory activity.

## 2. Finding 1: Catastrophic Collapse of Microbial Diversity and Evenness
The most immediate and dramatic finding is the severe reduction in microbial diversity in the Crohn's disease sample. A healthy gut ecosystem is defined not just by the presence of many species (richness) but also by their relatively even distribution (evenness).

Crohn's Disease Sample (SRR5983442): This sample exhibits a near-complete loss of evenness. The microbial community is overwhelmingly dominated by the genus Burkholderia, which constitutes an astonishing 81.2% of the total classified reads. Other key gut genera like Bacteroides (9.9%) and Intestinimonas (2.2%) are relegated to minor roles. Such extreme dominance by a single taxon is indicative of a highly disturbed and unstable environment where ecological checks and balances have failed.

Healthy Control Sample (SRR5983443): While Burkholderia is also the most abundant genus in the healthy sample, its dominance is far less pronounced at 61.6%. Critically, other cornerstone genera of a healthy gut are present in significant proportions, including Bacteroides (18.5%) and, most notably, Bifidobacterium (8.5%). This more balanced distribution signifies a resilient and functionally robust microbial community.

Analogy: The healthy gut is like a thriving rainforest with a wide variety of plants and animals coexisting. The Crohn's gut, in this case, is like a field that has been overtaken by a single invasive weed, choking out all other life.

## 3. Finding 2: Depletion of Keystone Beneficial Genera and Their Functions
Beyond the overall diversity collapse, the specific identities of the depleted microbes in the Crohn's sample are critically important. The analysis shows a marked reduction or absence of bacteria known for their vital, symbiotic roles in maintaining gut health.

Loss of Butyrate Producers: The healthy sample contains robust populations of Bifidobacterium (8.5%) and Anaerostipes (2.7%). These genera are renowned for their ability to ferment dietary fibers into short-chain fatty acids (SCFAs), with butyrate being the most important. Butyrate is a powerhouse molecule for gut health:

It is the primary energy source for the cells lining the colon (colonocytes).

It reinforces the gut barrier, preventing "leaky gut."

It has potent anti-inflammatory properties, helping to regulate the host immune system. The near-absence of these butyrate factories in the Crohn's sample implies a critical functional deficit, likely contributing to mucosal inflammation and impaired barrier function.

Reduction in Core Commensals: The abundance of Bacteroides is nearly halved in the Crohn's sample (9.9%) compared to the healthy control (18.5%). Bacteroides is a cornerstone genus of the human gut microbiome, essential for degrading complex plant polysaccharides that are otherwise indigestible by the host. Their reduction points to a diminished capacity for energy extraction from the diet.

## 4. Finding 3: The Opportunistic Bloom of Burkholderia
The massive expansion of Burkholderia from 61.6% in the healthy gut to 81.2% in the Crohn's gut is a significant red flag.

Opportunistic Nature: The genus Burkholderia includes a wide range of species, some of which are known opportunistic pathogens. These are microbes that are typically harmless in a balanced ecosystem but can cause disease when the host's defenses are compromised or when the microbial community is disrupted—conditions that are both present in Crohn's disease.

A Pro-Inflammatory Environment: The inflammatory environment of the IBD gut can paradoxically favor the growth of certain hardy, inflammation-tolerant bacteria. It is plausible that the chronic inflammation in the patient's gut created a selective pressure that allowed Burkholderia to outcompete beneficial commensal bacteria, leading to the observed bloom. This creates a dangerous feedback loop: inflammation allows the opportunist to thrive, and the opportunist's presence may further provoke the immune system, perpetuating the inflammation.

## 5. Synthesis and Clinical Implications
The combined evidence paints a clear picture of the microbial landscape in this Crohn's disease patient. The gut has transitioned from a diverse, symbiotic community (eubiosis) to a pathologically altered state (dysbiosis) characterized by:

Functional Impairment: Loss of SCFA production, leading to energy starvation of the gut lining and a weakened anti-inflammatory response.

Loss of Resilience: A low-diversity community is inherently unstable and less able to resist perturbations from diet, medication, or invading pathogens.

Increased Inflammatory Potential: The dominance of an opportunistic genus like Burkholderia may directly contribute to the chronic immune activation that defines Crohn's disease.

---

## ⚙️ How to Reproduce this Analysis

### **1. Clone the Repository**
```bash
git clone https://github.com/Dhrupad210/Metagenomic_Analysis_Kraken_Healthy_vs_IBD
cd crohns_metagenome_study
```

### **2. Set Up the Environment**
It is highly recommended to use Conda to manage the software dependencies.
```bash
# Create the environment from the provided file
conda env create -f environment.yml

# Activate the environment
conda activate metagenome_env
```

### **3. Download Data**
-   Place the raw `.fastq.gz` files (`SRR5983442.fastq.gz` and `SRR5983443.fastq.gz`) into the `00_raw_data/` directory.
-   Ensure the MiniKraken database is downloaded and its path is correctly specified in the scripts.

### **4. Run the Workflow**
Execute the scripts in the specified order. The bash scripts will handle the command-line workflow, and the R scripts will perform the final analysis and generate plots.

---

## 📂 Project Directory Structure

```plaintext
.
├── 00_raw_data/
├── 01_quality_control/
├── 02_taxonomy/
├── 03_analysis/
│   ├── data/
│   │   ├── abundance_matrix.csv
│   │   └── metadata.csv
│   ├── results/
│   └── scripts/
├── 04_krona_reports/
├── environment.yml
└── README.md
```
