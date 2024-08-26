#!/usr/bin/env perl

# TITLE AND ATTRIBUTION:
# Solutions in Perl for The Weekly Challenge 001-2,
# written by Robbie Hatley on Fri Aug 23, 2024.

# PROBLEM DESCRIPTION:
# Task 001-2:
# Submitted by: @oneandoneis2 as DM on Twitter.
# Write a one-liner to solve The Fizzbuzz Problem: Print the numbers 1 through
# 20; however, any number divisible by 3 should be replaced by the word "fizz";
# any number divisible by 5 should be replaced by the word "buzz"; and any
# number divisible by both 3 AND 5 should be replaced by "fizzbuzz".

# PROBLEM NOTES:
# A foreach loop over 1..20 plus some modulus checks should do the trick.

# IO NOTES:
# Input is via built-in list 1..20. No outside input is needed or allowed.
# Output is to STDOUT and will be each input followed by the corresponding
# output.

use v5.10;
$"=', ';
my @nums = (1..20);
for my $num (@nums) {
   my $r = '';
   if (0 == $num % 3) {$r = 'fizz'.$r }
   if (0 == $num % 5) {$r = $r.'buzz' }
   if (length $r > 0) {$num = $r      }
}
say "@nums";
