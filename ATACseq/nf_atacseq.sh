#! /bin/bash
#SBATCH --job-name=nextflow-main
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --gres=lscratch:200
#SBATCH --time=72:00:00

module load nextflow
export NXF_SINGULARITY_CACHEDIR=/data/$USER/nxf_singularity_cache;
export SINGULARITY_CACHEDIR=/data/$USER/.singularity;
export TMPDIR=/lscratch/$SLURM_JOB_ID
export NXF_JVM_ARGS="-Xms2g -Xmx16g"

path_gtf=/data/brooksma/Index/Human/ENS/v111/Homo_sapiens.GRCh38.111.gtf.gz
path_fa=/data/brooksma/Index/Human/ENS/v111/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz
path_blklst=/data/brooksma/Index/Blacklists/v2/hg38-blacklist.v2_ncbi.bed.gz

nextflow run nf-core/atacseq -r 2.1.2 \
-profile biowulf \
--input samplesheet.csv \
--outdir output \
--gtf $path_gtf \
--fasta $path_fa \
--igenomes_ignore --genome null \
--read_length 100 \
--blacklist $path_blklst \
--save_reference \
--keep_dups false \
-resume

