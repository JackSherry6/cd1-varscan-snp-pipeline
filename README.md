# Waxman Lab RNA-seq SNP Calling Pipeline for CD1 Mouse Reference Genome

This pipeline performs processing of RNA-seq data to identify unknown single nucleotide polymorphisms (SNPs), including alignment, quality control, read filtering, variant calling, and normalization. This pipelines supports both BU shared computing cluster and aws.

## Table of Contents
1. Features
2. Requirements
3. Installation
4. Usage
5. Configuration
6. Input and Output
7. Contributing
8. License

## Features
- Modular Nextflow pipeline with clearly separated steps:
  - Read preprocessing and quality control
  - Alignment to reference genome
  - Duplicate marking and filtering
  - SNP calling and variant filtering
  - Normalization and annotation
  - Supports BU HPC cluster execution.
- Docker/Singularity container support for reproducibility.
- Automatic logging and error handling.
- Scalable to large snRNA-seq datasets.

## Requirements
- Must have a conda environment with nextflow in order to run nextflow
- Modules already installed on BU Shared Computing cluster (SCC)
- If using aws, see envs file for all packages to install
- If not using BU SCC, see envs directory for software and version information
 
## Installation
  - Clone this repository in the SCC
  - git clone 'https://github.com/JackSherry6/Waxman-Lab-snRNA-seq-SNP-Calling-Pipeline.git'
 
## Usage
Basic execution: 
- ```module load miniconda```
- ```conda activate <name_of_your_nexflow_conda_env>```
- Set params.samples to the location of the folder containing your files
- Set params.ref_genome, ref_index, ref_dict to their respective file locations
- Modify the samples.csv file according to your sample names and groups 
- ```nextflow run main.nf -profile conda,cluster``` (for waxman lab you should always run on the cluster, but if using aws, substitute ```aws``` for ```cluster```)

## Configuration
- Lines for configuration in config file:
  - set samples, ref_genome, ref_index, ref_dict to locations
  - Set queueSize to appropriate size based on sample size (I use a quarter of the number of samples)
  - Optional: set resume to true in order to save progress during runs

## Input and Output
- Input:
  - Folder of cram/crai files (specify location in configs)
  - Reference fasta file (specify location in configs)
  - Reference fasta index file (specify location in configs)
  - Reference fasta dictionary file (specify location in configs)
- Output:
  - See results folder after program runs

## Contributing 
- Email me at jgsherry@bu.edu for additional information or contributing information
