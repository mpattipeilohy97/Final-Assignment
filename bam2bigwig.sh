#!/usr/bin/env bash
# Final Assignment

input_dir=$1
output_dir=$2

mkdir -p "$output_dir"

if [ ! -d "$input_dir" ]; then
	echo "'input_dir' not found."
fi

log_file="$output_dir/log.txt"

source $(dirname $(dirname $(which mamba)))/etc/profile.d/conda.sh
conda create -n "bam2bigwig" deeptools samtools --yes &>> $log_file
conda activate bam2bigwig


for bam_file in "$input_dir"/*.bam; do
    if [ -e "$bam_file" ]; then
        # Index the BAM file

        nice samtools index $bam_file &>> $log_file
    fi
done

for indexed_bam_file in "$input_dir"/*.bam; do
    if [ -e "${indexed_bam_file}.bai" ]; then
        file_name=$(basename "$indexed_bam_file" .bam)

        nice bamCoverage --bam "$indexed_bam_file" -o "$output_dir/$file_name.bw" &>> "$log_file"
    fi
done

echo "mpattipeilohy"
