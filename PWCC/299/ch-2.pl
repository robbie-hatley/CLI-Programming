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
This problem begs for recursion, real or fake. No need to pass "cells used" to next level, just "partial
path", because the cells of a partial path ARE the "cells used". (That issue was holding me up until I made
that realization.) And there's no need to check ALL paths, just "paths that match the given string so far".

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of double-quoted strings, apostrophes escaped as '"'"', in proper Perl syntax:
./ch-2.pl '(["She shaved?", "She ate 7 hot dogs."],["She didn'"'"'t take baths.", "She sat."])'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

use v5.36;
use utf8;

# Can a path be formed in a given matrix matching a given string?
sub word_search :prototype(\@$) ($mref, $string) {
   my @matrix = @$mref;
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @pairs = @ARGV ? eval($ARGV[0]) :
(
   # Example #1 input:
   [
      [
         ['A', 'B', 'D', 'E'],
         ['C', 'B', 'C', 'A'],
         ['B', 'A', 'A', 'D'],
         ['D', 'B', 'B', 'C'],
      ],
      'BDCA',
   ],
   # Expected output: true

   # Example #2 input:
   [
      [
         ['A', 'A', 'B', 'B'],
         ['C', 'C', 'B', 'A'],
         ['C', 'A', 'A', 'A'],
         ['B', 'B', 'B', 'B'],
      ],
      'ABAC',
   ],
   # Expected output: false

   # Example #3 input:
   [
      [
         ['B', 'A', 'B', 'A'],
         ['C', 'C', 'C', 'C'],
         ['A', 'B', 'A', 'B'],
         ['B', 'B', 'A', 'A'],
      ],
      'CCCAA',
   ],
   # Expected output: true
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $pref (@pairs) {
   say '';

}
