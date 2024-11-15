#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 127-1,
written by Robbie Hatley on Fri Nov 15, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 127-1: Disjoint Sets
Submitted by: Mohammad S Anwar
You are given two sets with unique integers.
Write a script to figure out if they are disjoint.
The two sets are disjoint if they don’t have any common members.

Example 1:
Input: @S1 = (1, 2, 5, 3, 4)
@S2 = (4, 6, 7, 8, 9)
Output: 0 as the given two sets have common member 4.

Example 2:
Input: @S1 = (1, 3, 5, 7, 9)
@S2 = (0, 2, 4, 6, 8)
Output: 1 as the given two sets do not have common member.


--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
Just check to see if any elements of set 2 are in set 1.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of double-quoted strings, apostrophes escaped as '"'"', in proper Perl syntax:
./ch-1.pl '(["She shaved?", "She ate 7 hot dogs."],["She didn'"'"'t take baths.", "She sat."])'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

use v5.36;
sub disjoint ($sref1, $sref2) {
   for my $s1 (@$sref1) {
      for my $s2 (@$sref2) {
         $s2 eq $s1 and return 0;
      }
   }
   return 1;
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) :
(
   [ [1, 2, 5, 3, 4] , [4, 6, 7, 8, 9] ],
   [ [1, 3, 5, 7, 9] , [0, 2, 4, 6, 8] ],
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $aref (@arrays) {
   say '';
   my $sref1 = $aref->[0];
   my $sref2 = $aref->[1];
   say "Set 1 = (@$sref1)";
   say "Set 2 = (@$sref2)";
   disjoint($sref1, $sref2)
   and say "Sets are disjoint."
   or  say "Sets are overlapping.";
}
