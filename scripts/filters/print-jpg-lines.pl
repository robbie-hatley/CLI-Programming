#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# print-jpg-lines.pl
#
# Written by Robbie Hatley (date unknown).
#
# Edit history:
# ??? ??? ??, ????: Wrote it.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Heavily refactored (it's now just a text filter) and reformatted titlecard.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

while (<>)
{
   next if $_ !~ m/\.(?:jpg|jpeg|jfif|jp2) /i;
   s/^\N{BOM}//;
   s/^\s+//;
   s/\s+$//;
   s/^Window Text: //;
   s/ - .+?$//;
   say $_;
}
