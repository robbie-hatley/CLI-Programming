#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 294-1,
written by Robbie Hatley on Mon Nov 04, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 294-1: Consecutive Sequence
Submitted by: Mohammad Sajid Anwar
You are given an unsorted array of integers, @ints. Write a
script to return the length of the longest consecutive elements
sequence. Return -1 if none found. The algorithm must run in O(n)
time.

Example 1:
Input: @ints = (10, 4, 20, 1, 3, 2)
Output: 4
The longest consecutive sequence (1, 2, 3, 4).
The length of the sequence is 4.

Example 2:
Input: @ints = (0, 6, 1, 8, 5, 2, 4, 3, 0, 7)
Output: 9

Example 3:
Input: @ints = (10, 30, 20)
Output: -1


--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
I don't know about O(n), but I can get close, by using a variant of "Insertion Sort" which doesn't insert
duplicates, then finding max consecutive subsequence length.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of integers, in proper Perl syntax, like so:
./ch-1.pl '([-4,7,82,16,4] , [-4,7,82,-3,8,16,6,4])'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

use v5.38;

# Obtain sorted array of all unique integers from an input array:
sub unisrt (@a) {
   my @s; # Sorted array of all unique integers from @a.
   X: for my $x (@a) {
      # If @s is empty, append $x to right end of @s:
      if (!@s) {push @s, $x; next X;}
      # Compare $x to each element of @s;
      # insert-before if less, skip this $x if equal, next $idx if greater:
      I: for ( my $idx = 0 ; $idx <= $#s ; ++$idx ) {
         if ($x  < $s[$idx]) {splice @s, $idx, 0, $x;next X;}
         if ($x == $s[$idx]) {next X;}
         if ($x  > $s[$idx]) {next I;}
      }
      # If we get to here, $x is greater than $s[-1],
      # so tack $x onto the right end of @s:
      push @s, $x; next X;
   }
   return @s;
}

# Deterine max consecutive subsequence length within an array of integers:
sub maximum_consecutive_subsequence_length (@s) {
   my $beg = 0;
   my $end = 0;
   my $len = 0;
   my $max = 0;
   for ( my $i = 1 ; $i <= $#s ; ++$i ) {
      # If this element continues a consecutive subsequence,
      # set new end to current index and move to next index:
      if ($s[$i] == $s[$i-1] + 1) {
         $end = $i;
         next;
      }
      # Otherwise, previous element was end of a consecutive subsequence,
      # so calculate its length, compare to max, and set beg and end to current:
      else {
         $len = $end-$beg+1;
         if ($len > $max) {$max = $len;}
         $beg = $i;
         $end = $i;
         next;
      }
   }
   # Calculate length of final consecutive subsequence and compare to max:
   $len = $end-$beg+1;
   if ($len > $max) {$max = $len;}
   # Return maximum consecutive subsequence length,
   # unless it's <2 in which case return -1:
   if ($max > 1) {return $max;} else {return -1;}
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) :
(
   [10, 4, 20, 1, 3, 2],           # Expected output = 4
   [0, 6, 1, 8, 5, 2, 4, 3, 0, 7], # Expected output = 9
   [10, 30, 20],                   # Expected output = -1
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $aref (@arrays) {
   say '';
   my @a = @$aref;
   my @s = unisrt(@a);
   my $m = maximum_consecutive_subsequence_length(@s);
   say "Array       = (@a)";
   say "Sort-Unique = (@s)";
   say "Max-Consec  = $m";
}
