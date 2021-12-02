# Snakemake - workflows

Explore snakemake configs, expecially [writing workflows](https://snakemake.readthedocs.io/en/stable/snakefiles/writing_snakefiles.html).

## Create a basic example

Snakemake mentions `subworkflows` and `include`. The former is executed as a separate workflow before the main script. The later adds the rules to the main script. I picked the later.

Followed the file structure described in [Distribution and Reproducibility](https://snakemake.readthedocs.io/en/stable/snakefiles/deployment.html).

**Snakefile**

```
include: 'rules/mod1.smk'
include: 'rules/mod2.smk'

rule all:
    input: 'b.txt'
```

And run with: 

```
git clone https://github.com/j23414/snakemake_test.git
cd snakemake_test
snakemake -j1
```

<details><summary>output</summary>

```
Building DAG of jobs...
Using shell: /bin/bash
Provided cores: 1 (use --cores to define parallelism)
Rules claiming more threads will be scaled down.
Job counts:
	count	jobs
	1	all
	1	mod1
	1	mod2
	3

[Wed Dec  1 21:19:37 2021]
rule mod1:
    output: a.txt
    jobid: 2

[Wed Dec  1 21:19:37 2021]
Finished job 2.
1 of 3 steps (33%) done

[Wed Dec  1 21:19:37 2021]
rule mod2:
    input: a.txt
    output: b.txt
    jobid: 1

[Wed Dec  1 21:19:37 2021]
Finished job 1.
2 of 3 steps (67%) done

[Wed Dec  1 21:19:37 2021]
localrule all:
    input: b.txt
    jobid: 0

[Wed Dec  1 21:19:38 2021]
Finished job 0.
3 of 3 steps (100%) done
Complete log: /Users/jenchang/covid/data/gisaid_clades_2021_12_01/snakemake_test/.snakemake/log/2021-12-01T211937.806325.snakemake.log
```

</details>


## Augur index example

As a minimal example, I wanted the following features:

* [x] Pass in an input file from terminal
* [x] Output files should be a modified form of the input file, not predetermined.
* [x] Optionally pass in the path to executables
* [ ] Reasonable variable scoping rules, still exploring...
* [ ] Import rules but rearrange the order in the main Snakefile (can we re-wire the input/output filenames?)

[workflow/rules/augur.smk](workflow/rules/augur.smk)

**Snakefile**

```
include: 'rules/augur.smk'

#sequence_ch = config["sequence"]  # Nope, not passed to the sub rules. Figure out scope

rule all:
    input: final_input = rules.index.output.indexed
```

Can be run with and without the `--config augur_app=/path/to/augur`.

```
snakemake -j1 --config sequence=example.fasta
snakemake -j1 --config sequence=example.fasta augur_app=augur
Building DAG of jobs...
Using shell: /bin/bash
Provided cores: 1 (use --cores to define parallelism)
Rules claiming more threads will be scaled down.
Job counts:
	count	jobs
	1	all
	1	index
	2

[Wed Dec  1 22:37:14 2021]
rule index:
    input: example.fasta
    output: example_index.tsv
    jobid: 1

[Wed Dec  1 22:37:16 2021]
Finished job 1.
1 of 2 steps (50%) done

[Wed Dec  1 22:37:16 2021]
localrule all:
    input: example_index.tsv
    jobid: 0

[Wed Dec  1 22:37:16 2021]
Finished job 0.
2 of 2 steps (100%) done
Complete log: /Users/jenchang/covid/data/gisaid_clades_2021_12_01/snakemake_test/.snakemake/log/2021-12-01T223714.290496.snakemake.log
```
