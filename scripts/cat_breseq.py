## Yunfei Dai; fixed MWS 3/21/2024
## 04/13/2022

# This script concatenates mutation predictions from breseq results (.html)
# Input is the parent directory that contains multiple folders, with output files for each sample.
# Usage: python cat_breseq.py -i [breseq results] -n [gene to ignore (optional)] -o [output file (optional)]

from os import path, listdir, getcwd
from bs4 import BeautifulSoup
from optparse import OptionParser
import lxml, csv

options = OptionParser()
options.add_option("-i", "--infile", dest="infile", help="provide input directory; should be the parent directory of /output/index.html")
options.add_option("-n", "--ignore", dest="ignore", default="///", help="suppress mutations mapped to specified gene")
options.add_option("-o", "--outdir", dest="outdir", default="", help="specify output directory")

# generate summary results for 1) Prediction mutations; 2) Unassigned new junction evidence
def generate_summary(infile, ignore, outfile_1, outfile_2):
    for item in listdir(infile):
        file=path.join(infile,item)
        if path.isdir(file)==True:
            prediction = path.join(file,"index.html")
            if path.isfile(prediction):
                with open(prediction) as fp:
                    soup = BeautifulSoup(fp, 'lxml')
                    tables = soup.find_all("table")
                    # table 1 is the predicted mutations
                    table_1 = tables[1]
                    index_reader(item, table_1, outfile_1, ignore, 1)
                    # table 2 is the unassigned new junctions
                    table_2 = tables[-1]
                    index_reader(item, table_2, outfile_2, ignore, 2)

# extract information from html tables
def index_reader(item, table, outfile, ignore, table_type):
    if table_type == 1:
        for row in table.find_all("tr")[2:]:
            text = [td.get_text() for td in row.find_all("td")]
            evidence = text[0]
            seq_id = text[1]
            position = text[2]
            mutation = text[3]
            annotation = text[4]
            gene = text[5]
            description = text[6]
            # Discard mutations mapped to plasmid genes
            result = [item, evidence, seq_id, position, mutation, annotation, gene, description]
            with open(outfile, 'a', newline='') as csvfile:
                output_writer = csv.writer(csvfile, delimiter='\t')
                output_writer.writerow(result)

    elif table_type == 2:
        for row in table.find_all("tr")[2:]:
            text = [td.get_text() for td in row.find_all("td")]
            if len(text) == 7:
                seq_id = text[1]
                position = text[2]
                read_cov1 = text[3]
                annotation = text[4]
                gene = text[5]
                product = text[6]
                result = [item, seq_id, position, read_cov1, "", "", "", "", annotation, gene, product]
            elif len(text) == 12:
                seq_id = text[2]
                position = text[3]
                read_cov1 = text[4]
                read_cov2 = text[5]
                score = text[6]
                skew = text[7]
                freq = text[8]
                annotation = text[9]
                gene = text[10]
                product = text[11]
                result = [item, seq_id, position, read_cov1, read_cov2, score, skew, freq, annotation, gene, product]
            with open(outfile, 'a', newline='') as csvfile:
                output_writer = csv.writer(csvfile, delimiter='\t')
                output_writer.writerow(result)

def main():
    opts, args = options.parse_args()
    infile = opts.infile
    ignore = opts.ignore
    outdir = opts.outdir
    header_1 = ["Sample", "Evidence", "Seq_ID", "Position", "Mutation", "Annotation", "Gene", "Description"]
    header_2 = ["Sample", "Seq_ID", "Positions", "Reads (cov)", "Reads (cov)", "Score", "Skew", "Freq", "Annotation", "Gene", "Product"]
    if path.isdir(outdir):
        outfile_1 = path.join(outdir, "Predicted_Mutations_all.txt")
        outfile_2 = path.join(outdir, "Unassigned_new_junction_evidence_all.txt")
    else:
        outfile_1 = path.join(infile, "Predicted_Mutations_all.txt")
        outfile_2 = path.join(infile, "Unassigned_new_junction_evidence_all.txt")
        # with open(outfile_1, 'w', newline='') as csvfile_1:
        #     output_writer = csv.writer(csvfile_1, delimiter='\t')
        #     output_writer.writerow(header_1)
        # with open(outfile_2, 'w', newline='') as csvfile_2:
        #     output_writer = csv.writer(csvfile_2, delimiter='\t')
        #     output_writer.writerow(header_2)
    generate_summary(infile, ignore, outfile_1, outfile_2)

    print("Predicted mutations saved as: " + outfile_1  + "\n")
    print("Unassigned new junction evidece saved as: " + outfile_2 + "\n")

if __name__ == '__main__':
    main()
