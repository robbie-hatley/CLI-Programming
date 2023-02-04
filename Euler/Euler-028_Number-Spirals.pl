#! /usr/bin/perl
###############################################################################
# /rhe/Euler/Euler-028_Number-Spirals.perl                                    #
# Prints sum of diagonal numbers in a 1001x1001 number spiral.                #
# Author: Robbie Hatley                                                       #
# Edit history:                                                               #
#    Sun Jan 14, 2018: Wrote it.                                              #
###############################################################################
use 5.026_001;
use strict;
use warnings;
my $sum;
my $number;
my $side_size;
my $side_cntr;
my $start_time;
my $elapsed_time;
$start_time = times();
$sum    = 1;
$number = 1;
for ( $side_size = 2 ; $side_size <= 1000 ; $side_size += 2 )
{
   for ( $side_cntr = 0 ; $side_cntr < 4 ; ++$side_cntr )
   {
      $number += $side_size;
      $sum    += $number;
   }
}
say $sum;
$elapsed_time = times() - $start_time;
printf("Elapsed time = %.3f seconds.\n", $elapsed_time);
