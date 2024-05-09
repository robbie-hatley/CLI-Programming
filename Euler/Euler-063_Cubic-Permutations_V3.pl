#!/usr/bin/env -S perl -CSDA

=pod

Euler-063_Cubic-Permutations_V2.pl

The cube 41063625 (345³), can be permuted to produce two other cubes: 56623104 (384³) and 66430125 (405³).
In fact, 41063625 is the smallest cube which has exactly three permutations of its digits which are also cube.

Find the smallest cube for which exactly five permutations of its digits are cube.

=cut

# ===== PRAGMAS AND MODULES: ===========================================

use v5.38;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

# ===== SUBROUTINES: ===================================================

# For any given non-negative integer, return a "signature" integer having the same digits in descending order:
sub signature ($x) {return 0 + join('', reverse sort split(//,$x))}

# Print smallest cube with five cubic permutations:
sub five_cubic_permutations {
   my %signs;
   my $smallest = 999999999999;
   say '';
   say 'Now generating all cubes with 3-to-12 digits and recording their signatures...';
   for my $base (5..9999) {
      my $cube = $base * $base * $base;
      my $sign = signature($cube);
           ++$signs{$sign}->[1];
      push @{$signs{$sign}->[2]}, $cube;
   }
   say '';
   say 'Now determining which signatures correspond to exactly 5 cubes....';
   for my $sign (keys %signs) {
      if (5 == $signs{$sign}->[1]) {
         for my $cube (@{$signs{$sign}->[2]}) {
            $cube < $smallest and $smallest = $cube;
         }
         say '';
         say "Found: set of 5 cubes with signature $sign:";
         say '(', join(', ', @{$signs{$sign}->[2]}), ')';
      }
   }
   say '';
   999999999999 == $smallest and say 'No permutive 5-sets of cubes found in 3-12-digit range.'
   or say "The smallest 3-to-12-digit cube with five cubic permutations is $smallest";
}

# ======== MAIN BODY OF PROGRAM: =======================================

five_cubic_permutations;
