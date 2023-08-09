#! /usr/bin/perl

###############################################################################
# /rhe/Euler/Euler-029_Unique-Powers.perl                                     #
# Prints of unique values of a^b for a 2-100 and b 2-100.                     #
# Author: Robbie Hatley                                                       #
# Edit history:                                                               #
#    Sun Jan 14, 2018: Wrote it.                                              #
###############################################################################

use 5.026_001;
use strict;
use warnings;
use bigint;
use List::Util qw(uniqstr);
Math::BigInt::accuracy(250);

our @Powers;
my $x;
my $y;

for ( $x = 2 ; $x <= 100 ; ++$x )
{
   for ( $y = 2 ; $y <= 100 ; ++$y )
   {
      push @Powers, $x**$y;
   }
}

say "Unique Powers = ", scalar uniqstr sort {$::a cmp $::b} @Powers;
