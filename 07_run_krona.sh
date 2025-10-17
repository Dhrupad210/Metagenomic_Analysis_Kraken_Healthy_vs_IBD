# File: 07_run_krona.sh


# --- Generate Krona chart for the Crohn's sample ---
ktImportTaxonomy -o SRR5983442_krona.html SRR5983442_kraken_report.txt

# --- Generate Krona chart for the Healthy sample ---
ktImportTaxonomy -o SRR5983443_krona.html SRR5983443_kraken_report.txt
