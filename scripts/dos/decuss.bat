@echo off
if exist cusslog.txt erase cusslog.txt
if exist C:\TEMP\cusslog.tmp erase C:\TEMP\cusslog.tmp
redir -o  C:\TEMP\cusslog.tmp grep -r 'fuck' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'suck' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'felat' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'cuni' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'sex' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'penis' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'dick' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'schlong' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'vagina' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'vulva' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'cunt' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'piss' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'shit' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'child' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'boy' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'girl' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'tyke' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'pedo' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'paedo' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'mother-fu' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'mother fu' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'goddam' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'bastard' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'bitch' *
redir -oa C:\TEMP\cusslog.tmp grep -r 'asshole' *
sort < C:\TEMP\cusslog.tmp > cusslog.txt
erase C:\TEMP\cusslog.tmp
