#!/usr/bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# padgen96.pl
# Generates one-time pads for my "rot48.pl" script.
# See the print_help_msg subroutine for description and instructions.
# Edit history:
#    Sat Jan 10, 2015: Wrote it.
#    Fri Jul 17, 2015: Cleanup (comments, POD, etc).
#    Wed Jan 10, 2018: use v5.026, and improved comments.
#    Sat May 19, 2018: use v5.20, dramatically improved instructions, and
#                      moved instructions to print_help_msg().
#    Tue Sep 08, 2020: use v5.30
########################################################################################################################

use v5.32;
use utf8;
use Sys::Binmode;
use experimental 'switch';
use strict;
use warnings;
use warnings FATAL => "utf8";

sub print_help_msg;

# main:
{
   if (@ARGV == 1 && ($ARGV[0] eq '-h' || $ARGV[0] eq '--help'))
   {
      print_help_msg();
      exit;
   }

   if (@ARGV != 1 || $ARGV[0] < 10 || $ARGV[0] > 10000)
   {
      warn("Error: padgen96.pl takes 1 argument, which must be an integer\n".
           "in the 10-10000 range.\n");
      print_help_msg();
      exit;
   }

   my @Charset = map chr, (9, 32..126);
   for (1..$ARGV[0])
   {
      my @TempCharset = @Charset;
      my @PermCharset;
      while (@TempCharset)
      {
         push(@PermCharset, splice(@TempCharset, rand(@TempCharset), 1));
      }
      print((join '', @PermCharset), "\n");
   }
   exit;
}


sub print_help_msg
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "PadGen96", a pad generator for "Rot48", which is
   an unbreakable cipher by Robbie Hatley.

   PadGen96 writes to standard output a set of permutations of the
   96-character character set consisting of the 94 glyphical (black-mark, not
   white-space or control) characters of the standard 101-key or 104-key keyboard,
   plus horizontal tab (decimal 9) and space (decimal 32).  Each such permutation
   is written on its own line, with a newline character on the end.

   PadGen96 takes exactly 1 argument, which must be an integer in the range
   10-10000, indicating the number of permutations to write. If the number
   of arguments is not 1, or if the argument is not an integer in the
   10-10000 range, PadGen96 will abort.

   The purpose of this program is to generate one-time pads for my Rot48
   program, which is an invertible, unbreakable cipher. These one-time pads
   are not to be confused with "keys", which in the context of rot48 are
   the integers 0 through n-1 (for some n) separated by commas. If a pad has,
   say, 1000 lines (generated by "padgen96.pl 1000 > pad96-1000_73.txt"
   it should be used in conjunction with an order-1000 key, generated by
   one of these programs:
   perm-keygen.pl 1000 > key1000-73.txt
   rand-keygen.pl 1000 > key1000-73.txt
   That would be suitable for use with a message of up to 1000 characters if
   total unbreakability is needed. (Longer messages could be encoded, but the
   unbreakability would then drop below 100%.) Each pad should use its own key
   to maintain complete unbreakability.

   For further information on Rot48 and its pads and keys, type:
   rot48.pl --help

   Cheers,
   Robbie Hatley,
   Programmer
   END_OF_HELP
   return 1;
}
