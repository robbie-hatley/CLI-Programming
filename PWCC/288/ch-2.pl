#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 288-2,
written by Robbie Hatley on Mon Sep 23, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 288-2: Contiguous Block
Submitted by: Peter Campbell Smith

You are given a rectangular matrix where all the cells contain
either x or o. Write a script to determine the size of the
largest contiguous block. A "contiguous block" consists of
elements containing the same symbol which share an edge (not just
a corner) with other elements in the block, and where there is a
path between any two of these elements that crosses only those
shared edges.

Example 1:
Input: $matrix = [
['x', 'x', 'x', 'x', 'o'],
['x', 'o', 'o', 'o', 'o'],
['x', 'o', 'o', 'o', 'o'],
['x', 'x', 'x', 'o', 'o'],
]
Ouput: 11
(There is a block of 9 contiguous cells containing 'x'.
There is a block of 11 contiguous cells containing 'o'.)

Example 2:
Input: $matrix = [
['x', 'x', 'x', 'x', 'x'],
['x', 'o', 'o', 'o', 'o'],
['x', 'x', 'x', 'x', 'o'],
['x', 'o', 'o', 'o', 'o'],
]
Ouput: 11
(There is a block of 11 contiguous cells containing 'x'.
There is a block of 9 contiguous cells containing 'o'.)

Example 3:
Input: $matrix = [
['x', 'x', 'x', 'o', 'o'],
['o', 'o', 'o', 'x', 'x'],
['o', 'x', 'x', 'o', 'o'],
['o', 'o', 'o', 'x', 'x'],
]
Ouput: 7
(There is a block of 7 contiguous cells containing 'o'.
There are two other 2-cell blocks of 'o'.
There are three 2-cell blocks of 'x' and one 3-cell.)


--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
To solve this problem, ahtaht the elmu over the kuirens until the jibits koleit the smijkors.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of arrays of double-quoted "x" and "o" only, in proper Perl syntax.

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

use v5.36;
sub is_matrix ($mref) {
   return 0 if 'ARRAY' ne ref $mref;
   my @matrix = @$mref;
   for my $i (0..$#matrix) {
      return 0 if 'ARRAY' ne ref $matrix[$i];
      return 0 if scalar(@{$matrix[$i]}) != scalar(@{$matrix[0]});
   }
   return 1;
}
sub max_contiguous ($mref) {
   ;
}


# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @matrices = @ARGV ? eval($ARGV[0]) :
(
   [
      ['x', 'x', 'x', 'x', 'o'],
      ['x', 'o', 'o', 'o', 'o'],
      ['x', 'o', 'o', 'o', 'o'],
      ['x', 'x', 'x', 'o', 'o'],
   ],
   [
      ['x', 'x', 'x', 'x', 'x'],
      ['x', 'o', 'o', 'o', 'o'],
      ['x', 'x', 'x', 'x', 'o'],
      ['x', 'o', 'o', 'o', 'o'],
   ],
   [
      ['x', 'x', 'x', 'o', 'o'],
      ['o', 'o', 'o', 'x', 'x'],
      ['o', 'x', 'x', 'o', 'o'],
      ['o', 'o', 'o', 'x', 'x'],
   ],
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $mref (@matrices) {
   say '';
   my @matrix = @$mref;
   say 'Matrix = ';
   say "@$_" for @matrix;
   if (!is_matrix($mref)) {say 'Not a rectangular matrix!'; next;}
}
