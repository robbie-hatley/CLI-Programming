# Euler Directory Make File
# Written by Robbie Hatley.
# Edit history:
#    Sun Feb 21, 2016: Wrote it.
#    Mon Mar 05, 2018: Altered EXEDIR for multi-platform, 
#                      and changed "make-cpp-list" to "make-x-list".
#    Sat Jan 08, 2022: Updated for Linux.

# Set collection name:
COLLECTION := Euler

# Set the exe directory suffix:
EXSUFF := Euler

# Set source vpath directories so that make can find the c and cpp files for this collection:
vpath %.c   /d/rhe/Euler
vpath %.cpp /d/rhe/Euler

# ALL        = list of all *.exe files corresponding to the *.c and *.cpp files in current directory.
# C_PROGRAMS = list of all *.exe files corresponding to the *.c           files in current directory.
# X_PROGRAMS = list of all *.exe files corresponding to the         *.cpp files in current directory.
ALL        = $(shell make-all-list.pl)
C_PROGRAMS = $(shell make-c-list.pl)
X_PROGRAMS = $(shell make-x-list.pl)

#  ****************************************************************************
#  *                                                                          *
#  *  (All the actual compilation is done via the pattern rules in maketail.) *
#  *                                                                          *
#  ****************************************************************************

# Include maketail:
include /d/rhe/src/maketail
















