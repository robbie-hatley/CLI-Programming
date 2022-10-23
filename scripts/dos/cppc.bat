@echo off
gpp -pedantic -Wall -Wextra -IE:/src/lib        -LE:/src/lib %1.cpp -lrh -lm -o E:/bin/%1.exe
