process SAMTOOLS_SORT {
    label 'process_medium'
    conda 'envs/samtools_env.yml'
    tag "${sample}"

    input:
    tuple val(sample), path(bam)

    output:
    tuple val(sample), path("${bam.baseName}.sorted.bam")

    script:
    """
    samtools sort -@ $task.cpus $bam > ${bam.baseName}.sorted.bam
    """

}