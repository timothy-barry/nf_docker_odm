#!/usr/bin/env nextflow

params.odm_fp = ""
params.n_pods = 15
params.result_dir = "$launchDir"

idx_ch = Channel.of( 1..params.n_pods )
process extract_column {
  errorStrategy 'retry'
  maxRetries 4

  input:
  val i from idx_ch
  path odm_fp from params.odm_fp

  output:
  file 'column.rds' into column_ch

  """
  extract_column.R $i $odm_fp
  """
}

process combine_results {
  publishDir params.result_dir, mode: "copy"

  input:
  file 'raw_result' from column_ch.collect()

  output:
  file 'result.rds' into result_ch

  """
  combine_results.R raw_result*
  """
}
