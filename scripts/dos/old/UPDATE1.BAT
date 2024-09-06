@echo off
cls
echo Put HTML1 ("Midnight Moonlight Madness") disk in drive A:
pause
c:
cd \www
xcopy mmm\*.*         a:\mmm\         /m/y/s/e/v
xcopy arveleg\*.*     a:\arveleg\     /m/y/s/e/v
xcopy spdracer.bl\*.* a:\spdracer.bl\ /m/y/s/e/v
xcopy rhatley\*.*     a:\rhatley\     /m/y/s/e/v

