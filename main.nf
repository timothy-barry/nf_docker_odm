#!/usr/bin/env nextflow

params.n_pods = 15
params.result_dir = "$launchDir"
params.odm_fp = "$projectDir/data/matrix.odm"

idx_ch = Channel.of( 1..params.n_pods )
process extract_column {
  echo true
  input: val i from idx_ch

  output: file 'column.rds' into column_ch

  """
  extract_column.R $i $params.odm_fp
  """
}

process combine_results {
  publishDir params.result_dir, mode: "copy"

  input: file 'raw_result' from column_ch.collect()

  output: file 'result.rds' into result_ch

  """
  combine_results.R raw_result*
  """
}