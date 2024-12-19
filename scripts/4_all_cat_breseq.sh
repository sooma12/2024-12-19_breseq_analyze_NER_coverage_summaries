#!/bin/bash
source ./config.cfg

mkdir -p ${CAT_OUT_PATH_FASTX}

find ${BRESEQ_OUTPATH_FASTX} -maxdepth 1 -mindepth 1 -type d > output_dirs.list

# Written for filepaths like: /Users/mws/Documents/geisinger_lab_research/bioinformatics_in_acinetobacter/lirL_suppressor_mutations_breseq/2023-10-20_breseq/breseq_output/output_zips/MSA152
paste output_dirs.list| while read directory ;
do
  rootname=$(basename ${directory})
  echo
  echo "BASH: running python script on " ${directory}
  python ${SCRIPT_DIR}/cat_breseq.py -i ${directory} -o ${CAT_OUT_PATH_FASTX}
  echo "BASH: ----completed python script ----"
  echo "BASH: moving from ${CAT_OUT_PATH_FASTX}/Predicted_Mutations_all.txt to ${CAT_OUT_PATH_FASTX}/${rootname}_predicted_mutations.txt"
  mv ${CAT_OUT_PATH_FASTX}/Predicted_Mutations_all.txt ${CAT_OUT_PATH_FASTX}/${rootname}_predicted_mutations.txt
  echo "BASH: moving from ${CAT_OUT_PATH_FASTX}/Unassigned_new_junction_evidence_all.txt to ${CAT_OUT_PATH_FASTX}/${rootname}_unassigned_new_junction_evidence.txt"
  mv ${CAT_OUT_PATH_FASTX}/Unassigned_new_junction_evidence_all.txt ${CAT_OUT_PATH_FASTX}/${rootname}_unassigned_new_junction_evidence.txt
  echo "BASH: finished $rootname"
  echo
done
