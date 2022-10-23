@echo off
dir /b /a:d E:\Boys\Series\Single\00-Egg       > E:\Boys\Series\Single\unsorted-name-list.txt
dir /b /a:d E:\Boys\Series\Single\0-Fetus     >> E:\Boys\Series\Single\unsorted-name-list.txt
dir /b /a:d E:\Boys\Series\Single\1-Baby      >> E:\Boys\Series\Single\unsorted-name-list.txt
dir /b /a:d E:\Boys\Series\Single\2-Little    >> E:\Boys\Series\Single\unsorted-name-list.txt
dir /b /a:d E:\Boys\Series\Single\3-Young     >> E:\Boys\Series\Single\unsorted-name-list.txt
dir /b /a:d E:\Boys\Series\Single\4-Middie    >> E:\Boys\Series\Single\unsorted-name-list.txt
dir /b /a:d E:\Boys\Series\Single\5-Preppie   >> E:\Boys\Series\Single\unsorted-name-list.txt
dir /b /a:d E:\Boys\Series\Single\6-Teen      >> E:\Boys\Series\Single\unsorted-name-list.txt
dir /b /a:d E:\Boys\Series\Single\7-Multi-Age >> E:\Boys\Series\Single\unsorted-name-list.txt
sort < E:\Boys\Series\Single\unsorted-name-list.txt > E:\Boys\Series\Single\name-list.txt
erase E:\Boys\Series\Single\unsorted-name-list.txt
