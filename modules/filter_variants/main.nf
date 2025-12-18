process FILTER_VARIANTS {
    label 'process_low'
    conda 'envs/bcftools_env.yml'
    publishDir params.outdir, mode:'copy'
    tag "${indels.simpleName}"

    input:
    tuple path(indels), path(snps)
    
    output:
    path("${indels.simpleName}.filtered.indel.vcf")
    path("${snps.simpleName}.filtered.snp.vcf")
    
    script:
    """
    bcftools view ${indels} | \
    bcftools filter -i 'INFO/SS == 2 && \
                         INFO/DP >= 10 && \
                         INFO/SPV <= 0.01' \
                         -o ${indels.simpleName}.filtered.indel.vcf
    
    bcftools view ${snps} | \
    bcftools filter -i 'INFO/SS == 2 && \
                         INFO/DP >= 10 && \
                         INFO/SPV <= 0.01' \
                         -o ${snps.simpleName}.filtered.snp.vcf
    """
}
