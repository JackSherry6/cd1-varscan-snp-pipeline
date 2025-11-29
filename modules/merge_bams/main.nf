process MERGE_BAMS {
    label 'process_low'
    conda 'envs/samtools_env.yml'
    tag "${sample}"
     
    input:
    tuple val(sample), path(bams), path(bais)
    
    output:
    tuple val(sample), path("${sample}.merged.bam"), path("${sample}.merged.bam.bai")
    
    script:
    """
    samtools merge ${sample}.merged.bam ${bams}
    samtools index ${sample}.merged.bam
    """
}
