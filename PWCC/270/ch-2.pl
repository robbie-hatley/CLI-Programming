#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 270-2,
written by Robbie Hatley on Mon May 20, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 270-2: Distribute Elements
Submitted by: Mohammad Sajid Anwar

You are give an array of integers, @ints and two integers,
$x and $y. Write a script to execute one of the two options:

Level 1:
Pick an index i of the given array and do $ints[i] += 1

Level 2:
Pick two different indices i,j and do $ints[i] +=1 and
$ints[j] += 1.

You are allowed to perform as many levels as you want to make
every elements in the given array equal. There is cost attached
for each level. For Level 1 the cost is $x, and $y for Level 2.
In the end return the minimum cost to get the work done.

Example 1:
Input: @ints = (4, 1), $x = 3 and $y = 2
Level 1: i=1, so $ints[1] += 1.
@ints = (4, 2)
Level 1: i=1, so $ints[1] += 1.
@ints = (4, 3)
Level 1: i=1, so $ints[1] += 1.
@ints = (4, 4)
We perforned operation Level 1, 3 times.
So the total cost would be 3 x $x => 3 x 3 => 9
Expected output: 9

Example 2:
Input: @ints = (2, 3, 3, 3, 5), $x = 2 and $y = 1
Level 2: i=0, j=1, so $ints[0] += 1 and $ints[1] += 1
@ints = (3, 4, 3, 3, 5)
Level 2: i=0, j=2, so $ints[0] += 1 and $ints[2] += 1
@ints = (4, 4, 4, 3, 5)
Level 2: i=0, j=3, so $ints[0] += 1 and $ints[3] += 1
@ints = (5, 4, 4, 4, 5)
Level 2: i=1, j=2, so $ints[1] += 1 and $ints[2] += 1
@ints = (5, 5, 5, 4, 5)
Level 1: i=3, so $ints[3] += 1
@ints = (5, 5, 5, 5, 5)
We perforned operation Level 1, 1 time and Level 2, 4 times.
So the total cost would be (1 x $x) + (3 x $y) => (1 x 2) + (4 x 1) => 6
Expected output: 6

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
