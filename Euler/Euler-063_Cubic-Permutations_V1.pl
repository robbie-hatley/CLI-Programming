#!/usr/bin/env -S perl -CSDA

=pod

Euler-063_Cubic-Permutations.pl

The cube 41063625 (345³), can be permuted to produce two other cubes: 56623104 (384³) and 66430125 (405³).
In fact, 41063625 is the smallest cube which has exactly three permutations of its digits which are also cube.

Find the smallest cube for which exactly five permutations of its digits are cube.

=cut

# === PRAGMAS AND MODULES: ===================================================================================

use v5.38;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

use Math::Combinatorics;

# === VARIABLES: =============================================================================================

my %cubes; ++$cubes{$_**3} for 5..10000;
#say for sort {$a<=>$b} keys %cubes;
#exit;
# === SUBROUTINES: ===========================================================================================

# Print the cubes from our list which have five cubic permutations:
sub five_cubic_permutations {
   for my $cube (sort {$a<=>$b} keys %cubes) {
      my $cp = 0;
      my @digits = split //, $cube;
      my @permutations = permute @digits;
      for my $permutation (@permutations) {
         my $number = 0 + join('', @$permutation);
         $cubes{$number} and ++$cp;
      }
      5 == $cp and say $cube;
      #say "cube = $cube   cubic permutations = $cp";
   }
}

# === MAIN BODY OF PROGRAM: ==================================================================================

five_cubic_permutations;
