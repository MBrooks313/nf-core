# nf-core

This repo houses the scripts needed to run nf-core modules on the Biowulf HPC.

[ATACseq pipeline](https://nf-co.re/atacseq/2.1.2/)
* Also used for SE sequencing ChIPseq

[ChIPseq pipeline](https://nf-co.re/chipseq/2.1.0/)
* Only used for PE sequencing

[CUT&TAG/CUT&Tag pipeline](https://nf-co.re/cutandrun/3.2.2/)

[RNAseq pipeline](https://nf-co.re/rnaseq/3.16.0/)

[scRNAseq pipeline](https://nf-co.re/scrnaseq/4.0.0/)

[Hi-C pipeline](https://nf-co.re/hic/2.1.0/)
* Bug in COOLTOOL_INSULATION version reporting: after run fials at CUSTOM_DUMPSOFTWAREVERSIONS step, run repair_cooltools_version.sh, then restart sbatch -resume.
* Bug has already been reported to the nf-core/hic GitHub page 



