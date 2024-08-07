#!/usr/bin/bash
# extract-urls-from-directory.sh
/usr/bin/grep -PsI --color=never 'https?://' */* | substitute.pl '=22' ' ' 'g' | extract-urls.pl | sort | uniq
