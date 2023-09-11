#!/usr/bin/python3
import math
import sys
if len(sys.argv) != 2: sys.exit()
max=int(sys.argv[1], 10)
if max>=2: print(2)
for x in range(3,max+1,2):
   if 0==x%2: continue
   limit=math.floor(math.sqrt(x))
   composite=False
   for y in range(3,limit+1,2):
      if 0==x%y:
         composite=True
         break
   if not composite:
      print(x)
