include {PARSE_GTF} from './modules/parse_gtf'
include {FASTQC} from './modules/fastqc'
include {STAR_INDEX} from './modules/star_index'
include {STAR_ALIGN} from './modules/star_align'
include {SAMTOOLS_FLAGSTAT} from './modules/samtools_flagstat'
include {MULTIQC} from './modules/multiqc'
include {SAMTOOLS_SORT} from './modules/samtools_sort'
include {BAM_INDEX} from './modules/bam_index'
include {MERGE_BAMS} from './modules/merge_bams'
include {SAMTOOLS_PILEUP} from './modules/samtools_pileup'
include {VARSCAN} from './modules/varscan_somatic'

workflow {
    Channel.fromPath(params.samplesheet)
    | splitCsv( header: true )
    | map{ row -> tuple(row.name, file(row.read1), file(row.read2)) }
    | set { reads_ch }

    FASTQC(reads_ch)

    STAR_INDEX(params.gtf, params.ref_genome)

    STAR_ALIGN(reads_ch, STAR_INDEX.out.index)

    SAMTOOLS_FLAGSTAT(STAR_ALIGN.out.bam)

    multiqc_ch = FASTQC.out.zip
        .map {it[1]}
        .mix(SAMTOOLS_FLAGSTAT.out)
        .collect()

    MULTIQC(multiqc_ch)

    SAMTOOLS_SORT(STAR_ALIGN.out.bam)

    BAM_INDEX(SAMTOOLS_SORT.out)

    //split bams into control and experimental
    BAM_INDEX.out
        .branch {
            control: it[0].startsWith('Control')
            exp: true
        }
        .set { branched_channels }

    control_ch = branched_channels.control
    exp_ch = branched_channels.exp

    control_ch
        .map { sample, bam, bai ->
        def prefix = sample.replaceAll(/\d+$/, '')  // Extract the Control prefix without sample num
        [prefix, bam, bai]
    }
    .groupTuple() 
    .set { all_controls_ch }

    MERGE_BAMS(all_controls_ch)

    exp_ch
        .combine(MERGE_BAMS.out)
        .set { paired_ch }
    
    SAMTOOLS_PILEUP(paired_ch, params.ref_genome)

    SAMTOOLS_PILEUP.out.view()

    VARSCAN(SAMTOOLS_PILEUP.out)
    
}
