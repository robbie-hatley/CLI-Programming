#!/usr/bin/env -S perl -CSDA

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# print-jpg-lines.pl
#
# Written by Robbie Hatley.
#
# Edit history:
# Fri Jan 01, 2021: I probably wrote this some time in 2021, but I never recorded the date.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Heavily refactored (it's now just a text filter) and reformatted titlecard.
# Sat Aug 03, 2024: Upgraded to "v5.36"; got rid of "common::sense" and "Sys::Binmode"; added "use utf8";
#                   reduced width from 120 to 110.
##############################################################################################################

use v5.36;
use utf8;

while (<>) {
   next if $_ !~ m/\S+?\.(?:jpg|jpeg|jfif|jp2)/i;
   s/^\N{BOM}//;
   s/^\s+//;
   s/\s+$//;
   s/^Window Text: //;
   s/ - .+?$//;
   say $_;
}
