#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 121-1,
written by Robbie Hatley on Sat Nov 23, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 121-1: Invert Bit
Submitted by: Mohammad S Anwar
You are given integers 0 <= $m <= 255 and 1 <= $n <= 8.
Write a script to invert $n bit from the end of the binary
representation of $m and print the decimal representation
of the new binary number.

Example #1:
Input: $m = 12, $n = 3
Output: 8
Binary representation of $m = 00001100
Invert 3rd bit from the end = 00001000
Decimal equivalent of 00001000 = 8

Example #2:
Input $m = 18, $n = 4
Output: 26
Binary representation of $m = 00010010
Invert 4th bit from the end = 00011010
Decimal equivalent of 00011010 = 26

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
This is easily done using Perl's bitwise operators.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of two integers, in proper Perl syntax, like so:
./ch-1.pl '([251,7],[116,5]])'
Each inner array must consist of a first number 0<=$m<=255 and a second number 1<=$n<=8.

Output is to STDOUT and will be each $m followed by $m with the bit $n places from its right end inverted.
For example, if $m is 0x01100101 and $n is 6, then the output will be 69 (the decimal value of 0x01000101).

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

use v5.36;
sub invert_bit ($m, $n) {$m^(1<<($n-1))}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) : ([12,3],[18,4]);
#                   Expected outputs:    8     26

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
for my $aref (@arrays) {
   say '';
   my $m = $$aref[0];
   my $n = $$aref[1];
   my $o = invert_bit($m,$n);
   say "The value of $m with its ${n}th-from-right bit inverted is $o."
}
