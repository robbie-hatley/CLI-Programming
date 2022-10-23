#! /bin/python3
import os
print('\nCWD:')
print(os.getcwd())
print('\nDIRECTORIES:')
for x in os.listdir('.'):
   if os.path.isdir(x):
      print(x)
print('\nFILES:')
for x in os.listdir('.'):
   if os.path.isfile(x):
      print(x)
