#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# binary-ordinals-to-text.pl
# Converts Unicode codepoints, written as space-separated hexadecimal ordinals, to Unicode text.
# For example: converts "0101101111001100 0101100011101011 0101110111011101 0111010100111010" to "富士川町".
#
# Written in 2020 by Robbie Hatley.
#
# Edit history:
# ??? ??? ??, 2020: Wrote it.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

while (<>)
{
   s/\s+$//;
   for (split / /)
   {
      if (/^[01]+$/)        {print chr oct '0b'.$_;}
      else                  {print "\x{FFFD}"     ;}
   }
}
