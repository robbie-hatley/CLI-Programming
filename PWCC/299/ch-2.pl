#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 299-2,
written by Robbie Hatley on Mon Dec 09, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 299-2: Word Search
Submitted by: Mohammad Sajid Anwar
You are given a grid of characters and a string. Write a script
to determine whether the given string can be found in the given
grid of characters. You may start anywhere and take any
orthogonal path, but may not reuse a grid cell.

Example #1:
Input: @chars =
['A', 'B', 'D', 'E'],
['C', 'B', 'C', 'A'],
['B', 'A', 'A', 'D'],
['D', 'B', 'B', 'C'],
$str = 'BDCA'
Output: true

Example #2:
Input: @chars =
['A', 'A', 'B', 'B'],
['C', 'C', 'B', 'A'],
['C', 'A', 'A', 'A'],
['B', 'B', 'B', 'B'],
$str = 'ABAC'
Output: false

Example #3:
Input: @chars =
['B', 'A', 'B', 'A'],
['C', 'C', 'C', 'C'],
['A', 'B', 'A', 'B'],
['B', 'B', 'A', 'A'],
$str = 'CCCAA'
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
