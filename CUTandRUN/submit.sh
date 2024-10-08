#!/bin/bash
## Run nfcore cut and run with the following commands
## sinteractive --mem=120g -c12 --gres=lscratch:500 -t 1-8
## module load nextflow
## Check the paramteers in nfcore_cutandrun_settings.json to ensure they are correct
## Run with sbatch --cpus-per-task=24 --mem=100g --time=3-0 --cpus-per-task=24 submit.sh

path_blklst=/data/brooksma/Index/Blacklists/v2/mm10-blacklist.v2_ncbi.bed.gz

nextflow run nf-core/cutandrun \
	-r 3.1 \
	--input samplesheet.csv \
	--outdir output \
	-params-file nfcore_cutandrun_settings.json \
	--genome GRCm38 \
	--blacklist $path_blklst \
	-profile biowulflocal  \
	--peakcaller MACS2,SEACR \
	--normalisation_mode CPM \
	--normalisation_binsize 10 \
	--use_control false \
	-resume

