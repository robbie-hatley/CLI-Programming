#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 101-1,
written by Robbie Hatley on Mon Sep 30, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 101-1: Pack a Spiral
Submitted by: Stuart Little

You are given an array @A of items (integers say, but they can be anything).

Your task is to pack that array into an MxN matrix spirally counterclockwise, as tightly as possible.

‘Tightly’ means the absolute value |M-N| of the difference has to be as small as possible.

Example 1:

Input: @A = (1,2,3,4)

Output:

4 3
1 2

Since the given array is already a 1x4 matrix on its own, but that's not as tight as possible. Instead, you'd spiral it counterclockwise into

4 3
1 2

Example 2:

Input: @A = (1..6)

Output:

6 5 4
1 2 3

or

5 4
6 3
1 2

Either will do as an answer, because they're equally tight.

Example 3:

Input: @A = (1..12)

Output:

9  8  7 6
10 11 12 5
1  2  3 4

or

8  7 6
9 12 5
10 11 4
1  2 3

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

use v5.36;
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
