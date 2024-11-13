#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 295-2,
written by Robbie Hatley on Wed Nov 13, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 295-2: Jump Game
Submitted by: Mohammad Sajid Anwar
Write a script to find the minimum number of jumps to reach from
the first element to the last of a given array of integers,
@ints, such that $ints[$i] represents the maximum length of a
forward jump from the index $i. If the last element is
unreachable, then return -1.

Example 1:
Input:  @ints = (2, 3, 1, 1, 4)
Output: 2
Jump 1 step from index 0 then 3 steps from index 1 to the last
element.

Example 2:
Input:  @ints = (2, 3, 0, 4)
Output: 2

Example 3:
Input:  @ints = (2, 0, 0, 4)
Output: -1

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
This problem (like the first) lends itself to solution by recursion.

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
   use List::Util 'min';

   sub jumps ($aref, $start=0, $jumps=0) {
      if ($start == $#$aref) {
         return $jumps;
      }
      my @jumps = ();
      for my $jump (1..$aref->[$start]) {
         next if $start+$jump < 0 || $start+$jump > $#$aref;
         push @jumps, jumps($aref, $start+$jump, $jumps+1);
      }
      if (0 == $start) {
         if (0 == scalar(@jumps)) {return -1;}
         else {return min(@jumps);}
      }
      return @jumps;
   }

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) :
(
   [2, 3, 1, 1, 4],
   [2, 3, 0, 4],
   [2, 0, 0, 4],
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $aref (@arrays) {
   say '';
   say "Array = (@$aref)";
   my $jumps = jumps($aref);
   say "Min jump = $jumps";
}
