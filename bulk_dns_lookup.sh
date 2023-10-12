#!/bin/bash

# Prompt the user for DNS Nameservers
echo "Enter the DNS Nameservers (comma-separated):"
read nameservers

# Prompt the user for the input method
echo "Choose an option:"
echo "1. Enter domain names manually"
echo "2. Provide a list of domain names in a text file"
read option

if [ $option -eq 1 ]; then
    # Prompt the user for domain names
    echo "Enter domain names, one per line (Press Ctrl+D to finish input):"
    domains=()
    while read -r domain; do
        domains+=("$domain")
    done
else
    # Prompt the user for a text file with domain names
    echo "Enter the path to the text file containing domain names:"
    read domain_file
    domains=($(cat "$domain_file"))
fi

# Create output files for results
csv_file="dns_results.csv"
txt_file="dns_results.txt"

# Loop through the domain names and perform DNS lookup
for domain in "${domains[@]}"; do
    echo "Looking up DNS for: $domain"
    results=$(dig @$nameservers +short +stats +answer "$domain")

    # Write results to CSV file
    echo "$domain,$results" >> "$csv_file"

    # Write results with explanations to TXT file
    echo "DNS lookup for: $domain" >> "$txt_file"
    echo "$results" >> "$txt_file"
    echo "------------------------------------" >> "$txt_file"

    # Wait for 1 second before the next lookup
    sleep 1
done

echo "DNS lookups completed. Results saved to $csv_file and $txt_file."
