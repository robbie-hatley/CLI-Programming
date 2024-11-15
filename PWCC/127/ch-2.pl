#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 127-2,
written by Robbie Hatley on Fri Nov 15, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 127-2: Conflict Intervals
Submitted by: Mohammad S Anwar
You are given a list of intervals. Write a script to find out if
the current interval conflicts with any of the previous intervals.

Example 1:
Input: @Intervals = [ (1,4), (3,5), (6,8), (12, 13), (3,20) ]
Output: [ (3,5), (3,20) ]

Example 2:
Input: @Intervals = [ (3,4), (5,7), (6,9), (10, 12), (13,15) ]
Output: [ (6,9) ]

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
This is just the previous problems with numerical intervals as the "sets".

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
sub disjoint ($sref1, $sref2) {
   for my $s1 (@$sref1) {
      for my $s2 (@$sref2) {
         $s2 eq $s1 and return 0;
      }
   }
   return 1;
}

sub conflicts (@intervals) {
   my @conflicts = ();
   I: for ( my $i = 1 ; $i <= $#intervals ; ++$i ) {
      my @interval_i = $intervals[$i]->[0]..$intervals[$i]->[1];
      J: for ( my $j = 0 ; $j < $i ; ++$j ) {
         my @interval_j = $intervals[$j]->[0]..$intervals[$j]->[1];
         if (!disjoint(\@interval_i, \@interval_j)) {
            push @conflicts, $intervals[$i];
            next I;
         }
      }
   }
   return @conflicts;
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) :
(
   [ [1,4], [3,5], [6,8], [12, 13], [ 3,20] ], # Expected output: ([3,5], [3,20])
   [ [3,4], [5,7], [6,9], [10, 12], [13,15] ], # Expected output: ([6,9])
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $aref (@arrays) {
   say '';
   my @intervals = @$aref;
   my @conflicts = conflicts(@intervals);
   say 'Intervals = (' . (join ', ', (map {'[' . (join ', ', @$_) . ']'} @intervals)) . ')';
   say 'Conflicts = (' . (join ', ', (map {'[' . (join ', ', @$_) . ']'} @conflicts)) . ')';
}
