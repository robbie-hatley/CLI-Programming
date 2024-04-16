#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 265-2,
written by Robbie Hatley on Mon Apr 15, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 265-2: Completing Word
Submitted by: Mohammad Sajid Anwar
You are given a string, $str containing alphnumeric characters
and array of strings (alphabetic characters only), @str. Write
a script to find the shortest completing word. If none found
return empty string. A "completing word" is a word that contains
all the letters in the given string, ignoring space and number.
If a letter appeared more than once in the given string then it
must appear the same number or more in the word.

Example 1:
Input: $str = 'aBc 11c'
       @str = ('accbbb', 'abc', 'abbc')
Output: 'accbbb'
The given string contains following, ignoring case and number:
a 1 times
b 1 times
c 2 times
The only string in the given array that satisfies the condition is 'accbbb'.

Example 2:
Input: $str = 'Da2 abc'
       @str = ('abcm', 'baacd', 'abaadc')
Output: 'baacd'
The given string contains following, ignoring case and number:
a 2 times
b 1 times
c 1 times
d 1 times
The are 2 strings in the given array that satisfies the condition:
'baacd' and 'abaadc'.
Shortest of the two is 'baacd'

Example 3:
Input: $str = 'JB 007'
       @str = ('jj', 'bb', 'bjb')
Output: 'bjb'
The given string contains following, ignoring case and number:
j 1 times
b 1 times
The only string in the given array that satisfies the condition is 'bjb'.

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

use v5.36;
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
