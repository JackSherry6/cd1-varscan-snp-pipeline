process PARSE_GTF {
    label 'process_low'
    conda 'envs/biopython_env.yml'
    publishDir params.outdir, mode:'copy'

    input:
    path(gtf)

    output:
    path("gene_names.csv")

    script:
    """
    gtf_parser.py -i $gtf -o gene_names.csv
    """
}