@echo off
cls
echo Put HTML4 ("Images") disk in drive A:
pause
c:
cd \www
xcopy images\*.*  a:\  /m/y/s/e/v

