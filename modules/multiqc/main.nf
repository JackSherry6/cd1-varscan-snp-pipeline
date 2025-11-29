process MULTIQC {
    label 'process_low'
    conda 'envs/multiqc_env.yml'
    publishDir "${params.outdir}/multiqc", mode: "copy"

    input:
    path('*')

    output:
    path('*.html')
    path("multiqc_data")

    script:
    """
    multiqc . -f
    """
}