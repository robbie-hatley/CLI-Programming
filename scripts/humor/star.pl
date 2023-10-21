#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file
# with hard Unix line breaks ("\x0A").

########################################################################
# star.pl                                                              #
# Prints a star.                                                       #
# Written by unknown person at unknown time.                           #
# Found at "https://www.onlinegdb.com/BVM9e6KVV3".                     #
# Edit history:                                                        #
# Sat Jun 05, 2021: transposed it from obfuscated Perl to clean Perl.  #
########################################################################

use v5.32;

for my $y (-8..8)
{
   for my $x (-8..8)
   {
      (abs($x) > abs($y) - 5) && (abs($x) <      5     )
      ||
      (abs($y) <       5    ) && (abs($x) < 5 + abs($y))
      ? print "*"
      : print " "
   }
   print"\n"
}
