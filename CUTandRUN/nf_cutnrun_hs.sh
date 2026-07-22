#!/bin/bash
#SBATCH --job-name=cutandrun_nfcore
#SBATCH --cpus-per-task=4          # only for the Nextflow manager
#SBATCH --mem=8g                   # only for the Nextflow manager
#SBATCH --time=2-00:00:00
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

# Load modules
module load nextflow/25.04.2
#module load singularity  # if not auto-loaded on your system

# Create log dir if it doesn't exist
mkdir -p logs

export NXF_SINGULARITY_CACHEDIR=/data/$USER/nxf_singularity_cache;
export SINGULARITY_CACHEDIR=/data/$USER/.singularity;
#export TMPDIR=/lscratch/$SLURM_JOB_ID
#export NXF_JVM_ARGS="-Xms2g -Xmx4g"


# Run nf-core/cutandrun with SLURM-based profile
nextflow run nf-core/cutandrun \
    -r 3.2.2 \
    --input samplesheet_cutandrun.csv \
    --outdir output_260508 \
    --genome GRCh38 \
    --blacklist /data/brooksma/Index/Blacklists/v2/hg38-blacklist.v2_ncbi.bed.gz \
    -profile biowulf \
    --peakcaller MACS2,SEACR \
    --normalisation_mode CPM \
    --normalisation_binsize 10 \
    --use_control false \
    -c extra.config \
    -resume
