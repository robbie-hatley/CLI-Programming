#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 295-1,
written by Robbie Hatley on Wed Nov 13, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 295-1: Word Break
Submitted by: Mohammad Sajid Anwar
Write a script to return true-or-false depending on whether-
or-not a given string can be segmented into a sequence of
one-or-more words from a given list of words.

Example 1:
Input:  string = 'weeklychallenge'   words = ("challenge", "weekly")
Output: true

Example 2

Input:  string = 'perlrakuperl'      words = ("raku", "perl")
Output: true

Example 3

Input:  string = 'sonsanddaughters'  words = ("sons", "sand", "daughters")
Output: false

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
This problem (like the second) lends itself to solution by recursion.

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
   use utf8;

   sub is_in ($item, $aref) {
      for my $test (@$aref) {
         return 1 if $test eq $item;
      }
      return 0;
   }

   sub segment ($item, $aref) {
      is_in($item,$aref) and return 1;
      for my $i (1..length($item)-1) {
         is_in(substr($item,0,$i), $aref)
         && segment(substr($item,$i), $aref)
         and return 1;
      }
      return 0;
   }

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) :
(
   [ 'weeklychallenge'  , "challenge", "weekly"       ], # expected output: true
   [ 'perlrakuperl'     , "raku", "perl"              ], # expected output: true
   [ 'sonsanddaughters' , "sons", "sand", "daughters" ], # expected output: false
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $aref (@arrays) {
   say '';
   my $item = shift @$aref;
   say "String = $item";
   say "List   = @$aref";
   segment($item,$aref)
   and say "String CAN be segmented into words from list."
   or  say "String CAN'T be segmented into words from list.";
}
