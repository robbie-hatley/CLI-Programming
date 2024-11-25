#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 297-2,
written by Robbie Hatley on Mon Nov 25, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 297-2: Semi-Ordered Permutation
Submitted by: Mohammad Sajid Anwar

You are given permutation of $n integers, @ints.

Write a script to find the minimum number of swaps needed to make the @ints a semi-ordered permutation.

A permutation is a sequence of integers from 1 to n of length n containing  each number exactly once.
A permutation is called semi-ordered if the first number is 1 and the last number equals n.

You are ONLY allowed to pick adjacent elements and swap them.
Example 1

Input: @ints = (2, 1, 4, 3)
Output: 2

Swap 2 <=> 1 => (1, 2, 4, 3)
Swap 4 <=> 3 => (1, 2, 3, 4)

Example 2

Input: @ints = (2, 4, 1, 3)
Output: 3

Swap 4 <=> 1 => (2, 1, 4, 3)
Swap 2 <=> 1 => (1, 2, 4, 3)
Swap 4 <=> 3 => (1, 2, 3, 4)

Example 3

Input: @ints = (1, 3, 2, 4, 5)
Output: 0

Already a semi-ordered permutation.


--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
This one is much easier than the first, because it's just a matter of following instructions, and there is
only one way to perform the task. (TIEOWTDI=There Is Exactly One Way To Do It.) So we'll just swap til done.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of positive integers, with each inner array being a permutation of the sequence
1..n for sum positive-integer n, in proper Perl syntax, like so:
./ch-2.pl '([1,3,5,4,2],[5,2,3,6,4,1])'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

use v5.38;
use utf8;
sub asdf ($x, $y) {
   -2.73*$x + 6.83*$y;
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) : ([2.61,-8.43],[6.32,84.98]);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $aref (@arrays) {
   say '';
   my $x = $aref->[0];
   my $y = $aref->[1];
   my $z = asdf($x, $y);
   say "x = $x";
   say "y = $y";
   say "z = $z";
}
