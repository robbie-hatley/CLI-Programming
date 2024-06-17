#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 274-2,
written by Robbie Hatley on Mon Jun 17, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 274-2: Bus Route
Submitted by: Peter Campbell Smith
Several bus routes start from a bus stop near my home, and go to
the same stop in town. They each run to a set timetable, but they
take different times to get into town. Write a script to find the
times - if any - I should let one bus leave and catch a strictly
later one in order to get into town strictly sooner. An input
timetable consists of the service interval, the offset within the
hour, and the duration of the trip.

Example 1:
Input: [ [12, 11, 41], [15, 5, 35] ]
Output: [36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47]
Route 1 leaves every 12 minutes, starting at 11 minutes past the
hour (so 11, 23, ...) and takes 41 minutes. Route 2 leaves every
15 minutes, starting at 5 minutes past (5, 20, ...) and takes 35
minutes. At 45 minutes past the hour I could take the route 1
bus at 47 past the hour, arriving at 28 minutes past the
following hour, but if I wait for the route 2 bus at 50 past I
will get to town sooner, at 25 minutes past the next hour.

Example 2:
Input: [ [12, 3, 41], [15, 9, 35], [30, 5, 25] ]
Output: [ 0, 1, 2, 3, 25, 26, 27, 40, 41, 42, 43, 44, 45,
         46, 47, 48, 49, 50, 51, 55, 56, 57, 58, 59 ]

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
