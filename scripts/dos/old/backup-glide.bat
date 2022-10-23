@echo off
rem Backup Glide to external disk S:. Copy new files, over-write older versions of files if newer versions are on drive C:, and snip dreck, without prompting:
set today=%date:~10,4%-%date:~4,2%-%date:~7,2%
mkdir C:\D\Captain's-Den\Reports\Backups\%today%_Glide
xxcopy C:\D\Industrial-Park\Glide S:\Glide /e /v2 /h /i /bn /y /r /yy /zy /os1 /od3 /onC:\D\Captain's-Den\Reports\Backups\%today%_Glide\Stats.txt /foC:\D\Captain's-Den\Reports\Backups\%today%_Glide\Files.txt
