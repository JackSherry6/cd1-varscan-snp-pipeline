process SAMTOOLS_FLAGSTAT {
    label 'process_low'
    conda 'envs/samtools_env.yml'
    tag "${sample}"

    input:
    tuple val(sample), path(bam)

    output:
    path("${sample}.flagstat.txt")

    script:
    """
    samtools flagstat $bam > ${sample}.flagstat.txt
    """

}