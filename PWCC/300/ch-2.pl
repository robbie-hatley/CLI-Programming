#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 300-2,
written by Robbie Hatley on Mon Dec 16, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 300-2: Nested Arrays
Submitted by: Mohammad Sajid Anwar
Description re-written by Robbie Hatley for clarity:
You are given an array of integers of length n containing a
permutation of the integers in the range [0,n-1]. Write a script
to build the n sets "set[i]" (0 <= i <= n-1) such that
set[i] = {ints[i], ints[ints[i]], ints[ints[ints[i]]], etc}.
For each set[i], stop adding elements right before a duplicate
element occurs. Return the length of the longest set[i].

Example #1:
Input: (5, 4, 0, 3, 1, 6, 2)
Output: 4
One of the longest sets is set[0], which has length 4:
set[0] = {ints[0], ints[5], ints[6], ints[2]} = {5, 6, 2, 0}

Example #2:
Input: (0, 1, 2)
Output: 1

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
This is conceptually straightforward: Just build the n sets set[i] and see what the longest lenth is. Should
be no more complex than O(n^2) as we're building n sets with a max length of n each.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of non-negative integers, with each inner array being a permutation of (0..n-1)
for some non-negative integer n, in proper perl syntax, like so:
./ch-2.pl '([0,7,1,6,2,5,3,4],[4,7,5,6,1,3,2,0])'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

use v5.36;

# Build the n nested arrays of a given permutation of (0..n-1),
# and return the length of the longest:
sub longest_nested ($aref) {
   ;
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) : ([2.61,-8.43],[6.32,84.98]);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $aref (@arrays) {
   say '';
   my $aref = $_;
   say "Array = (@$aref)"
   my $LN = longest_nested($aref);
   say "Length of longest nested array = $LN";
}
