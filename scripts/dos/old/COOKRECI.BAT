@echo off
rem cookreci.bat
rem erases cookies, MRU lists, and shelliconcache.
rem Written by Robbie Hatley.
rem Date written: Sunday January 18, 2004
rem Last updated: Thursday February 26, 2004
rem Note: Run this file from 16-bit real mode ONLY.  Start
rem system from win-me start-up diskette, go to C: drive,
rem cd to \software, and type "cachedmp".

c:

cd \windows

attrib -r -s -h cookies\*.* /s
deltree /y cookies
md "Cookies"

attrib -r -s -h recent\*.* /s
deltree /y recent
md "Recent"

attrib -r -s -h shelli~1
erase shelli~1

cd \

