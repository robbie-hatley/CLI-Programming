#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 119-1,
written by Robbie Hatley on Thu Nov 28, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 119-1: Swap Nibbles
Submitted by: Mohammad S Anwar
You are given a positive integer $N. Write a script to swap the
two nibbles of the binary representation of the given number and
print the decimal number of the new binary representation.
A nibble is a four-bit aggregation, or half an octet. To keep the
task simple, we only allow integer less than or equal to 255.

Example #1:
Input: $N = 101
Output: 86
Binary representation of decimal 101 is 1100101 or as 2 nibbles
(0110)(0101). The swapped nibbles would be (0101)(0110) same as
decimal 86.

Example #2:
Input: $N = 18
Output: 33
Binary representation of decimal 18 is 10010 or as 2 nibbles
(0001)(0010). The swapped nibbles would be (0010)(0001) same as
decimal 33.

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
This is just a matter of bit fiddling.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of integers $n, 0 <= $n <= 255, in proper Perl syntax, like so:
./ch-1.pl '("Fred",-4,265,0,17,111,138,178)'

Output is to STDOUT and will be each input followed by the input with nybbles swapped.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

   use v5.36;
   sub swap_nybbles ($x) {
      my $n1 = $x & 0b11110000;
      my $n2 = $x & 0b00001111;
      return ($n1 >> 4) + ($n2 << 4);
   }

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @nums = @ARGV ? eval($ARGV[0]) : (101,18);
                # Expected outputs:   86 33

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $num (@nums) {
   say '';
   say "Number = $num";
   if ($num !~ m/^-[1-9]\d*$|^0$|^[1-9]\d*$/ || $num < 0 || $num > 255) {
      say "Error: Input must be a non-negative integer in the range 0-255.";
      next;
   }
   my $swapped = swap_nybbles($num);
   say "Number with nybbles swapped = $swapped";
}
