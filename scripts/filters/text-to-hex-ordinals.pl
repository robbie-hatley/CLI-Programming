#!/usr/bin/env -S perl -CSDA

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# text-to-hex-ordinals.pl
# Converts Unicode text to the Unicode codepoints of its characters, as hexadecimal ordinals.
# For example: converts "富士川町" to "5BCC 58EB 5DDD 753A".
#
# Written in 2020 by Robbie Hatley.
#
# Edit history:
# Wed Jan 01, 2020: I probably wrote this in 2020, but I forgot to write down the date.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
# Sun Aug 04, 2024: Reduced width from 120 to 110. Upgraded from "v5.32" to "v5.36". Added "use utf8".
#                   Got rid of "common::sense" and "Sys::Binmode".
##############################################################################################################

use v5.36;
use utf8;

use POSIX 'ceil';

my $i = 0;
while (<>)
{
   for (split //)
   {
      my $ord = ord;
      my $len = 2 * int ceil (log($ord)/log(256));
      printf("%0${len}X ", $ord);
      ++$i;
      if ($i >= 16) {$i = 0; print "\n";}
   }
}
