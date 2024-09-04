#!/usr/bin/env perl

=pod

The Weekly Challenge #008-1: "First Five Perfect Numbers"
Task: Write a script that computes the first five perfect
numbers. A perfect number is an integer that is the sum of its
positive proper divisors (all divisors except itself).
See here for more info:
https://en.wikipedia.org/wiki/Perfect_number
This challenge was proposed by Laurent Rosenfeld.

Solution in Perl written by Robbie Hatley on Sun Sep 01, 2024.

=cut

use v5.00; # We don't need no stinking special features.
use Math::Prime::Util 'divisor_sum';
$"=', ';
my @perfect = ();
for ( my $integer = 1 ; scalar(@perfect) < 5 ; ++$integer ) {
   if ($integer == divisor_sum($integer) - $integer) {
      push @perfect, $integer;
      print "found perfect number $integer\n";
   }
}
print "\n";
print "The first five perfect numbers are:\n";
print "@perfect\n";
