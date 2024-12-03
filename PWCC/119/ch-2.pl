#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 119-2,
written by Robbie Hatley on Thu Nov 28, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 119-2: Sequence without 1-on-1
Submitted by: Cheok-Yin Fung
Write a script to generate sequence starting at 1. Consider the
increasing sequence of integers which contain only 1’s, 2’s and
3’s, and do not have any doublets of 1’s like below. Please
accept a positive integer $N and print the $Nth term in the
generated sequence.
1, 2, 3, 12, 13, 21, 22, 23, 31, 32, 33, 121, 122, 123, 131, ...

Example #1:
Input: $N = 5
Output: 13

Example #2:
Input: $N = 10
Output: 32

Example #3:
Input: $N = 60
Output: 2223

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
I take the approach of just iterating every positive integer, counting how many "non-one-on-one 123"
values have been found so far, and returning the nth such value found.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of positive integers in the range 1-10000, in proper Perl syntax, like so:
./ch-2.pl '(18,72,546,6834,10000)'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

   use v5.36;
   sub no_one_on_one ($x) {
      my $n = 0;
      for ( my $i = 1 ; 42 ; ++$i ) {
         if ( $i =~ m/^[123]+$/ && $i !~ m/11/ ) {
            ++$n;
            return $i if $n == $x;
         }
      }
   }

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @nums = @ARGV ? eval($ARGV[0]) : (  5  ,  10  ,  60  );
                # Expected outputs:   13     32   2223

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $num (@nums) {
   say '';
   if ($num !~ m/^[1-9]\d*$/ || $num > 10_000) {
      say "Error: You typed $num but input must be a positive integer in the range 1-10000.";
      next;
   }
   my $non = no_one_on_one($num);
   say "${num}th non-one-on-one 123 integer = $non";
}
