@echo off
rem clean2.bat
rem erases temporary files, MRU lists, and shelliconcache.
rem Author: Robbie Hatley
rem Date written: Sunday January 18, 2004
rem Last updated: Thursday February 26, 2004
rem Note: Run this file from 16-bit real mode ONLY.  Start
rem system from win-me start-up diskette, go to C: drive,
rem cd to \software, and type "clean".

rem First, erase temporary files:
call clean.bat

rem Then, erase cookies, MRU lists, and shelliconcache:
call cookreci.bat

