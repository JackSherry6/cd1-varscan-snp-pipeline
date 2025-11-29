process STAR_INDEX {
    label 'process_medium'
    conda 'envs/star_env.yml'

    input:
    path(gtf)
    path(ref_genome)

    output:
    path "star", emit: index

    script:
    """
    mkdir -p star
    STAR --runMode genomeGenerate \
         --genomeDir star \
         --genomeFastaFiles $ref_genome \
         --sjdbGTFfile $gtf \
         --sjdbOverhang 150
    """
}