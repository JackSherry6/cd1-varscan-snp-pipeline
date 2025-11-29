process FASTQC {
    label 'process_low'
    conda 'envs/fastqc_env.yml'
    tag "${sample}"
    publishDir "${params.outdir}/fastqc", mode: 'copy'
    
    input:
    tuple val(sample), path(read1), path(read2)
    
    output:
    tuple val(sample), path("*.html"), emit: html
    tuple val(sample), path("*.zip"), emit: zip

    script:
    """
    fastqc ${read1} ${read2}
    """
}