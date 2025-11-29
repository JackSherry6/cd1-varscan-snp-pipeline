# Waxman Lab RNA-seq SNP Calling Pipeline for CD1 Mouse Reference Genome

This project was prompted by my desire to improve the quality of SNP calling from RNA-seq data by using a CD1-specific reference genome. I was tasked with developing a method to accurately detect mutations driving tumorigenesis across the genome from RNA-seq data generated from our outbred CD1 mouse strain. Previously, our lab aligned reads and performed differential expression analyses using the mm9 reference genome; however, this approach was inadequate for identifying polymorphisms in an outbred population. The mm9 reference represents a single, inbred laboratory strain and therefore lacks the genetic diversity present in CD1 mice. As a result, alignment accuracy was reduced, variant calls were unreliable, and many true CD1-specific SNPs were missed. On top of that, the initial variant callers I used did not offer the option to compare control and tumor samples during the variant calling process, which caused additional complications on manually filtering and processing variant data. Therefore I decided to switch to varscan somatic for control vs tumor variant calling. These improvements allowed for more accurate mapping, improved SNP detection, and better representation of the genetic variation inherent to this outbred strain. 

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
  - Alignment to CD1 reference genome
  - Custom experimental group combining and merging 
  - SNP calling and variant filtering
  - Supports BU HPC cluster execution.
- Docker/Singularity container support for reproducibility.
- Automatic logging and error handling.
- Scalable to large RNA-seq datasets.

## Requirements
- Must have a conda environment with nextflow in order to run nextflow
- Modules already installed on BU Shared Computing cluster (SCC)
- If using aws, see envs file for all packages to install
- If not using BU SCC, see envs directory for software and version information
 
## Installation
  - Clone this repository in the SCC
  - git clone 'https://github.com/JackSherry6/cd1-varscan-snp-pipeline.git'
 
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
