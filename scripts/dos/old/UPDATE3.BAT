@echo off
cls
echo Put HTML3 ("Help") disk in drive A:
pause
c:
cd \www
xcopy help\*.* a:\ /m/y/s/e/v

