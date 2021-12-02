from pathlib import Path

# Input channels
sequence_ch = config["sequence"] 
#metadata_ch = config["metadata"]

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
