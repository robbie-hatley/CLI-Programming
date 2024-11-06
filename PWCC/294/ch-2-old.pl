#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 294-2,
written by Robbie Hatley on Mon Nov 04, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 294-2: Next Permutation
Submitted by: Mohammad Sajid Anwar
You are given an array of integers, @ints. Write a script to
find out the next permutation of the given array. The next
permutation of an array of integers is the next
lexicographically greater permutation of the decimal
representations of its integers.

Example 1:
Input: @ints = (1, 2, 3)
Output: (1, 3, 2)
Permutations of (1, 2, 3) arranged lexicographically:
(1, 2, 3)
(1, 3, 2)
(2, 1, 3)
(2, 3, 1)
(3, 1, 2)
(3, 2, 1)

Example 2:
Input: @ints = (2, 1, 3)
Output: (2, 3, 1)

Example 3:
Input: @ints = (3, 1, 2)
Output: (3, 2, 1)


--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
I think I'll follow the following steps; this may not be the most efficient, but this should work:

1. Generate list of permutations. (I'll use the "Math::Combinatorics" CPAN module.)
2. Sort list of permutations by lexicographic Unicode-codepoint order. (Requires a sub to compare two lists,
   and another sub to sort a list-of-lists by using the first sub as method-of-comparison.)
3. Using a 3-part loop, find the original array in the sorted list of lists.
4. If next-highest index is in-range, return the "next permutation". If anything goes wrong, return any of
   various warning or error codes. (I can already see at least 3 failure modes.)

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays (of anything printable), in proper Perl syntax, like so:
./ch-2.pl '([3,2,1],[42],[3,5,17,8,4],[3,5,4,17,8],[3,5,4,8,17],[3,5,8,17,4],["she","Bob","he","Susan"])'

Output is to STDOUT and will be each array followed by its next permutation.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

use v5.36;
use utf8;
$"=', ';
use Math::Combinatorics;

# Compare two lists lexicographically by Unicode codepoint order:
sub compare_lists {
   my $lref1; my $lref2;
   if    (defined $a && defined $b) {$lref1 = $a   ; $lref2 = $b   ;}
   elsif (2 == scalar(@_))          {$lref1 = $_[0]; $lref2 = $_[1];}
   else                             {die "Fatal error in \"compare_lists\": invalid inputs.\n";}
   my $n = scalar @$lref1;
   my $m = scalar @$lref2;
   my $l = ($m<$n)?$m:$n;
   for my $i (0..$l-1) {
      if    ($$lref1[$i] lt $$lref2[$i]) {return -1;}
      elsif ($$lref1[$i] gt $$lref2[$i]) {return  1;}
      else                               {next     ;}
   }
   if    ($n < $m) {return -1;} # Second is extension of first , so first  is "lesser".
   elsif ($m < $n) {return  1;} # First  is extension of second, so second is "lesser".
   else            {return  0;} # The two lists are identical in every way.
}

# Sort a list of lists lexicographically by Unicode codepoint order:
sub sort_list_of_lists :prototype(@) (@list_of_lists) {return sort compare_lists @list_of_lists;}

# What is the next permutation of a given array?
sub next_permutation :prototype($) ($aref) {
   # If the array has fewer than 2 elements, it can't have a "next permutation",
   # so return error code -1:
   if (scalar(@$aref)<2) {return -1,();}
   my @permutations = permute(@$aref);
   my @sorted       = sort_list_of_lists(@permutations);
   for ( my $i = 0 ; $i <= $#sorted ; ++$i ) {
      if ( 0 == compare_lists($sorted[$i], $aref) ) {
         if ($i+1 <= $#sorted) {
            # If we get to here, the array has an unambiguous "next permutation",
            # so return success code 1 and next permutation:
            return 1, @{$sorted[$i+1]};
         }
         else {
            # If we get here, @a is its own "last permutation", so let's construe "next permutation"
            # as meaning "loop back to the start" and return warning code -2 and first permutation:
            return -2, @{$sorted[0]};
         }
      }
   }
   # If we get here, the original array didn't appear in our list of permutations, so return error code -3:
   return -3, ();
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) :
(
   [1, 2, 3], # Expected output: (1, 3, 2)
   [2, 1, 3], # Expected output: (2, 3, 1)
   [3, 1, 2], # Expected output: (3, 2, 1)
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
for my $aref (@arrays) {
   say '';
   say "Array = (@$aref)";
   my ($code, @n) = next_permutation($aref);
   if    (-1 == $code) {say 'Error: array only has one element, so can\'t have a "next" permutation.';}
   elsif (-2 == $code) {say 'Warning: array is its own last permutation, so "next" is first.';
                        say "\"Next\" (first) permutation = (@n)";}
   elsif (-3 == $code) {say 'Error: unknown error in subroutine "next_permutation".'}
   elsif ( 1 == $code) {say "Next permutation = (@n)";}
   else                {say 'Error: invalid return code from subroutine "next_permutation".';}
}
