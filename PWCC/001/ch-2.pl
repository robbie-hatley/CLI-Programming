#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 001-2,
written by Robbie Hatley on Fri Aug 23, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 001-2:
Submitted by: @oneandoneis2 as DM on Twitter.
Write a one-liner to solve the FizzBuzz problem and print the
numbers 1 through 20. However, any number divisible by 3 should
be replaced by the word 'fizz' and any divisible by 5 by the word
'buzz'. Those numbers that are both divisible by 3 and 5 become 'fizzbuzz'.

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
A foreach loop over 1..20 plus some modulus checks should do the trick.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via built-in list 1..20. No outside input is needed or allowed.
Output is to STDOUT and will be each input followed by the corresponding output.

=cut

my @nums = (1..20);
for (@nums) {
   my $r = "";
   0 == $_%3 and $r = "fizz".$r;
   0 == $_%5 and $r = $r."buzz";
   $r and $_ = $r;
}
$"=", ";
print "@nums\n";
