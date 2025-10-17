# File: 03_run_bracken.sh
# Note: Run these commands for both samples (SRR5983442 and SRR5983443)

# --- Define Sample ID (change this for the other sample) ---
SAMPLE_ID="SRR5983442" 

# --- Estimate Species Abundance ---
~/mgenome/Bracken-3.1/bracken \
  -d ~/mgenome/minikraken_20171013_4GB \
  -i ${SAMPLE_ID}_kraken_report.txt \
  -o ${SAMPLE_ID}_bracken_species.txt \
  -l S \
  -r 100

# --- Estimate Genus Abundance ---
~/mgenome/Bracken-3.1/bracken \
  -d ~/mgenome/minikraken_20171013_4GB \
  -i ${SAMPLE_ID}_kraken_report.txt \
  -o ${SAMPLE_ID}_bracken_genus.txt \
  -l G \
  -r 100

# --- Estimate Phylum Abundance ---
~/mgenome/Bracken-3.1/bracken \
  -d ~/mgenome/minikraken_20171013_4GB \
  -i ${SAMPLE_ID}_kraken_report.txt \
  -o ${SAMPLE_ID}_bracken_phylum.txt \
  -l P \
  -r 100
