#!/usr/bin/bash
raw=`df -l -BGB`
usage=`echo -e "$raw" | awk '/^Filesystem/{print}/^\/dev\/nvme0n1p2/{print}/^\/dev\/nvme1n1p1/{print}'`
max=`echo -e "$usage" | awk '/[0-9]+%/{print $5}' | cut -d "%" -s -f 1 | sort -n | tail -n 1`
message="usage=\n$usage\n\nmax usage = \n$max%\n"
mfile="/home/aragorn/.temp/email/Storage-Usage-Message.txt"
lfile="/home/aragorn/Data/Celephais/Captain’s-Den/Reports/Storage-Usage/Storage-Usage.log"
from="lonewolf@well.com"
to="lonewolf@well.com"
server="iris.well.com:25"
user="lonewolf"
pword="s/harm/protect/ig;"
fqdn="172.117.28.174"
echo -e "$message"
echo -e "$message" >  "$mfile"
echo -e "$message" >> "$lfile"

i=0
subject=''
if [ "$max" -ge 80 ]
   then
      subject='Disk Usage: Getting Full!'
   else
      subject='Disk Usage: Sufficient Space'
fi
sendEmail -f $from -t $to -u $subject -s $server -xu $user -xp $pword -o tls=no < $mfile

exit
