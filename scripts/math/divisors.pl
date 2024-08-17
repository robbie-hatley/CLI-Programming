#!/usr/bin/perl

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##################################################################
# "divisors.pl"
# Prints all of the divisors of the given positive integer.
# Author: Robbie Hatley.
# Edit history:
#    Mon Apr 27, 2015 - Wrote it.
##################################################################

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

# Main:
{
   my  $i       = 0;
   my  $Number  = 0;
   my  @divs    = ();
   my  $divs    = 0;

   if (1 != scalar @ARGV) {return 666;}

   $Number = 0 + $ARGV[0];

   for ( $i = 1 ; $i <= $Number ; ++$i )
   {
      if (0 == $Number % $i)
      {
         push @divs, $i;
         ++$divs;
      }
   }
   say "$Number has $divs divisors:";
   $, = ' ';
   say @divs;
   exit 0;
}

