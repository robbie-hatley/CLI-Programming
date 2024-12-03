#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 298-2,
written by Robbie Hatley on Tue Dec 03, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 298-2: Right Interval
Submitted by: Mohammad Sajid Anwar

You are given an array of @intervals, where $intervals[i] =
[starti, endi] and each starti is unique. The "right" interval
for an interval i is an interval j such that startj >= endi and
   startj is minimized. Please note that i may equal j.

Write a script to return an array of right interval indices for
each interval i. If no right interval exists for interval i, then
put -1 at index i.

Example #1:
Input: @intervals = ([3,4], [2,3], [1,2])
Output: (-1, 0, 1)
There is no right interval for [3,4].
The right interval for [2,3] is [3,4] since start0 = 3 is the
smallest start that is >= end1 = 3.
The right interval for [1,2] is [2,3] since start1 = 2 is the
smallest start that is >= end2 = 2.

Example #2:
Input: @intervals = ([1,4], [2,3], [3,4])
Output: (-1, 2, -1)
There is no right interval for [1,4] and [3,4].
The right interval for [2,3] is [3,4] since start2 = 3 is the
smallest start that is >= end1 = 3.

Example #3:
Input: @intervals = ([1,2])
Output: (-1)
There is only one interval in the collection, so it outputs -1.

Example #4:
Input: @intervals = ([1,4], [2, 2], [3, 4])
Output: (-1, 1, -1)

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
