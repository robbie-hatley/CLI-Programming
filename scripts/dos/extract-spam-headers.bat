@echo off
erase "C:\sysadmin\Internet\email\spam\spam.txt"
sed -f "C:\scripts\extract-email-headers.sed" "D:\OE Message Archive\Unfiltered Spam.dbx" > "C:\TEMP\spam.tmp"
sortdup < "C:\TEMP\spam.tmp" > "C:\sysadmin\Internet\email\spam\spam.txt"
erase "C:\TEMP\spam.tmp"
