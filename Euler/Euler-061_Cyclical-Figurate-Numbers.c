// Euler-061_Cyclical-Figurate-Numbers.c
#include <stdlib.h>
#include <stdio.h>

/*
Triangle, square, pentagonal, hexagonal, heptagonal, and
octagonal numbers are all figurate (polygonal) numbers
and are generated by the following formulae:
Triangle    P3,n=n(n+1)/2   1, 3,  6, 10, 15, ...
Square      P4,n=n^2        1, 4,  9, 16, 25, ...
Pentagonal  P5,n=n(3n-1)/2  1, 5, 12, 22, 35, ...
Hexagonal   P6,n=n(2n-1)    1, 6, 15, 28, 45, ...
Heptagonal  P7,n=n(5n-3)/2  1, 7, 18, 34, 55, ...
Octagonal   P8,n=n(3n-2)    1, 8, 21, 40, 65, ...

The ordered set of three 4-digit numbers: 8128, 2882, 8281,
has three interesting properties.

   1. The set is cyclic, in that the last two digits of each
      number is the first two digits of the next number
      (including the last number with the first).

   2. Each polygonal type: triangle (P3,127=8128), square
      (P4,91=8281), and pentagonal (P5,44=2882), is represented
      by a different number in the set.

   3. This is the only set of 4-digit numbers with this property.

Find the sum of the only ordered set of six cyclic 4-digit
numbers for which each polygonal type: triangle, square,
pentagonal, hexagonal, heptagonal, and octagonal, is
represented by a different number in the set.
*/


# Subroutines for generating triangle, square, pentagon, hexagon, heptagon, octagon numbers:
int P3 (int n) { return n*(n+1)/2   ; }
int P4 (int n) { return n*n         ; }
int P5 (int n) { return n*(3*n-1)/2 ; }
int P6 (int n) { return n*(2*n-1)   ; }
int P7 (int n) { return n*(5*n-3)/2 ; }
int P8 (int n) { return n*(3*n-2)   ; }

# Subroutines for extracting the first 2 or last 2 digits of a 4-digit positive integer:
sub first_two ($x) {return int $x / 100}
sub last_two  ($x) {return     $x % 100}

# Subroutine for determining whether a given ordered sextet of 4-digit positive integers is cyclic:
sub is_cyclic ($aref) {
   return 0 if last_two($aref->[0]) != first_two($aref->[1]);
   return 0 if last_two($aref->[1]) != first_two($aref->[2]);
   return 0 if last_two($aref->[2]) != first_two($aref->[3]);
   return 0 if last_two($aref->[3]) != first_two($aref->[4]);
   return 0 if last_two($aref->[4]) != first_two($aref->[5]);
   return 0 if last_two($aref->[5]) != first_two($aref->[0]);
   return 1;
}

# References to arrays of triangle, square, pentagon, hexagon, heptagon, octagon numbers:
my @Numbers = ([],[],[],[],[],[]);

# Fill arrays of triangle, square, pentagon, hexagon, heptagon, octagon numbers:
for ( my $i = 10 ; $i <= 1000 ; ++$i ) {
   my $p3 = P3($i); if ($p3 >= 1000 && $p3 <= 9999 && '0' ne substr($p3,2,1)) {push @{$Numbers[0]}, $p3}
   my $p4 = P4($i); if ($p4 >= 1000 && $p4 <= 9999 && '0' ne substr($p4,2,1)) {push @{$Numbers[1]}, $p4}
   my $p5 = P5($i); if ($p5 >= 1000 && $p5 <= 9999 && '0' ne substr($p5,2,1)) {push @{$Numbers[2]}, $p5}
   my $p6 = P6($i); if ($p6 >= 1000 && $p6 <= 9999 && '0' ne substr($p6,2,1)) {push @{$Numbers[3]}, $p6}
   my $p7 = P7($i); if ($p7 >= 1000 && $p7 <= 9999 && '0' ne substr($p7,2,1)) {push @{$Numbers[4]}, $p7}
   my $p8 = P8($i); if ($p8 >= 1000 && $p8 <= 9999 && '0' ne substr($p8,2,1)) {push @{$Numbers[5]}, $p8}
}

say '';
say 'List of 4-digit triangle numbers:';
say $_ for @{$Numbers[0]};

say '';
say 'List of 4-digit square numbers:';
say $_ for @{$Numbers[1]};

say '';
say 'List of 4-digit pentagon numbers:';
say $_ for @{$Numbers[2]};

say '';
say 'List of 4-digit hexagon numbers:';
say $_ for @{$Numbers[3]};

say '';
say 'List of 4-digit heptagon numbers:';
say $_ for @{$Numbers[4]};

say '';
say 'List of 4-digit octagon numbers:';
say $_ for @{$Numbers[5]};

say '';

for my $p3 (@{$Numbers[0]}) {
   say "Triangle number: $p3";
   for my $p4 (@{$Numbers[1]}) {
      for my $p5 (@{$Numbers[2]}) {
         for my $p6 (@{$Numbers[3]}) {
            for my $p7 (@{$Numbers[4]}) {
               for my $p8 (@{$Numbers[5]}) {
                  my @permutations = permute($p3, $p4, $p5, $p6, $p7, $p8);
                  for my $permutation (@permutations) {
                     if ( is_cyclic($permutation) ) {
                        say "FOUND CYCLIC PERMUTATION: ", join(', ', @$permutation);
                     }
                  }
               }
            }
         }
      }
   }
}

