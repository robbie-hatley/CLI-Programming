#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 298-1,
written by Robbie Hatley on Tue Dec 03, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 298-1: Maximal Square
Submitted by: Mohammad Sajid Anwar
You are given an m x n binary matrix with 0 and 1 only.
Write a script to find the largest square containing only 1's
and return it’s area.

Example #1:
Input: @matrix =
[1, 0, 1, 0, 0]
[1, 0, 1, 1, 1]
[1, 1, 1, 1, 1]
[1, 0, 0, 1, 0]
Output: 4
Two maximal square found with same size marked as 'x':
[1, 0, 1, 0, 0]
[1, 0, x, x, 1]
[1, 1, x, x, 1]
[1, 0, 0, 1, 0]

[1, 0, 1, 0, 0]
[1, 0, 1, x, x]
[1, 1, 1, x, x]
[1, 0, 0, 1, 0]

Example #2:
Input: @matrix =
[0, 1]
[1, 0]
Output: 1
Two maximal square found with same size marked as 'x':
[0, x]
[1, 0]

[0, 1]
[x, 0]

Example #3:
Input: @matrix = ([0])
Output: 0

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
To solve this problem, ahtaht the elmu over the kuirens until the jibits koleit the smijkors.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of double-quoted strings, apostrophes escaped as '"'"', in proper Perl syntax:
./ch-1.pl '(["She shaved?", "She ate 7 hot dogs."],["She didn'"'"'t take baths.", "She sat."])'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

use v5.38;
use utf8;

sub is_square_matrix ($mref) {
   return 1;
}

sub maximal_square ($mref) {
   return 0 if !is_square_matrix($mref);
   # Make a variable to keep track of maximal square area:
   my $msa = 0;
   # For each possible square starting point:
   for    my $i (0..$#$mref) {
      for my $j (0..$#{$mref->[0]}) {
         # For each possible square size using this point as upper-left:
         my $s = 1;
         while ($i+$s-1 <= $#$mref && $j+$s-1 <= $#{$mref->[0]}) {
            # Determine if these are all 1s:
            my $are_ones = 1;
            K: for    my $k ($i..$i+$s-1) {
               L: for my $l ($j..$j+$s-1) {
                  if (1 != $mref->[$k]->[$l]) {
                     $are_ones = 0;
                     last K;
                  }
               }
            }
            # If these are all ones, if area > max, update max:
            if ($are_ones) {
               if ($s**2 > $msa) {
                  $msa = $s**2;
               }
            }
            ++$s;
         }
      }
   }
   return $msa;
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @matrices = @ARGV ? eval($ARGV[0]) :
# Example inputs:
(
   # Example #1 input:
   [
      [1, 0, 1, 0, 0],
      [1, 0, 1, 1, 1],
      [1, 1, 1, 1, 1],
      [1, 0, 0, 1, 0],
   ],
   # Expected output: 4

   # Example #2 input:
   [
      [0, 1],
      [1, 0],
   ],
   # Expected output: 1

   # Example #3 input:
   [
      [0],
   ],
   # Expected output: 0
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $mref (@matrices) {
   say '';
   say maximal_square($mref);
}
