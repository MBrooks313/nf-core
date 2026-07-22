#! /bin/bash
#SBATCH --job-name=nf-hic
#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --gres=lscratch:200
#SBATCH --time=3-00:00:00

module load nextflow/25.04.2
export NXF_SINGULARITY_CACHEDIR=/data/$USER/nxf_singularity_cache;
export SINGULARITY_CACHEDIR=/data/$USER/.singularity;
export TMPDIR=/lscratch/$SLURM_JOB_ID
export NXF_JVM_ARGS="-Xms2g -Xmx4g"
export MPLCONFIGDIR=/lscratch/$SLURM_JOB_ID/matplotlib
mkdir -p "$MPLCONFIGDIR"

nextflow run nf-core/hic -r 2.1.0 \
-profile biowulf \
-c resource_overrides.config \
--input samplesheet_260715.csv \
--outdir ../output_260715 \
--gtf /data/brooksma/Index/Human/Gencode/v50/gencode.v50.basic.annotation.gtf.gz \
--fasta /data/brooksma/Index/Human/Gencode/v50/GRCh38.primary_assembly.genome.fa \
--igenomes_ignore --genome null \
--digestion arima \
-resume
