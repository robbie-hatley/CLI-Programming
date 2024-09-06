@echo off
rem xclean.bat Xtreme system cleaner.
rem Author: Robbie Hatley
rem Date written: Sunday January 18, 2004
rem Last updated: Thursday February 26, 2004
rem Note: Run this file from 16-bit real mode ONLY.  Start
rem system from win-me start-up diskette, go to C: drive,
rem cd to \software, and type "xclean".
rem Deletes C:\Temp\*.*, C:\Windows\*.tmp, C:\Windows\Temp\*.*,
rem C:\Windows\tempor~1\*.*, C:\Windows\Cookies, C:\Windows\Recent,
rem C:\Windows\shelliconcache, and all files in recycle bins or
rem system-restore archives.

rem Warning: Do not run this program lightly!  It erases all files in the
rem Windows system-restore archives!

call clean.bat
call cookreci.bat
call trshempt.bat
call killrstr.bat

