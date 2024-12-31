#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 302-2,
written by Robbie Hatley on Mon Dec 30, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 302-2: Task 2: Step by Step
Submitted by: Mohammad Sajid Anwar
You are given an array of integers, @ints. Write a script to
find the minimum positive start value such that step by step sum
is never less than one.

Example 1
Input: @ints = (-3, 2, -3, 4, 2)
Output: 5
For start value 5.
5 + (-3) = 2
2 + (+2) = 4
4 + (-3) = 1
1 + (+4) = 5
5 + (+2) = 7

Example 2
Input: @ints = (1, 2)
Output: 1

Example 3
Input: @ints = (1, -2, -3)
Output: 5

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
This is just "1 minus minimum partial sum", so I need only make two subs, "minimum_partial_sum" and "ommpc",
with the first sub doing exactly what its title says, and the second simply being one minus the first.

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

# What is the minimum partial sum of
# a given finite sequence of real numbers?
sub minimum_partial_sum (@sequence) {
   my $ps  = 0;
   my $min = 0;
   for my $term (@sequence) {
      $ps += $term;
      if ($ps < $min) {$min = $ps}
   }
   $min;
}

# What is one minus the minimum partial sum of
# a given finite sequence of real numbers?
sub ommpc (@sequence) {
   1 - minimum_partial_sum(@sequence);
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) : ( [-3, 2, -3, 4, 2] , [1, 2] , [1, -2, -3] );
# Expected outputs:                            5               1          5

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $aref (@arrays) {
   say '';
   my @sequence = @$aref;
   say ommpc(@sequence);
}
