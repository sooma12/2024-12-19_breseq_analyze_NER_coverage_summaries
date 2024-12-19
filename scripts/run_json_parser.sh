#!/bin/bash
# Usage: `bash run_json_parser.sh <breseq_parent_dir>

# Run this script from a directory containing many breseq outputs.
# Example folder tree (note that the summary.json files are 3 levels down inside output):
# clipper_output
#   7141
#     ...
#     output
#       summary.json
#   7142
#     ...
#     output
#       summary.json
# Note 7/18/2024: parse_summary_json is currently hard-coded for 5075 accession #s

BRESEQ_PARENT_DIR=${1}
JSON_PARSER_SCRIPT=/work/geisingerlab/Mark/breseq/breseq_scripts_mws/parse_summary_json.py

find $BRESEQ_PARENT_DIR -maxdepth 2 -mindepth 2 -type d -name output >breseq_dirs.list

out_filename=breseq_summary_stats.csv

if [ -f "${out_filename}" ] ; then
  rm "${out_filename}"
fi

chr_access=CP008706
pab1_access=CP008707
pab2_access=CP008708
pab3_access=CP008709


echo "read_file,total_reads,total_bases,percent_bases_mapped,${chr_access}_accession,${chr_access}_coverage_avg,${chr_access}_coverage_rel_variance,${chr_access}_num_reads_mapped,${chr_access}_num_bases_mapped,${chr_access}_length,${chr_access}_nbinom_fit_mean,${chr_access}_nbinom_fit_rel_var,${pab1_access}_accession,${pab1_access}_coverage_avg,${pab1_access}_coverage_rel_variance,${pab1_access}_num_reads_mapped,${pab1_access}_num_bases_mapped,${pab1_access}_length,${pab1_access}_nbinom_fit_mean,${pab1_access}_nbinom_fit_rel_var,${pab2_access}_accession,${pab2_access}_coverage_avg,${pab2_access}_coverage_rel_variance,${pab2_access}_num_reads_mapped,${pab2_access}_num_bases_mapped,${pab2_access}_length,${pab2_access}_nbinom_fit_mean,${pab2_access}_nbinom_fit_rel_var,${pab3_access}_accession,${pab3_access}_coverage_avg,${pab3_access}_coverage_rel_variance,${pab3_access}_num_reads_mapped,${pab3_access}_num_bases_mapped,${pab3_access}_length,${pab3_access}_nbinom_fit_mean,${pab3_access}_nbinom_fit_rel_var" >>$out_filename

paste breseq_dirs.list | while read dir ;
do
  python $JSON_PARSER_SCRIPT -i ${dir}/summary.json >>$out_filename
done
