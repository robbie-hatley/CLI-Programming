@echo off
gpp -pedantic -Wall -Wextra -IE:/src/lib -O3    -LE:/src/lib %1.cpp -lrh -lm -o E:/bin/%1.exe
