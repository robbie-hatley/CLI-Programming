#! /bin/python
import sys
a=1
b=float(sys.argv[1])
for n in range(10000):
	a=b**a
	print(a)
	if a >= 100000:
		break

