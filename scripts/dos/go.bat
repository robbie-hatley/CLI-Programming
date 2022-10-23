@echo off
rem "go.bat" Go-To-Directory Batch File
rem Author:  Robbie Hatley
rem Written: Sat. Apr. 26, 2003
rem Edit history:
rem    Thu Feb 05, 2004
rem    Sat Nov 20, 2004
rem    Thu Jun 09, 2005 - added "go scripts"
rem    Fri Dec 21, 2007 - corrected many obsolete locations
rem    Sat Dec 22, 2007 - added comments, corrected accumulated errors
goto %1

// My Auditorium is my repository for sound files of all types:
:auditorium
E:
cd \Auditorium
goto end

// "bin" folders are for small stand-alone utility programs, mostly of my own authorship:
:bin-fractals
E:
cd \bin-fractals
goto end

:bin-games
E:
cd \bin-games
goto end

:bin-graphics
E:
cd \bin-graphics
goto end

:bin-jive
E:
cd \bin-jive
goto end

:bin-math
E:
cd \bin-math
goto end

:bin-sysinternals
E:
cd \bin-sysinternals
goto end

:bin-test
E:
cd \bin-test
goto end

:bin-xxcopy
E:
cd \bin-xxcopy
goto end

:bin-third-party
E:
cd \bin-third-party
goto end

:bin-util
E:
cd \bin-util
goto end

// Pictures of boys:
:boys
F:
cd \Boys
goto end

// Boy series:
:bseries
F:
cd \Boys\Series
goto end

// C Programming - Fractals:
:cfractals
E:
cd \RHE\src\fractals
goto end

// C Programming - Games:
:cgames
E:
cd \RHE\src\games
goto end

// C Programming - Graphics:
:cgraphics
E:
cd \RHE\src\graphics
goto end

// C Programming - Library:
:clib
E:
cd \RHE\src\librh
goto end

// C Programming - Math:
:cmath
E:
cd \RHE\src\math
goto end

// C Programming - Test:
:ctest
E:
cd \RHE\src\test
goto end

// C Programming - Test-Range:
:testrange
E:
cd \test-range
goto end

// C Programming - Test-Range - Rename-Test:
:testrangerename
E:
cd \test-range\rename-test
goto end

// C Programming - Test-Range - Dedup-Newsbin-Test:
:testrangednf
E:
cd \Test-Range\dedup-newsbin-test
goto end

// C Programming - Util:
:cutil
E:
cd \RHE\src\util
goto end

// C Programming - Jive:
:cjive
E:
cd \RHE\src\jive
goto end

// djgpp:
:djgpp
C:
cd \djgpp\bin
goto end

:gallery
D:
cd \Gallery
goto end

:girls
F:
cd \Girls
goto end

:gseries
F:
cd \Girls\Series
goto end

:incoming
F:
cd \Newsbin-Incoming
goto end

:java
E:
cd \RHE\Java
goto end

:library
D:
cd \Library
goto end

:mmm
D:
cd "\www\mmm"
goto end

:music
E:
cd \Auditorium\Music
goto end

:mp3
E:
cd "\MP3 Sorting Area"
goto end

:www
D:
cd "\www"
goto end

:scripts
E:
cd "\scripts"
goto end

:webshots
E:
cd "\Web-Site Series\webshots.com user galleries"
goto end

:end
