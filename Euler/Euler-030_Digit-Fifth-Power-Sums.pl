#! /usr/bin/perl

###############################################################################
# /rhe/Euler/Euler-030_Digit-Fifth-Power-Sums.perl                            #
# Finds the sum of all positive integers for which the sum of the fifth       #
# powers of the decimal digits is equal to the value of the number.           #
# Author: Robbie Hatley                                                       #
# Edit history:                                                               #
#    Mon Jan 15, 2018: Wrote it.                                              #
###############################################################################

use 5.026_001;
use strict;
use warnings;
use List::Util qw( sum sum0 );

my $x;
my @Winners;
my $sum;

# No 1-digit numbers need be considered, because they don't have "sums of
# fifth powers of digits". And no 7-digit numbers (or bigger) need be 
# considered, because the largest possible 7-digit number, 9999999, only has
# 413343 as the sum of the fifth powers of its digits, and that's only a
# SIX-digit number. So we need only check 10-999999.
for ( $x = 10 ; $x <= 999999 ; ++$x )
{
   push @Winners, $x if $x == sum map {$_**5} split //, $x;
}
say for @Winners;
$sum = sum @Winners;
say "Sum = $sum";
