
process SAMTOOLS_PILEUP {
    label 'process_medium'
    conda 'envs/samtools_env.yml'
    publishDir params.outdir, mode:'copy'
    tag "${sample}"

    input: 
    tuple val(sample), val(control_name), path(control_bam), path(control_bai), val(exp_name), path(exp_bam), path(exp_bai)
    //tuple path(bam1), path(bai1), path(bam2), path(bai2)
    path(ref_genome)

    output:
    tuple val(sample), path("${sample}.mpileup")

    script:
    """
    samtools mpileup -f $ref_genome -q 1 -B $control_bam $exp_bam > ${sample}.mpileup
    """
    // -q 1 is min mapping quality of 1. -B is to disable BAQ adjustment which is recommended for varscan
}

