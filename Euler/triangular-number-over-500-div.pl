#!/usr/bin/perl

# This is an 78-character-wide ASCII-encoded Perl source-code text file.
# =======|=========|=========|=========|=========|=========|=========|========

##############################################################################
# /rhe/scripts/math/triangular-number-over-500-div.perl                      #
# Finds the smallest triangular number to have 500 divisors.                 #
# Author: Robbie Hatley.                                                     #
# Edit history:                                                              #
#    Fri Feb 19, 2016 - Wrote it.                                            #
##############################################################################

use v5.022;
use strict;
use warnings;

sub NextTriangularNumber;
sub NumberOfDivisors;

# Main:
{
   my $CurrentTriangularNumber = 0;
   my $Divisors = 0;
   my $StartTime = 0;
   my $EndTime = 0;
   
   $StartTime = time();
   
   while ($Divisors <= 500)
   {
      $CurrentTriangularNumber = NextTriangularNumber;
      $Divisors = NumberOfDivisors($CurrentTriangularNumber);
      say "Triangular number $CurrentTriangularNumber has $Divisors divisors";
   }

   $EndTime = time();

   say "Start   time = ", scalar localtime $StartTime;
   say "End     time = ", scalar localtime $EndTime;
   say "Elapsed time = ", $EndTime - $StartTime, " seconds.";

   exit 0;
}

sub NextTriangularNumber
{
   state $Index    = 0;
   state $Triangle = 0;
   ++$Index;
   $Triangle += $Index;
   return $Triangle;
}

sub NumberOfDivisors
{
   my $Number = shift;

   my  $i        = 0;
   my  $Divisors = 0;

   for ( $i = 1 ; $i <= $Number ; ++$i )
   {
      if (0 == $Number % $i)
      {
         ++$Divisors;
      }
   }
   return $Divisors;
}
