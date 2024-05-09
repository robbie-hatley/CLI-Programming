#!/usr/bin/env -S perl -CSDA

=pod

Euler-063_Cubic-Permutations_V2.pl

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

#use bigint l => 'GMP';
use Math::Combinatorics;

# === VARIABLES: =============================================================================================

my %cubes; ++$cubes{$_**3} for 5..10000;
my %seen;

# === SUBROUTINES: ===========================================================================================

# Print the cubes from our list which have five cubic permutations:
sub five_cubic_permutations {
   for my $cube (sort {$a<=>$b} keys %cubes) {
      next if $seen{$cube};
      my $cp = 0;
      my @digits = split //, $cube;
      my @permutations = permute @digits;
      for my $permutation (@permutations) {
         my $number = join('', @$permutation);
         next if '0' eq substr($number, 0, 1);
         !$seen{$number} and ++$seen{$number};
         $cubes{$number} and ++$cp;
      }
      say "cube = $cube   cubic permutations = $cp";
      5 == $cp and say "Cube $cube has exactly 5 cubic permutations!";
   }
}

# === MAIN BODY OF PROGRAM: ==================================================================================

five_cubic_permutations;
