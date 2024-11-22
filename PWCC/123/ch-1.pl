#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 123-1,
written by Robbie Hatley on Wed Nov 20, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 123-1: Ugly Numbers
Submitted by: Mohammad S Anwar
Write a script to find the $nth Ugly Number for a given
positive integer $n. A number is "Ugly" if-and-only-if
it is equal to 2^i*3^j*5^k for non-negative integers i,j,k.
The first few Ugly Numbers are 1, 2, 3, 4, 5, 6, 8, 9, 10, 12.

Example #1:
Input: $n = 7
Output: 8

Example #2:
Input: $n = 10
Output: 12

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
To solve this problem, I'll need three subroutines:
1. "prime_factors"     (gets prime factors)
2. "is_ugly"           (checks for ugliness (a number is "ugly" if its greatest prime factor is < 7))
3. "ugly ($i)"         (returns the ith ugly number (0-based index $i-1))

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of positive integers, in proper Perl syntax, like so:
./ch-1.pl '(45,168,5572)'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

   use v5.36;

   # Is a given positive integer ugly?
   sub is_ugly ($x) {
      $x /= 2 while 0 == $x % 2;
      $x /= 3 while 0 == $x % 3;
      $x /= 5 while 0 == $x % 5;
      1 == $x}

   # Return nth ugly number:
   sub nthugly ($n) {
      my $ugly = 0; my $count = 0;
      while ($count < $n) {
         ++$ugly;
         if (is_ugly($ugly)) {++$count}}
      return $ugly}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @integers = @ARGV ? eval($ARGV[0]) : (7, 10);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $n (@integers) {
   my $nthugly = nthugly($n);
   say "${n}th ugly number = $nthugly";
}
