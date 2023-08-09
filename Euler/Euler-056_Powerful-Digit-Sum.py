#!/usr/bin/env python3
# /rhe/scripts/Euler/Euler-0056_Powerful-Digit-Sum.py
# Written by Robbie Hatley, Tue Mar 1, 2016.
SumMax = 0
for a in range(1, 100):
   for b in range(1, 100):
      Exp = a**b
      Sum = 0
      for i in str(Exp): Sum += int(i)
      if Sum > SumMax:
         SumMax = Sum
      print(a, "**", b, "=", Exp)
      print("Current   sum   = ", Sum)
      print("Current max sum = ", SumMax)
print("Final max sum = ", SumMax)
