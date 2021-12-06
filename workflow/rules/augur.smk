from pathlib import Path

# Input channels
sequence_ch = config["sequence"] 
metadata_ch = config["metadata"]
exclude_ch = config["exclude"]

# Pass in path to executables if they exist
# augur_app = config["augur_app"] or "augur"
if("augur_app" in config.keys()):
    augur_app = config["augur_app"]
else:
    augur_app = "augur"

rule index:
    input:
        sequences = sequence_ch
    params:
        prefix = Path(sequence_ch).stem
    output: 
        indexed = Path(sequence_ch).stem + "_index.tsv"
    shell: 
        """
        {augur_app} index \
          --sequences {input.sequences} \
          --output {params.prefix}_index.tsv
        """

rule filter:
    input:
        sequences = sequence_ch,
        sequence_index = rules.index.output.indexed,
        metadata = metadata_ch,
        exclude = exclude_ch,
    params:
        prefix = Path(sequence_ch).stem
    output:
        filtered = Path(sequence_ch).stem + "_filtered.fasta"
    shell:
        """
        {augur_app} filter \
            --sequences {input.sequences} \
            --sequence-index {input.sequence_index} \
            --metadata {input.metadata} \
            --exclude {input.exclude} \
            --output {params.prefix}_filtered.fasta \
            --group-by country year month \
            --sequences-per-group 20 \
            --min-date 2012
        """