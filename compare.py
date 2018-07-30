#Program to compare DEG list from CuffDiff to identify number of genes that match within datasets

import pandas as pd
from pandas import ExcelWriter
from pandas import ExcelFile

#Parsing DEG excel sheet for RN4
rn4 = pd.read_excel("DEG_RN4.xlsx", sheet_name = 'Sheet1')
rn4_symbols = rn4['Gene_Symbol']
rn4_set = set()

for i in rn4_symbols:
    rn4_set.add(i)

#Parsing DEG excel sheet for RN6
rn6 = pd.read_excel("DEG_RN6.xlsx", sheet_name = 'Sheet1')
rn6_symbols = rn6['Gene_Symbol']
rn6_set = set()

for i in rn6_symbols:
    rn6_set.add(i)

#comparing sets
diff = rn4_set.difference(rn6_set)
same = rn4_set.intersection(rn6_set)

print(len(diff))
print(len(same))
