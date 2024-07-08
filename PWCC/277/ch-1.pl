#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge xxx-1,
written by Robbie Hatley on Xxx Xxx xx, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task xxx-1: Anamatu Serjianu
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
./ch-1.pl '(["She shaved?", "She ate 7 hot dogs."],["She didn'"'"'t take baths.", "She sat."])'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, VARS, AND SUBS:

   use v5.38;
   use utf8;
   no warnings 'uninitialized';
   $" = ', ';
   sub count_common :prototype(\@\@) ($a1, $a2) {
      my %counts;
      for (@$a1) {++$counts{$_}->[0]}
      for (@$a2) {++$counts{$_}->[1]}
      my $count = 0;
      for (keys %counts) {
         ++$count if 1 == $counts{$_}->[0]
                  && 1 == $counts{$_}->[1];
      }
      $count;
   }

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) :
(
   # Example 1 input:
   [
      ["Perl", "is", "my", "friend"],
      ["Perl", "and", "Raku", "are", "friend"],
   ],
   # Expected output: 2

   # Example 2 input:
   [
      ["Perl", "and", "Python", "are", "very", "similar"],
      ["Python", "is", "top", "in", "guest", "languages"],
   ],
   # Expected output: 1

   # Example 3 input:
   [
      ["Perl", "is", "imperative", "Lisp", "is", "functional"],
      ["Crystal", "is", "similar", "to", "Ruby"],
   ],
   # Expected output: 0
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
for my $aref (@arrays) {
   say '';
   my @array1 = @{$aref->[0]};
   my @array2 = @{$aref->[1]};
   my $common = count_common(@array1, @array2);
   say "Array1 = (@array1)";
   say "Array2 = (@array2)";
   say "Common = $common";
}
