#! /bin/bash
#SBATCH --job-name=nf-main
#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --gres=lscratch:200
#SBATCH --time=3-00:00:00

module load nextflow
export NXF_SINGULARITY_CACHEDIR=/data/$USER/nxf_singularity_cache;
export SINGULARITY_CACHEDIR=/data/$USER/.singularity;
export TMPDIR=/lscratch/$SLURM_JOB_ID
export NXF_JVM_ARGS="-Xms2g -Xmx4g"

path_gtf=/<fullPath>/Index/Human/ENS/v111/Homo_sapiens.GRCh38.111.gtf.gz
path_fa=/<fullPath>/Index/Human/ENS/v111/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz


nextflow run nf-core/rnaseq -r 3.14.0 \
-profile biowulf \
--input samplesheet.csv \
--outdir output \
--gtf $path_gtf \
--fasta $path_fa \
--igenomes_ignore --genome null \
--pseudo_aligner kallisto \
--aligner star_rsem \
--extra_star_align_args "--alignIntronMax 1000000 --alignIntronMin 20 --alignMatesGapMax 1000000 --alignSJoverhangMin 8 --outFilterMismatchNmax 999 --outFilterMultimapNmax 20 --outFilterType BySJout --outFilterMismatchNoverLmax 0.1 --clip3pAdapterSeq AAAAAAAA" \
--save_reference
