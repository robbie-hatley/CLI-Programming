#!/usr/bin/perl

# This is an 79-character-wide ASCII-encoded Perl source-code text file.
# =======|=========|=========|=========|=========|=========|=========|=========

###############################################################################
# /rhe/scripts/Euler/E18_number-triangle-max-sum-path.perl
# This program prints the maximum sum of numbers traversed going downward in
# a given triangle.
# Author: Robbie Hatley
# Edit history:
#    Mon Feb 22, 2016 - Wrote it.
###############################################################################

use v5.022;
use strict;
use warnings;

our $triangle = 
[
[75],
[95,64],
[17,47,82],
[18,35,87,10],
[20, 4,82,47,65],
[19, 1,23,75, 3,34],
[88, 2,77,73, 7,63,67],
[99,65, 4,28, 6,16,70,92],
[41,41,26,56,83,40,80,70,33],
[41,48,72,33,47,32,37,16,94,29],
[53,71,44,65,25,43,91,52,97,51,14],
[70,11,33,28,77,73,17,78,39,68,17,57],
[91,71,52,38,17,14,91,43,58,50,27,29,48],
[63,66, 4,68,89,53,67,30,73,16,69,87,40,31],
[ 4,62,98,27,23, 9,70,98,73,93,38,53,60, 4,23],
];

our $max = 
[
[0],
[0,0],
[0,0,0],
[0,0,0,0],
[0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
];

sub max ($$)
{
   my $a = shift;
   my $b = shift;
   if ($b > $a) {return $b;}
   else         {return $a;}
}

# main
{
   foreach my $row ( reverse 0 .. $#{$triangle} )
   {
      # Copy current triangle row to current max row:
      foreach my $col ( 0 .. $#{$triangle->[$row]} )
      {
         $max->[$row]->[$col] = $triangle->[$row]->[$col];
      }
      
      # If this is not the bottom row, also add max of the two maxes below 
      # each max cell to each max cell:
      if ( $row != $#{$triangle} )
      {
         foreach my $col ( 0 .. $#{$triangle->[$row]} )
         {
            $max->[$row]->[$col] += max($max->[$row+1]->[$col], $max->[$row+1]->[$col+1]);
         }
      }

      # For debugging purposes, recite the coordinates, triangle values, 
      # and max values of current row:
      foreach my $col ( 0 .. $#{$triangle->[$row]} )
      {
         say "y=$row, x=$col, t=$triangle->[$row]->[$col], m=$max->[$row]->[$col]";
      }
   }

   # At this point the top cell of $max should contain the maximum path sum:
   say "Maximum path sum = $max->[0]->[0]";

   # We're done, so scram:
   exit 0;
}
