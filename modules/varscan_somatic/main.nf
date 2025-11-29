process VARSCAN {
    label 'process_medium'
    conda 'bioconda::varscan'  // For some reason scc doesn't like varscan as a yml file
    tag "${mpileup.baseName}"
    publishDir params.outdir, mode:'copy'

    input: 
    tuple val(sample), path(mpileup)

    output:
    path("${sample}_out*")

    script:
    """
    varscan somatic $mpileup ${sample}_out \
        --mpileup 1 \
        --min-coverage 10 \
        --min-var-freq 0.10 \
        --somatic-p-value 0.05 \
        --output-vcf 1
    """
}