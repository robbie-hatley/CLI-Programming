#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 270-1,
written by Robbie Hatley on Tue May 28, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task xxx-1: Maximum Ones
Submitted by: Mohammad Sajid Anwar
You are given a m x n binary matrix. Write a script to return the
row number containing maximum ones. In case of more than one row,
then return smallest row number.

   # Example 1 input:
   [
      [0, 1],
      [1, 0],
   ],
   # Expected output: 1
   (Row 1 and Row 2 have the same number of ones, so return 1.)

   # Example 2 input:
   [
      [0, 0, 0],
      [1, 0, 1],
   ],
   # Expected output: 2
   (Row 2 has the maximum ones, so return 2.)

   # Example 3 input:
   [
      [0, 0],
      [1, 1],
      [0, 0],
   ],
   # Expected output: 2
   (Row 2 have the maximum ones, so return 2.)


--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
I'll attack this problem by sorting the row indices in reverse order of row sums,
then returning 1 + 0th element of sorted indices.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of binary matrices, in proper Perl syntax, like so:
./ch-1.pl '([[0,0,1],[1,0,0],[0,0,0]],[[0,1,0],[1,0,0],[1,0,1]])'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

   use v5.38;
   use List::Util 'sum0';
   $" = ', ';

   # Is a given scalar a ref to an m x n binary matrix?
   sub is_nonempty_binary_matrix ($matref) {
      'ARRAY' ne ref $matref                         and return 0; # $matref is not a ref to a matrix?
      scalar(@$matref) < 1                           and return 0; # Matrix has no rows?
      for my $rowref (@$matref) {
         'ARRAY' ne ref $rowref                      and return 0; # Row is not an array ref?
         scalar(@$rowref) < 1                        and return 0; # Row is empty?
         scalar(@$rowref) != scalar(@{$$matref[0]})  and return 0; # Matrix is not rectangular?
         for my $element (@$rowref) {
            '0' ne $element && '1' ne $element       and return 0; # Is any element not binary?
         }
      }
      return 1; # Rectangular binary matrix.
   }

   # Return the sum of the 1s of a row of a binary matrix:
   sub row_sum ($matref, $i) {
      return sum0 @{$$matref[$i]};
   }

   # Return the least 1-based index of the row of a binary matrix having max 1s:
   sub max_ones ($matref) {
      my @sorted_indices = sort {row_sum($matref, $b) <=> row_sum($matref, $a) || $a <=> $b} 0..$#$matref;
      return(1 + $sorted_indices[0]);
   }

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @matrices = @ARGV ? eval($ARGV[0]) :
(
   # Example 1 input:
   [
      [0, 1],
      [1, 0],
   ],
   # Expected output: 1

   # Example 2 input:
   [
      [0, 0, 0],
      [1, 0, 1],
   ],
   # Expected output: 2

   # Example 3 input:
   [
      [0, 0],
      [1, 1],
      [0, 0],
   ],
   # Expected output: 2
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
for my $matref (@matrices) {
   say '';
   say 'Matrix:';
   say "[@$_]" for @$matref;
   !is_nonempty_binary_matrix ($matref)
   and say 'Error: Matrix is not a non-empty binary matrix.'
   and say 'Moving on to next matrix.'
   and next;
   say 'First row # with max ones = ', max_ones($matref);
}
