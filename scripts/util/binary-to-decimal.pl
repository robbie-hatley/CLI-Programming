#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# binary-to-decimal.pl
# Converts strings of binary numbers, such as "00101001 01 100 011010 1010100 010 101", to decimal representations
# ("41 1 4 26 84 2 5" in the case of that particular example).
#
# Input is via STDIN, redirect, pipe, or file-name arguments.
#
# Output is to STDOUT.
#
# Written by Robbie Hatley on (date unknown).
#
# Edit history:
# ??? ??? ??, ????: Wrote it.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode";
#                   changed name from "ascii-to-decimal.pl" to "binary-to-decimal.pl"; clarified what this program does;
#                   added newline to end of each printed line; and explicitly specified STDOUT as stream to print to.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

while(<>)
{
   s/^\s+//; s/\s+$//;
   for my $bin (split / /, $_)
   {
      if ( $bin =~ m/^[01]+$/ )
      {
         printf STDOUT "%d ", oct('0b'.$bin);
      }
      else
      {
         print STDOUT "\x{FFFD} ";
      }
   }
   print STDOUT "\n";
}
