# File: 01_quality_control.sh

# --- Create output directory ---
mkdir -p fastp_out

# --- Process Crohn's Disease Sample (SRR5983442) ---
fastp \
  -i SRR5983442.fastq.gz -I SRR5983442.fastq.gz \
  -o fastp_out/SRR5983442_1.trimmed.fastq.gz -O fastp_out/SRR5983442_2.trimmed.fastq.gz \
  -w 4 \
  -h fastp_out/SRR5983442_fastp.html \
  -j fastp_out/SRR5983442_fastp.json

# --- Process Healthy Sample (SRR5983443) ---
fastp \
  -i SRR5983443.fastq.gz -I SRR5983443.fastq.gz \
  -o fastp_out/SRR5983443_1.trimmed.fastq.gz -O fastp_out/SRR5983443_2.trimmed.fastq.gz \
  -w 4 \
  -h fastp_out/SRR5983443_fastp.html \
  -j fastp_out/SRR5983443_fastp.json
