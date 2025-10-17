# File: 02_run_kraken.sh

# --- Unzip trimmed files for Kraken ---
# Note: Newer Kraken versions can read .gz files directly, but this ensures compatibility.
gunzip -c fastp_out/SRR5983442_1.trimmed.fastq.gz > fastp_out/SRR5983442_1.trimmed.fastq
gunzip -c fastp_out/SRR5983442_2.trimmed.fastq.gz > fastp_out/SRR5983442_2.trimmed.fastq
gunzip -c fastp_out/SRR5983443_1.trimmed.fastq.gz > fastp_out/SRR5983443_1.trimmed.fastq
gunzip -c fastp_out/SRR5983443_2.trimmed.fastq.gz > fastp_out/SRR5983443_2.trimmed.fastq

# --- Classify Crohn's Sample (SRR5983442) ---
kraken --db ~/mgenome/minikraken_20171013_4GB \
  --paired fastp_out/SRR5983442_1.trimmed.fastq fastp_out/SRR5983442_2.trimmed.fastq \
  > SRR5983442_kraken_output.txt

# --- Classify Healthy Sample (SRR5983443) ---
kraken --db ~/mgenome/minikraken_20171013_4GB \
  --paired fastp_out/SRR5983443_1.trimmed.fastq fastp_out/SRR5983443_2.trimmed.fastq \
  > SRR5983443_kraken_output.txt

# --- Generate Kraken reports ---
kraken-report --db ~/mgenome/minikraken_20171013_4GB \
  SRR5983442_kraken_output.txt > SRR5983442_kraken_report.txt

kraken-report --db ~/mgenome/minikraken_20171013_4GB \
  SRR5983443_kraken_output.txt > SRR5983443_kraken_report.txt
