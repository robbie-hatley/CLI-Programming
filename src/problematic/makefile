# Problematic Directory Make File
# Written by Robbie Hatley on 2022-01-18.
# Edit history:
# 2022-01-18: Wrote it.

# Set collection name:
COLLECTION := Problematic

# Set the exe directory so that gcc & g++ know where to write to:
EXSUFF := problematic

# Set source vpath directories so that make can find the c and cpp files for this collection:
vpath %.c   /d/rhe/src/problematic
vpath %.cpp /d/rhe/src/problematic

# ALL        = list of all *.exe files corresponding to the *.c and *.cpp files in current directory.
# C_PROGRAMS = list of all *.exe files corresponding to the *.c           files in current directory.
# X_PROGRAMS = list of all *.exe files corresponding to the         *.cpp files in current directory.
ALL        = $(shell make-all-list.pl)
C_PROGRAMS = $(shell make-c-list.pl)
X_PROGRAMS = $(shell make-x-list.pl)

#  *************************************************************************
#  * All the actual compilation is done via the pattern rules in maketail: *
#  *************************************************************************
include /d/rhe/src/maketail
