process SAMTOOLS_PILEUP {
    label 'process_medium'
    conda 'envs/samtools_env.yml'
    tag "control_vs_${exp_name}" 

    input: 
    tuple val(exp_name), path(exp_bam), path(exp_bai), val(control_name), path(control_bam), path(control_bai)
    path(ref_genome)

    output:
    tuple val("control_vs_${exp_name}"), path("control_vs_${exp_name}.mpileup")

    script:
    """
    samtools mpileup -f $ref_genome -q 1 -B $control_bam $exp_bam > control_vs_${exp_name}.mpileup
    """
    // -q 1 is min mapping quality of 1. -B is to disable BAQ adjustment which is recommended for varscan
}

