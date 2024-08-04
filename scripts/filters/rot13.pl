#!/usr/bin/env -S perl -CSDA

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# /rhe/scripts/util/rot13.pl
# Performs ROT13 obfuscation on text.
#
# Written by Robbie Hatley circa Friday July 4, 2014.
#
# Edit history:
# Fri Jul 04, 2014: Wrote it. (Date is a wild guess.)
# Fri Jul 17, 2015: Made minor improvements.
# Fri Feb 05, 2016: Cleaned up formatting.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
# Sun Aug 04, 2024: Reduced width from 120 to 110. Upgraded from "v5.32" to "v5.36". Added "use utf8".
#                   Got rid of "common::sense" and "Sys::Binmode".
##############################################################################################################

use v5.36;
use utf8;

while(<>) {
   tr/A-Za-z/N-ZA-Mn-za-m/; # rot13
   print;
}
