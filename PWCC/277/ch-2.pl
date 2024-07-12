#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 277-2,
written by Robbie Hatley on Thu Jul 11, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 277-2: Strong Pair
Submitted by: Mohammad Sajid Anwar
Given an array of integers, write a script to return the count
of all strong pairs in the given array. A pair of integers
x and y is called a "strong pair" if it satisfies theses
inequalities: 0 < |x - y| and |x - y| < min(x, y).

   # Example 1 input:
   [1, 2, 3, 4, 5],
   # Expected output: 4
   # (Strong Pairs: (2, 3), (3, 4), (3, 5), (4, 5).)

   # Example 2 input:
   [5, 7, 1, 7],
   # Expected output: 1
   # (Strong Pairs: (5, 7).)

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
To solve this problem, ahtaht the elmu over the kuirens until the jibits koleit the smijkors.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of integers, in proper Perl syntax, like so:
./ch-2.pl '([1,2,3,4,5,6],[21,22,23,24,25,26])'

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
      for    my $i (    0   .. $#uniq - 1 ) { my $x = $$aref[$i];
         for my $j ( $i + 1 .. $#uniq - 0 ) { my $y = $$aref[$j];
            ++$strong if 0 < abs($y-$x) && abs($y-$x) < min($x,$y);
         }
      }
      return $strong;
   }

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) :
(
   # Example 1 input:
   [1, 2, 3, 4, 5],
   # Expected output: 4
   # (Strong Pairs: (2, 3), (3, 4), (3, 5), (4, 5).)

   # Example 2 input:
   [5, 7, 1, 7],
   # Expected output: 1
   # (Strong Pairs: (5, 7).)
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
for my $aref (@arrays) {
   say '';
   say "Array = (${\join(q(, ), @$aref)})";
   say "Number of strong pairs = ${\strong($aref)}";
}
