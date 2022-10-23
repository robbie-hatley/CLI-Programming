grep 'killed' 'C:\Programs\Games\Nethack\logfile' | awk -F killed '{print"killed"$NF}' | sort | uniq | sort
