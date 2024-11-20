#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 296-2,
written by Robbie Hatley on Tue Nov 19, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 296-2: Matchstick Square
Submitted by: Mohammad Sajid Anwar
You are given an array of integers, @ints. Write a script to
find if it is possible to make one square using the sticks as in
the given array @ints where $ints[i] is the length of ith stick.

Example 1
Input: @ints = (1, 2, 2, 2, 1)
Output: true
Top: $ints[1] = 2
Bottom: $ints[2] = 2
Left: $ints[3] = 2
Right: $ints[0] and $ints[4] = 2

Example 2
Input: @ints = (2, 2, 2, 4)
Output: false

Example 3
Input: @ints = (2, 2, 2, 2, 4)
Output: false

Example 4
Input: @ints = (3, 4, 1, 4, 3, 1)
Output: true

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
This problem essentially asks if a set of integers can be partitioned into 4 partitions with the sums of the
integers in the 4 partitions being equal. I can envision ways of doing this involving imposing segmentation
patterns onto permutations, but those are going to have very-high big-O. Better will be to make a recursive
subroutine that generates all size-m non-empty partitions of a set of n elements. It should ensure that the
size of each partition is >= the size of the partition to its right in order to minimize (but not eliminate)
duplication of partitionings. I'll this use this subroutine to make all 4-partitions of our set of sticks,
and see if any of those partitionings have all 4 partitions summing equally.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of positive integers, in proper Perl syntax, like so:
./ch-2.pl '([1,2,3,4,5,6,7],[1,2,3,4,5,6,8])'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, VARS, AND SUBS:

   use v5.36;
   use List::Util qw( sum0 all );
   use Algorithm::Combinatorics qw( partitions );
   $"=', ';

   # Can we make a square out of a pile of sticks?
   sub square ($aref) {
      my @partitionings = partitions($aref,4);
      foreach my $partitioning (@partitionings) {
         if (all {sum0(@{$$partitioning[0]}) == sum0(@$_)} @$partitioning) {
            say 'I can make a square from this partitioning of the given array:';
            say join(', ', map {'['."@$_".']'} @$partitioning);
            return;
         }
      }
      say 'Sorry, I couldn\'t make a square from that array.';
      return;
   }

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) :
# Example inputs:
(
   [1, 2, 2, 2, 1],    # Expected output: true
   [2, 2, 2, 4],       # Expected output: false
   [2, 2, 2, 2, 4],    # Expected output: false
   [3, 4, 1, 4, 3, 1], # Expected output: true
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
for my $aref (@arrays) {
   say '';
   say "Array = [@$aref]";
   square($aref);
}