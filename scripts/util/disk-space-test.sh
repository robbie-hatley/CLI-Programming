#! /bin/bash
usage=`df -l -BGB`
max=`echo -e "$usage" | awk '{print $5}' | grep -v Use \
    | cut -d "%" -s -f 1 | sort -n | tail -n 1`
message="\n\nusage=\n$usage\n\nmax usage = $max%\n"
echo -e "$message"
# echo -e "$message" >  /home/temp/email/xJnWoiYh.txt
# echo -e "$message" >> "/D/Captain's-Den/Reports/DiskUse/DiskUse.txt"
# i=0
# subject=''
# if [ "$max" -ge 80 ]
#    then
#       subject='Disk Usage: Getting Full!'
#    else
#       subject='Disk Usage: Sufficient Space'
# fi
# until email -s "$subject" lonewolf@well.com < /home/temp/email/xJnWoiYh.txt ; do
#    i=$((++i))
#    echo "Attempt $i failed."
#    if [ $i -ge 5 ]
#       then
#          break
#    fi
#    sleep 7
# done
# unlink /home/temp/email/xJnWoiYh.txt
# exit
