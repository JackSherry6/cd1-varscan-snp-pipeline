#!/usr/bin/env nextflow

process BAM_INDEX {
    label 'process_low'
    conda 'envs/samtools_env.yml'
    tag "${name}"

    input:
    tuple val(name), path(bam)

    output:
    tuple val(name), path(bam), path("${bam}.bai")

    script:
    """
    samtools index $bam
    """

}