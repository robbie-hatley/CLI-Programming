#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 287-1,
written by Robbie Hatley on Mon Sep 16, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 287-1: Strong Password
Submitted by: Mohammad Sajid Anwar

You are given a string, $str.

Write a program to return the minimum number of steps required to make the given string very strong password. If it is already strong then return 0.

Criteria:

- It must have at least 6 characters.
- It must contains at least one lowercase letter, at least one upper case letter and at least one digit.
- It shouldn't contain 3 repeating characters in a row.

Following can be considered as one step:

- Insert one character
- Delete one character
- Replace one character with another

Example 1

Input: $str = "a"
Output: 5

Example 2

Input: $str = "aB2"
Output: 3

Example 3

Input: $str = "PaaSW0rd"
Output: 0

Example 4

Input: $str = "Paaasw0rd"
Output: 1

Example 5

Input: $str = "aaaaa"
Output: 2


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
# PRAGMAS, MODULES, AND SUBS:

use v5.38;
use utf8;
sub ppl ($source, $target) { # ppl = "Poison Pen Letter"
   my @tchars = split //, $target;
   foreach my $tchar (@tchars) {
      my $index = index $source, $tchar;
      # If index is -1, this Target CAN'T be built from this Source:
      if ( -1 == $index ) {
         return 'false';
      }
      # Otherwise, no problems have been found so-far, so remove $tchar from $source and continue:
      else {
         substr $source, $index, 1, '';
      }
   }
   # If we get to here, there were no characters in Target which couldn't be obtained from Source,
   # so this poison-pen letter CAN be built from the source letters given:
   return 'true';
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) :
(
   ['abc', 'xyz'],
   ['scriptinglanguage', 'perl'],
   ['aabbcc', 'abc'],
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
for my $aref (@arrays) {
   say '';
   my $source = $aref->[0];
   my $target = $aref->[1];
   my $output = ppl($source, $target);
   say "Source string: \"$source\"";
   say "Target string: \"$target\"";
   say "Can build Target from Source?: $output";
}
