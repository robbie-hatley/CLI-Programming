#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 267-2,
written by Robbie Hatley on Mon Apr 29, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 267-2: Line Counts
Submitted by: Mohammad Sajid Anwar
You are given a string, $str, and a 26-items array @widths containing the width (in pixels) of each character
from a to z. Write a script to find out the number of lines and the width of the last line needed to display
the given string, assuming you can only fit 100 width units on a line.

Example 1 inputs:
   $str = "abcdefghijklmnopqrstuvwxyz"
   @widths = (10,10,10,10,10,10,10,10,10,10,
              10,10,10,10,10,10,10,10,10,10,
              10,10,10,10,10,10)
Expected output: (3, 60)
Line 1: abcdefghij (100 pixels)
Line 2: klmnopqrst (100 pixels)
Line 3: uvwxyz (60 pixels)

Example 2 inputs:
   $str = "bbbcccdddaaa"
   @widths = ( 4,10,10,10,10,10,10,10,10,10,
              10,10,10,10,10,10,10,10,10,10,
              10,10,10,10,10,10)
Expected output: (2, 4)
Line 1: bbbcccdddaa (98 pixels)
Line 2: a (4 pixels)

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
I think I'll first store the 26 widths in a hash keyed by letter, then fill up lines in an array until I'm
out of characters, then return the scalar of that array (line count) and the length of the last element
(last-line length).


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
   use List::Util 'sum0';
   use List::SomeUtils 'mesh';
   sub line_counts ($str, @widths) {
      my %w = mesh ('a'..'z'), @widths;
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
