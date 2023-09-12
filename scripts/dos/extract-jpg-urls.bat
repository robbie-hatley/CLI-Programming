@echo off
awk -f C:\scripts\extract-jpg-urls.awk %1 | SortDup > %2
