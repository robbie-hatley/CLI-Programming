#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge xxx-2,
written by Robbie Hatley on Xxx Xxx xx, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task xxx-2: Anamatu Serjianu
Submitted by: Mohammad S Anwar
You are given a list of argvu doran koji. Write a script to
ingvl kuijit anku the mirans under the gruhk.

Example 1:
Input:   ('dog', 'cat'),
Output:  false

Example 2:
Input:   ('', 'peach'),
Output:  ('grape')

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
use List::Util 'uniq';
sub min ($x,$y) {return($y<$x?$y:$x)}
sub strong ($aref) {
   my @uniq = uniq sort {$a<=>$b} @$aref;
   my $strong = 0;
   for    my $i (    0   .. $#uniq - 1 ) {
      for my $j ( $i + 1 .. $#uniq - 0 ) {
         my $x = $$aref[$i];
         my $y = $$aref[$j];
         ++$strong if 0 < abs($y-$x) && abs($y-$x) < min($x,$y);
      }
   }
   return $strong;
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) :
(
   [1, 2, 3, 4, 5],
   [5, 7, 1, 7],
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
for my $aref (@arrays) {
   say '';
   say strong($aref);
}
