@echo off
gcc -pedantic -Wall -Wextra -IC:/src/lib        -LC:/src/lib %1.c   -lrh -lm -o C:/bin/%1.exe
