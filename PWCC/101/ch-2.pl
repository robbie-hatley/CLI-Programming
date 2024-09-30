#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 101-2,
written by Robbie Hatley on Mon Sep 30, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 101-2: Origin-containing Triangle
Submitted by: Stuart Little
Write a script to determine whether a triangle defined by three
given vertices "contains" a given fourth point within its
interior (NOT on the boundary, nor outside), where all four
points are given as (x,y) coordinates.

Example 1:
Input: [0,1], [1,0], [2,2], [0,0]
Output: "no", because that triangle does not contain (0,0).

Example 2:
Input: [1,1], [-1,1], [0,-3], [0,0]
Output: "yes" because (0,0) is inside that triangle.

Example 3:
Input: [0,1], [2,0], [-6,0], [0,0]
Output: "no" because (0,0) is on the edge connecting B and C, and
we're not considering triangles to "contain" their boundaries.

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
This is hard! One has to use "directed areas", based on determinant formulas developed by mathematician
Felix Klein in 1908, to solve this. Basically, given triangle ABC and point P, if the directed areas of the
three triangles PAB, PBC, PCA all have the same sign, then P is "inside" ABC.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of 4 2-element arrays of real numbers, in proper Perl syntax, like so:
./ch-2.pl '([[5,2],[1,3],[-4,2],[6,7]],[[5,2],[1,3],[-4,2],[1.7,2.1]])'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

use v5.36;

sub signed_area ($x1,$y1,$x2,$y2,$x3,$y3) {
   0.5*($x1*$y2+$y1*$x3+$x2*$y3-$y2*$x3-$y1*$x2-$x1*$y3);
}

sub is_inside(@array) {
   my @A = @{$array[0]};
   my @B = @{$array[1]};
   my @C = @{$array[2]};
   my @P = @{$array[3]};
   my $SA1 = signed_area($P[0], $P[1], $A[0], $A[1], $B[0], $B[1]);
   my $SA2 = signed_area($P[0], $P[1], $B[0], $B[1], $C[0], $C[1]);
   my $SA3 = signed_area($P[0], $P[1], $C[0], $C[1], $A[0], $A[1]);
   if    ($SA1 > 0 && $SA2 > 0 && $SA3 > 0) {return 1}
   elsif ($SA1 < 0 && $SA2 < 0 && $SA3 < 0) {return 1}
   else                                     {return 0}
}


# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) :
(
   [[ 0,  1], [ 1,  0], [ 2,  2], [ 0,  0]], # Expected output: No
   [[ 1,  1], [-1,  1], [ 0, -3], [ 0,  0]], # Expected output: Yes
   [[ 0,  1], [ 2,  0], [-6,  0], [ 0,  0]], # Expected output: No
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
for my $aref (@arrays) {
   my @array = @$aref;
   my $yesno = is_inside(@array);
   say '';
   say 'Triangle = '
       ."($array[0]->[0],$array[0]->[1]),($array[1]->[0],$array[1]->[1]),($array[2]->[0],$array[2]->[1])";
   say 'Point = '
       ."($array[3]->[0],$array[3]->[1])";
   say 'Point is inside triangle? ' . ($yesno ? 'Yes' : 'No');
}
