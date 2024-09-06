rem Copy almost everything incrementally from "D:\" to "J:\D_2010-03-03":
rem 5678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
rem      1         2         3         4         5         6         7         8         9        10        11        12
rem (max line length = 125)
redir -o E:\TempHold\Reports\D_2010-03-03_accou.txt -eo xxcopy D:\ACCOUN~1\ J:\D_2010-03-03\acctoffc\ /e /v2 /h /kn /bi /y /r
redir -o E:\TempHold\Reports\D_2010-03-03_arcad.txt -eo xxcopy D:\Arcade\   J:\D_2010-03-03\arcade__\ /e /v2 /h /kn /bi /y /r
redir -o E:\TempHold\Reports\D_2010-03-03_backu.txt -eo xxcopy D:\BACKUP~1\ J:\D_2010-03-03\back-e__\ /e /v2 /h /kn /bi /y /r
redir -o E:\TempHold\Reports\D_2010-03-03_cityh.txt -eo xxcopy D:\CITY-H~1\ J:\D_2010-03-03\cityhall\ /e /v2 /h /kn /bi /y /r
redir -o E:\TempHold\Reports\D_2010-03-03_feder.txt -eo xxcopy D:\FEDERA~1\ J:\D_2010-03-03\fedbldng\ /e /v2 /h /kn /bi /y /r
redir -o E:\TempHold\Reports\D_2010-03-03_galle.txt -eo xxcopy D:\Gallery\  J:\D_2010-03-03\gallery_\ /e /v2 /h /kn /bi /y /r
redir -o E:\TempHold\Reports\D_2010-03-03_indus.txt -eo xxcopy D:\INDUST~1\ J:\D_2010-03-03\indupark\ /e /v2 /h /kn /bi /y /r
redir -o E:\TempHold\Reports\D_2010-03-03_jobfa.txt -eo xxcopy D:\Job-Fair\ J:\D_2010-03-03\job-fair\ /e /v2 /h /kn /bi /y /r
redir -o E:\TempHold\Reports\D_2010-03-03_libra.txt -eo xxcopy D:\Library\  J:\D_2010-03-03\library_\ /e /v2 /h /kn /bi /y /r
redir -o E:\TempHold\Reports\D_2010-03-03_posto.txt -eo xxcopy D:\POST-O~1\ J:\D_2010-03-03\postoffc\ /e /v2 /h /kn /bi /y /r
redir -o E:\TempHold\Reports\D_2010-03-03_robbi.txt -eo xxcopy D:\ROBBIE~1\ J:\D_2010-03-03\robhouse\ /e /v2 /h /kn /bi /y /r
redir -o E:\TempHold\Reports\D_2010-03-03_state.txt -eo xxcopy D:\STATE-~1\ J:\D_2010-03-03\statbldg\ /e /v2 /h /kn /bi /y /r
redir -o E:\TempHold\Reports\D_2010-03-03_www__.txt -eo xxcopy D:\www\      J:\D_2010-03-03\www_____\ /e /v2 /h /kn /bi /y /r

