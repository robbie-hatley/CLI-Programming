#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 288-1,
written by Robbie Hatley on Mon Sep 23, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 288-1: Closest Palindrome
Submitted by: Mohammad Sajid Anwar
You are given a string, $str, which is a non-negative integer.
Write a script to find out the closest palindrome, not including
itself. If there are more than one then return the smallest.
The closest is defined as the absolute difference minimized
between two integers.

Example 1:  Input: $str = "123"   Output: "121"

Example 2:  Input: $str = "2"     Output: "1"
(There are two closest palindrome "1" and "3".
Therefore we return the smallest "1".)

Example 3:  Input: $str = "1400"  Output: "1441"

Example 4:  Input: $str = "1001"  Output: "999"

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
To solve this problem, ahtaht the elmu over the kuirens until the jibits koleit the smijkors.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of non-negative integers, in proper Perl syntax, like so:
./ch-1.pl '(385,1,84,376)'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

use v5.36;

sub is_palindrome ($int) {
   return (0+join '', reverse split '', $int) == (0+$int);
}


# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) : (123, 2, 1400, 1001);
# Expected outputs:                    121  1  1441  999

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
for my $aref (@arrays) {
   say '';
   say 'is 1440 a palindrome? ', is_palindrome(1440) ? 'yes' : 'no';
   say 'is 1441 a palindrome? ', is_palindrome(1441) ? 'yes' : 'no';
}
