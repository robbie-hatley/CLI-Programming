#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# text-to-decimal-ordinals.pl
# Converts Unicode text to the Unicode codepoints of its characters, as decimal ordinals.
# For example: converts "富士川町" to "23500 22763 24029 30010".
#
# Written by Robbie Hatley.
#
# Edit history:
# Fri Mar 18, 2022: Wrote it.
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
      printf("%d ", ord);
      ++$i;
      if ($i >= 10) {$i = 0; print "\n";}
   }
}
