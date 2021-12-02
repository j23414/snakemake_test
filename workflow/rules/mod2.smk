rule mod2:
    input: 'a.txt'
    output: 'b.txt'
    shell: 'cat a.txt > b.txt; echo world >> b.txt'