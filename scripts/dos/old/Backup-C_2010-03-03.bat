rem Copy almost everything incrementally from "C:\" to "J:\C_2010-03-03":
rem 56789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
rem      1         2         3         4         5         6         7         8         9        10        11        12
rem (max line length = 126)
redir -o D:\City-Hall\reports\C_2010-03-03_djgpp.txt -eo xxcopy C:\djgpp\    J:\C_2010-03-03\djgpp\    /e /v2 /h /kn /bi /y /r
redir -o D:\City-Hall\reports\C_2010-03-03_docum.txt -eo xxcopy C:\DOCUME~1\ J:\C_2010-03-03\Docs-Sts\ /e /v2 /h /kn /bi /y /r
redir -o D:\City-Hall\reports\C_2010-03-03_hardw.txt -eo xxcopy C:\HARDWA~1\ J:\C_2010-03-03\Hard-Res\ /e /v2 /h /kn /bi /y /r
redir -o D:\City-Hall\reports\C_2010-03-03_osres.txt -eo xxcopy C:\OS-RES~1\ J:\C_2010-03-03\OpSy-Res\ /e /v2 /h /kn /bi /y /r
redir -o D:\City-Hall\reports\C_2010-03-03_p-fil.txt -eo xxcopy C:\PROGRA~1\ J:\C_2010-03-03\Prog-Fil\ /e /v2 /h /kn /bi /y /r
redir -o D:\City-Hall\reports\C_2010-03-03_p-arc.txt -eo xxcopy C:\PROGRA~4\ J:\C_2010-03-03\Prog-Arc\ /e /v2 /h /kn /bi /y /r
redir -o D:\City-Hall\reports\C_2010-03-03_p-dat.txt -eo xxcopy C:\PROGRA~3\ J:\C_2010-03-03\Prog-Dat\ /e /v2 /h /kn /bi /y /r
redir -o D:\City-Hall\reports\C_2010-03-03_p-res.txt -eo xxcopy C:\PROGRA~2\ J:\C_2010-03-03\Prog-Res\ /e /v2 /h /kn /bi /y /r
redir -o D:\City-Hall\reports\C_2010-03-03_progr.txt -eo xxcopy C:\Programs\ J:\C_2010-03-03\Programs\ /e /v2 /h /kn /bi /y /r
redir -o D:\City-Hall\reports\C_2010-03-03_winnt.txt -eo xxcopy C:\WINNT\    J:\C_2010-03-03\WINNT\    /e /v2 /h /kn /bi /y /r
