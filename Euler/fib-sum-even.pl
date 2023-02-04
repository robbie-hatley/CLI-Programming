#!/usr/bin/perl

# This is an 79-character-wide utf8-encoded Perl source-code text file.
# ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========

###############################################################################
# /rhe/scripts/math/fib-sum-even.perl
# Prints the sum of all even fibonacci numbers less than a given upper limit.
# Edit history:
#    Sun Feb 14, 2016 - Wrote it.
###############################################################################

use v5.022;
use strict;
use warnings;

our $limit = $ARGV[0];

MAIN:
{
   my $a   = 1;
   my $b   = 1;
   my $c   = 0;
   my $sum = 0;

   while ( 1 )
   {
      $c = $a + $b;
      last if $c > $limit;
      $sum += $c if 0 == $c % 2;
      $a = $b;
      $b = $c;
   }
   say $sum;
   exit 0;
}
