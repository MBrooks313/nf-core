#! /bin/bash
#SBATCH --job-name=nextflow-main
#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --gres=lscratch:200
#SBATCH --time=24:00:00

module load nextflow
export NXF_SINGULARITY_CACHEDIR=/data/$USER/nxf_singularity_cache;
export SINGULARITY_CACHEDIR=/data/$USER/.singularity;
export TMPDIR=/lscratch/$SLURM_JOB_ID
export NXF_JVM_ARGS="-Xms2g -Xmx4g"

path_gtf=/fdb/igenomes_nf/Mus_musculus/Ensembl/pub/release-110/gtf/Mus_musculus.GRCm39.110.gtf
path_fa=/fdb/igenomes_nf/Mus_musculus/Ensembl/pub/release-110/fasta/dna/Mus_musculus.GRCm39.dna.primary_assembly.fa
seq_length=50

nextflow run nf-core/chipseq -r 2.0.0 \
-profile biowulf \
--input samplesheet.csv \
--outdir output \
--gtf $path_gft \
--fasta $path_fa \
--igenomes_ignore --genome null \
--read_length $seq_length \
-resume
