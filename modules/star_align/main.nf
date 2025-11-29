#!/usr/bin/env nextflow

process STAR_ALIGN {
    label 'process_medium'
    conda 'envs/star_env.yml'
    tag "${name}"

    input:
    tuple val(name), path(read1), path(read2)
    path index

    output:
    tuple val(name), path("${name}.Aligned.sortedByCoord.out.bam"), emit: bam
    tuple val(name), path("${name}.Log.final.out"), emit: log
    //tuple val(name), path("${name}Solo.out/"), emit: solo

    script:
    """
    STAR \
        --genomeDir $index \
        --readFilesIn $read1 $read2 \
        --readFilesCommand zcat \
        --outFileNamePrefix ${name}. \
        --outSAMtype BAM SortedByCoordinate 2> ${name}.Log.final.out
    """

}
/*
--soloType CB_UMI_Simple \
        --soloCBstart 41 --soloCBlen 16 \
        --soloUMIstart 57 --soloUMIlen 12 \
        --soloFeatures GeneFull
*/