#! /bin/perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
COLOPHON:
This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。麦藁雪、富士川町、山梨県。

--------------------------------------------------------------------------------------------------------------
TITLE BLOCK:
ch-2.pl
Solutions in Perl for The Weekly Challenge 224-2.
Written by Robbie Hatley on Thursday July 6, 2023.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 2: Additive Number
Submitted by: Mohammad S Anwar

You are given a string containing digits 0-9 only.

Write a script to find out if the given string is additive number. An additive number is a string whose digits can form an additive sequence.

    A valid additive sequence should contain at least 3 numbers. Except the first 2 numbers, each subsequent number in the sequence must be the sum of the preceding two.


Example 1:

Input: $string = "112358"
Output: true

The additive sequence can be created using the given string digits: 1,1,2,3,5,8
1 + 1 => 2
1 + 2 => 3
2 + 3 => 5
3 + 5 => 8

Example 2:

Input: $string = "12345"
Output: false

No additive sequence can be created using the given string digits.

Example 3:

Input: $string = "199100199"
Output: true

The additive sequence can be created using the given string digits: 1,99,100,199
 1 +  99 => 100
99 + 100 => 199

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
This is a "partitions of a string" problem. Oh, my. String partitions are collections of substrings which are 
non-overlapping (injective) and non-gapping (surjective). Each part is is a substring determined by starting 
index. Each available index may-or-may-not be a start of a part, except for index [0] which is ALWAYS the 
start of a part (this is necessary to achieve "non-gapping"; if a part does not start at [0] we have a gap to 
the left of the first part). Hence the number of possible partitions of a string of size n is 2^(n-1).

The length of each partis determined by the starting index of the next partition, or by the end of 
the string. 

So ultimately, every partition is determined by a unique subset of indices, and every 
subset of indices determines a unique partition. (See Pascal's Triangle.)

So the partitions of a string of length n are isomorphic to the set of all m-combinations of the set of
indices 0..n-1 for all possible m from 0 through n-1. So I shall once again employ Math::Combinatorics. 

The algorithm will look like this: 

Given a string $string of length n:
make an array @i = 0..n-1         of the indices of $string.
make an array-of-arrays @c = ()   to hold all 3+ combinations of @i
make an array-of-arrays @p = ()   to hold all 3+ partitionings of $string
for each m from 3 through n-1 {
   push each possible m-combination of @i to array @p
}
for each element of @c, push the corresponding partitioning of $string onto @p.



--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of integers in proper Perl syntax, like so:
./ch-2.pl '([13,0,96], [-8,3,11], [2,6,4], [53,127,4,76,2,83])'

Output is to STDOUT and will be each input array, followed by maximum coins.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRELIMINARIES:
use v5.36;
use strict;
use warnings;
use utf8;
use Sys::Binmode;
use Time::HiRes 'time';
use Math::Combinatorics;
use List::Util  'max';
$"=', ';

# ------------------------------------------------------------------------------------------------------------
# SUBROUTINES:

sub is_integer ($x) {
   return ($x =~ m/^(?:-[1-9]\d*)|(?:0)|(?:[1-9]\d*)$/)
}

sub are_integers (@a) {
   for (@a) {return 0 if ! is_integer($_)}
   return 1;
}

sub max_coins (@a) {
   my $n = scalar(@a);
   return 'ERROR: EMPTY ARRAY'  if $n < 1;
   return 'ERROR: NOT INTEGERS' if !are_integers(@a);
   my @indices = 0..$n-1;
   my @scores = ();
   my $perms = Math::Combinatorics->new(count => $n, data => [@indices]);
   while(my @perm = $perms->next_permutation){
      my @b = @a; # Start with fresh copy of @a to avoid landing on 'X'!!!!!
      my $score = 0;
      for ( my $i_select = 0 ; $i_select < $n ; ++$i_select ) {
         my $i = $perm[$i_select];
         if ($b[$i] eq 'X') {return 'ERROR: LANDED ON X';}
         my $partial = $b[$i];
         $b[$i] = 'X';
         # Multiply by left box, if any:
         for ( my $j = $i-1 ; $j > -1 ; --$j ) {
            if ('X' ne $b[$j]) {
               $partial *= $b[$j];
               last;
            }
         }
         # Multiply by right box, if any:
         for ( my $j = $i+1 ; $j < $n ; ++$j ) {
            if ('X' ne $b[$j]) {
               $partial *= $b[$j];
               last;
            }
         }
         $score += $partial;
      }
      push @scores, $score;
   }
   return max(@scores);
}

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:

# Start timer:
my $t0 = time;

# Default inputs:
my @arrays =
(
   [3, 1, 5, 8],
   [1, 5]
);

# Non-default inputs:
if (@ARGV) {@arrays = eval($ARGV[0]);}

# Main loop:
for my $aref (@arrays) {
   say '';
   my $max = max_coins(@$aref);
   say "Given coin-boxes (@$aref), max coins = $max";
}

# Determine and print execution time:
my $µs = 1000000 * (time - $t0);
printf("\nExecution time was %.3fµs.\n", $µs);
