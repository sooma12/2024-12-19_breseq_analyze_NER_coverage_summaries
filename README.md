## File locations

From Eddie:

```text
Hi Mark, a while back you ran breseq on a WGS dataset and in addition to exporting the variant calls, you exported a table with the summary stats including average read coverage (see "breseq_summary_stats_fastxclip_2024-07-19.csv" above).
Do you think you could do this same analysis on another set of WGS files?  I am particularly interested in the summary stats table with coverage.  The files are this location (note, you can exclude the MSA55 files):
/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55
Reference files would be the same ones you did for the above (AB5075 chromosome and 3 plasmids):
/work/geisingerlab/REFERENCES/
CP008706.gbk
p1AB5075.gbk
p2AB5075.gbk
p3AB5075.gbk
Whenever you can -- thanks so much!!

```

Data to process: `/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55`

Data are from Seqcenter.  Paired end sequencing, already trimmed.

Make a list of files to process:

```bash
# Make a list of files in the target directory ending in .fastq.gz but not containing "MSA55"
find /work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55 ! -name '*MSA55*' -name *.fastq.gz > input_fastq_gzs.list 

cat input_fastq_gzs.list 
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/EGA733_1_S209_R1_001.fastq.gz
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/EGA733_1_S209_R2_001.fastq.gz
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/EGA733_2_S210_R1_001.fastq.gz
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/EGA733_2_S210_R2_001.fastq.gz
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/EGA733_3_S211_R1_001.fastq.gz
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/EGA733_3_S211_R2_001.fastq.gz
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/NRA275_6_S204_R1_001.fastq.gz
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/NRA275_6_S204_R2_001.fastq.gz
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/NRA275_7_S205_R1_001.fastq.gz
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/NRA275_7_S205_R2_001.fastq.gz
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/NRA275__S203_R1_001.fastq.gz
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/NRA275__S203_R2_001.fastq.gz
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/NRA276_5_S206_R1_001.fastq.gz
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/NRA276_5_S206_R2_001.fastq.gz
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/NRA276_6_S207_R1_001.fastq.gz
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/NRA276_6_S207_R2_001.fastq.gz
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/NRA276_7_S208_R1_001.fastq.gz
#/work/geisingerlab/SEQCENTER-SEQUENCINGREADS-BACKUP/20240829_IlluminaDNAReads_EGA733_NRA275_6_MSA55/NRA276_7_S208_R2_001.fastq.gz

```

## Fastqc to check reads


## Sample sheet prep

Used scripts 2a, 2b to prepare sample sheets with names and file paths corresponding to fastq samples

## breseq

Re-sequencing analysis performed using breseq with default settings 

## Analysis


### Check number of output directories and compare to number of input fastqs.

In trimmed fastq directories: `find ./  -type f -name '*.fastq' | wc -l`

untrimmed -> **94**

trimmed_fastxclip -> **94**

trimmed_cutadapt_34minlen_egadapter -> **94**

Then, check in breseq output directories: `find . -mindepth 1 -maxdepth 1 -type d | wc -l`

breseq-fastx-trimmed -> **94**

breseq-cutadapt-trimmed -> **91**

So breseq failed on 3 cutadapt-trimmed samples.

Find these!

`cd` to ./logs/breseq-cutadapt/

Code below finds any files that do not have the "SUCCESSFULLY COMPLETED" line in the breseq output and prints the end of each.

`
grep -riL "+++   SUCCESSFULLY COMPLETED" ./*.err > unsuccessful.list
paste unsuccessful.list | while read file; do echo; echo; echo $file; tail -n 20 $file; echo; done
`

./breseq_array_cutadapt_43341106_34.err -> NRA297
./breseq_array_cutadapt_43341106_38.err -> NRA302
./breseq_array_cutadapt_43341106_41.err -> NRA306
./breseq_array_cutadapt_43341106_57.err -> NRA323
./breseq_array_cutadapt_43341106_62.err -> NRA328
./breseq_array_cutadapt_43341106_69.err -> NRA335
./breseq_array_cutadapt_43341106_78.err -> NRA344
./breseq_array_cutadapt_43341106_82.err -> NRA348
./breseq_array_cutadapt_43341106_83.err -> NRA349
./breseq_array_cutadapt_43341106_85.err -> NRA351
./breseq_array_cutadapt_43341106_86.err -> NRA352
./breseq_array_cutadapt_43341106_87.err -> NRA353
./breseq_array_cutadapt_43341106_90.err -> NRA356
./breseq_array_cutadapt_43341106_91.err -> NRA357


### Verify presence of "output" subdirectories containing 

Check for presence of "output" subdirectory in each output folder to ensure complete breseq-ing

From the ./output/breseq/ directory, run:
`find ./ -maxdepth 2 -mindepth 2 -type d '!' -exec test -e "{}/output/summary.json" ';' -print`

Lists any subdirectory that does NOT contain an 'output/summary.json' file

Also looked for index.html; some lacked (indicates a failure; most likely breseq ran out of memory)

Made array of folders missing index.html and redid using finish_breseq_fastxclip.sh

To move those outputs into the original breseq-fastx-trimmed folder...

Remove folders corresponding to incomplete breseq analysis:
```bash
cd /work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/output/breseq/breseq-fastx-trimmed
mkdir .first_draft_incomplete
unfinished_samples_array=(276 280 281 282 283 285 287 289 290 293 294 298 304 306 308 309 310 311 313 314 319 331 342 345 351)
for i in "${unfinished_samples_array[@]}"
do
  mv NRA"$i" .first_draft_incomplete/
done
```


Used run_json_parser.sh to extract key data from 
