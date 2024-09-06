@echo off
cls
echo Put HTML2 ("Web Resources") disk in drive A:
pause
c:
cd \www
xcopy misc\*.*     a:\misc\     /m/y/s/e/v 
xcopy surplus\*.*  a:\surplus\  /m/y/s/e/v
xcopy urls\*.*     a:\urls\     /m/y/s/e/v

