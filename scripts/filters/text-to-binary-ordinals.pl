#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# text-to-binary-ordinals.pl
# Converts Unicode text to the Unicode codepoints of its characters, as binary ordinals.
# For example, converts "富士川町" to "0101101111001100 0101100011101011 0101110111011101 0111010100111010".
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
use POSIX 'ceil';

my $i = 0;
while (<>)
{
   for (split //)
   {
      my $ord = ord;
      my $len = 8 * int ceil (log($ord)/log(256));
      printf("%0${len}b ", $ord);
      ++$i;
      if ($i >=  4) {$i = 0; print "\n";}
   }
}
