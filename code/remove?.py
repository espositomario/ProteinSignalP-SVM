from sys import argv
with open(argv[1]) as file, open(argv[2],'w') as file2, open(argv[3],'w') as file3:
    tri = []
    file.readline()
    for line in file:
        line = line.rstrip()
        if line.split()[2].split('..')[1][:-1] != '?':
            if int(line.split()[2].split('..')[1][:-1]) >= 13:
                file2.write(line.split('\t')[0]+'\n')
            else:
                file3.write(line.split('\t')[0]+'\n')
