#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 121-2,
written by Robbie Hatley on Xxx Xxx xx, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 121-2: The Travelling Salesman
Submitted by: Jorg Sommrey
You are given a NxN matrix containing the distances between
N cities. Write a script to find a round trip of minimum length
visiting all N cities exactly once and returning to the start.

Example #1:
Matrix: [0, 5, 2, 7]
[5, 0, 5, 3]
[3, 1, 0, 6]
[4, 5, 4, 0]
Output:
length = 10
tour = (0 2 1 3 0)

BONUS 1: For a given number N, create a random NxN distance
         matrix and find a solution for this matrix.
BONUS 2: Find a solution for a random matrix of size 15x15 or
         20x20.

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
say 'This program is non-yet-implemented.';
for my $aref (@arrays) {
}
