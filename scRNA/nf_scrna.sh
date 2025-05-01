#! /bin/bash
#SBATCH --job-name=nf-scrna
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --gres=lscratch:200
#SBATCH --time=72:00:00

module load nextflow
export NXF_SINGULARITY_CACHEDIR=/data/$USER/nxf_singularity_cache;
export SINGULARITY_CACHEDIR=/data/$USER/.singularity;
export TMPDIR=/lscratch/$SLURM_JOB_ID
export NXF_JVM_ARGS="-Xms2g -Xmx16g"
NOW=$(date +"%Y%m%d")
wd="path/to/working_dir"

nextflow run nf-core/scrnaseq -r 4.0.0 \
-profile biowulf \
--input samplesheet.csv \
--outdir ${wd}/output_${NOW} \
--aligner cellranger \
--cellranger_index /fdb/cellranger/refdata-gex-mm10-2020-A \
--genome mm10 \
-resume

