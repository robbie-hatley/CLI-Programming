@echo off
rem clean3.bat
rem erases temporary files, MRU lists, cookies, shelliconcache, and trash.
rem Author: Robbie Hatley
rem Date written: Sunday January 18, 2004
rem Last updated: Thursday February 26, 2004
rem Note: Run this file from 16-bit real mode ONLY.  Start
rem system from win-me start-up diskette, go to C: drive,
rem cd to \software, and type "clean".
rem Deletes C:\Temp (branch), C:\Windows\*.tmp, C:\Windows\Temp (branch),
rem C:\Windows\tempor~1 (branch), C:\Windows\Cookies (branch),
rem C:\Windows\Recent (branch), C:\Windows\shelliconcache,
rem and all files in recycle bins.

rem Warning: This program erases all files in the recycle bins.

call clean.bat
call cookreci.bat
call trshempt.bat

