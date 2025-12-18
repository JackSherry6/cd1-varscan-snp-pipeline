process VARSCAN {
    label 'process_medium'
    conda 'bioconda::varscan'  // For some reason scc doesn't like the varscan yml but this works 
    tag "${mpileup.baseName}"
    //publishDir params.outdir, mode:'copy'

    input: 
    tuple val(sample), path(mpileup)

    output:
    path("${sample}_out*.vcf")

    script:
    """
    varscan somatic $mpileup ${sample}_out \
        --mpileup 1 \
        --min-coverage 10 \
        --min-coverage-normal 50 \
        --min-coverage-tumor 10 \
        --min-var-freq 0.20 \
        --min-freq-for-hom 0.75 \
        --normal-purity 1.0 \
        --tumor-purity 1.0 \
        --somatic-p-value 0.01 \
        --strand-filter 1 \
        --output-vcf 1
    """
}
