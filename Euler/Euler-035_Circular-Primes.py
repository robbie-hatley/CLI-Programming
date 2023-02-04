#! /usr/bin/python3

import sys, os

def Rotate (InpStr, RotAmt):
   OutStr = InpStr[len(InpStr)-RotAmt:] + InpStr[0:len(InpStr)-RotAmt]
   return OutStr

InpStr = sys.argv[1]
RotAmt = int(sys.argv[2])
OutStr = Rotate(InpStr, RotAmt)
print(OutStr)
