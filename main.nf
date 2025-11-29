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

    sample_groups = Channel
        .fromPath(params.sample_names)
        .splitCsv(header: true)
        .map { row -> [row.SampleID, row.Group] }

    bam_channel = BAM_INDEX.out

    bam_with_clean_id = bam_channel
        .map { sample_id, bam, bai ->
            def clean_id = sample_id.tokenize('_').last()
            [clean_id, sample_id, bam, bai]
        }

    bams_with_groups = bam_with_clean_id
        .join(sample_groups)
        .map { clean_id, full_sample_id, bam, bai, group ->
            [group, full_sample_id, bam, bai]
        }

    grouped_bams = bams_with_groups
        .groupTuple()
        .map { group, sample_ids, bams, bais ->
            [group, bams, bais]
        }

    MERGE_BAMS(grouped_bams)

    merged_bams = MERGE_BAMS.out

    pairwise_combinations = merged_bams
    .combine(merged_bams)
    .filter { group1, bam1, bai1, group2, bam2, bai2 ->
        group1 != group2  
    }
    .map { group1, bam1, bai1, group2, bam2, bai2 ->
        if (group2.contains('control') && !group1.contains('control')) {
            ["${group2}_vs_${group1}", group2, bam2, bai2, group1, bam1, bai1]
        } else {
            ["${group1}_vs_${group2}", group1, bam1, bai1, group2, bam2, bai2]
        }
    }
    .unique()  
    
    SAMTOOLS_PILEUP(pairwise_combinations, params.ref_genome)

    VARSCAN(SAMTOOLS_PILEUP.out)
    
}
