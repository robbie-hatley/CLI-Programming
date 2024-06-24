#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 275-2,
written by Robbie Hatley on Mon Jun 24, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 275-2: Replace Digits
Submitted by: Mohammad Sajid Anwar
You are given an alphanumeric string, $str, where each character
is either a letter or a digit. Write a script to replace each
digit in the given string with the value of the previous letter
plus (digit) places.

Example 1:
Input: $str = 'a1c1e1'
Ouput: 'abcdef'
shift('a', 1) => 'b'
shift('c', 1) => 'd'
shift('e', 1) => 'f'

Example 2:
Input: $str = 'a1b2c3d4'
Output: 'abbdcfdh'
shift('a', 1) => 'b'
shift('b', 2) => 'd'
shift('c', 3) => 'f'
shift('d', 4) => 'h'

Example 3:
Input: $str = 'b2b'
Output: 'bdb'

Example 4:
Input: $str = 'a16z'
Output: 'abgz'

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
I find it interesting that the examples show that "previous digit" means "nearest digit to the left, if any",
rather than "digit immediately to the left". This opens two ambiguities:

1. What if there is NO previous digit?
2. What if we try to shift 'z' by 3?

I think I'll fix #1 by  starting from the right and working back, and if that doesn't work, I'll use the
"invalid utf character" symbol. And I'll fix #2 by looping back to the beginning of the alphabet as in ROT13.

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
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

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
