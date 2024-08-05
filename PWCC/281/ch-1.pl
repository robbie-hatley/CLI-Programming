#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 281-1,
written by Robbie Hatley on Mon Aug 05, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 281-1: Anamatu Serjianu
Submitted by: Mohammad S Anwar
Write a script which, given the coordinates of a square on a
chessboard in algebraic notation, prints "true" if the square
is white, "false" if the square is black.

Example 1:
Input:   'd3'
Output:  'true'

Example 2:
Input:   'g5'
Output:  'false'

Example 3:
Input:   'e6'
Output:  'true'

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
The is just a matter of adding the horizontal and vertical parities relative to square a1 (0/black/false).
If the combined parity is 0, the output is 0/black/false.
If the combined parity is 1, the output is 1/white/true.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of double-quoted chess coordinates in algebraic notation, in proper Perl syntax, like so:
./ch-1.pl '("b7","d6","f5")'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

use v5.38;
use utf8;
sub parity ($x) {
   return 'error' if $x !~ m/^[a-h][1-8]$/;
   ((ord(substr($x,0,1))-97)+(ord(substr($x,1,1))-49))%2
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @coords = @ARGV ? eval($ARGV[0]) : ('d3', 'g5', 'e6');

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
for my $coord (@coords) {
   my $parity = parity($coord);
   my $color  = 0 == $parity ? 'black' : 'white';
   my $result = 0 == $parity ? 'false' : 'true';
   say "coord = $coord   parity = $parity   color = $color   result = $result";
}
