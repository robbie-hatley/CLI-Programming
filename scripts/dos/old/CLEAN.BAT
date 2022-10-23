@echo off
rem clean.bat
rem temporary-file erasing program
rem erases c:\temp(branch), c:\windows\*.tmp, c:\windows\temp(branch),
rem c:\windows\tempor~1 (branch)
rem (For a more thorough cleaning, use clean2.bat instead.)
rem Author: Robbie Hatley
rem Date written: circa 2000
rem Last updated: Thursday February 26, 2004
rem Note: Run this file from 16-bit real mode ONLY.  Start
rem system from win-me start-up diskette, go to C: drive,
rem cd to \software (if C:\software not in path), and type "clean".

c:

cd \

attrib -r -s -h temp\*.* /s
deltree /y temp
md "Temp"

cd \windows

attrib -r -s -h *.tmp
erase *.tmp

attrib -r -s -h temp\*.* /s
deltree /y temp
md "Temp"

datini tempor~1
deltree /y tempor~1

cd \

