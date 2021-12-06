#! /usr/bin/env bash

snakemake -j1 --config \
  sequence=data/example.fasta \
  metadata=data/metadata.tsv \
  exclude=data/exclude.txt \
  augur_app=augur