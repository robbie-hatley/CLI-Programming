#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 263-2,
written by Robbie Hatley on Tue Apr 02, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 263-2: Merge Items
Submitted by: Mohammad Sajid Anwar
You are given two 2-D array of positive integers, $items1 and
$items2 where element is pair of (item_id, item_quantity).
Write a script to return the merged items.

Example 1:
Input: $items1 = [ [1,1], [2,1], [3,2] ]
       $items2 = [ [2,2], [1,3] ]
Output: [ [1,4], [2,3], [3,2] ]
Item id (1) appears 2 times: [1,1] and [1,3]. Merged item now (1,4)
Item id (2) appears 2 times: [2,1] and [2,2]. Merged item now (2,3)
Item id (3) appears 1 time: [3,2]

Example 2:
Input: $items1 = [ [1,2], [2,3], [1,3], [3,2] ]
       $items2 = [ [3,1], [1,3] ]
Output: [ [1,8], [2,3], [3,3] ]

Example 3:
Input: $items1 = [ [1,1], [2,2], [3,3] ]
       $items2 = [ [2,3], [2,4] ]
Output: [ [1,1], [2,9], [3,3] ]

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
