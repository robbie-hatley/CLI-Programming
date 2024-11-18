#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 296-2,
written by Robbie Hatley on Mon Nov 18, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 296-2: Matchstick Square
Submitted by: Mohammad Sajid Anwar

You are given an array of integers, @ints.

Write a script to find if it is possible to make one square using the sticks as in the given array @ints where $ints[ì] is the length of ith stick.
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
To solve this problem, ahtaht the elmu over the kuirens until the jibits koleit the smijkors.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of double-quoted strings, apostrophes escaped as '"'"', in proper Perl syntax:
./ch-2.pl '(["She shaved?", "She ate 7 hot dogs."],["She didn'"'"'t take baths.", "She sat."])'

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
