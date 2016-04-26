import re
import itertools
import fileinput


for line in fileinput.input():
    tab= line.split(' ')
    
    l= (s for s in tab if re.match('[0-9]+', s))
    
    str=""
    
    for s in l:
        str+= s 
    print(str)

