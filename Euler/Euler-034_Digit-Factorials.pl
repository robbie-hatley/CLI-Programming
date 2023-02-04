#! /usr/bin/perl
# "Euler-034_Digit-Factorials.perl"
# Finds the sum of all positive integers >9 which are equal to the sum of 
# the factorials of their digits.

use 5.026_001;
use strict;
use warnings;
use List::Util qw( sum0 );

my @Factorials = (1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880);
my @Numbers    = ();
my $i;
my $sumfac;
my $time0 = time;

# 8-digit natural numbers can't equal the sum of the factorials of their digits
# because 8*9! = 2903040, which is only 7 digits. And the problem only gets 
# worse as the number of digits increase. And 1-digit numbers don't have 
# "sums of factorials of digits". So we need only check numbers with
# 2 through 7 digits. And we need not even check all of *those*, because the
# largest possible sum of factorials of digits for a 7-digit natural number is
# 7*9! = 2540160.
for ( $i = 10 ; $i <= 2540160 ; ++$i )
{
   $sumfac = sum0 map {$Factorials[$_]} split //, $i;
   if ($i == $sumfac)
   {
      say $i;
      push @Numbers, $i;
   }
}
say "sum = ", sum0 @Numbers;
say "Elapsed time = ", time-$time0, " seconds.";
