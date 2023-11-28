#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
COLOPHON:
This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。麦藁雪、富士川町、山梨県。

--------------------------------------------------------------------------------------------------------------
TITLE BLOCK:
Solutions in Perl for The Weekly Challenge 245-1.
Written by Robbie Hatley on Tue Nov 28, 2023.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 245-1: Sort Language
Submitted by: Mohammad S Anwar
You are given two arrays: one of languages and the other of their
popularities. Write a script to sort the languages based on their
popularities.

Example 1:
Input: @lang = ('perl', 'c', 'python'); @popularity = (2, 1, 3);
Output: ('c', 'perl', 'python')

Example 2:
Input: @lang = ('c++', 'haskell', 'java'); @popularity = (1, 3, 2);
Output: ('c++', 'java', 'haskell')

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
I'll solve this by "zipping" the two arrays together to make an array of [language, popularity] pairs, then
sort that array numerically by the second elements of the pairs.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
double-quoted array of arrays of two arrays, with the inner array pairs consisting of an array of
single-quoted strings followed by an array of small positive integers (1-9), in proper Perl syntax, like so:
./ch-1.pl "([['Go','Lisp','AutoIt3','Logo'],[2, 1, 4, 3]],[['Awk','Cobol','Perl','Sed'],[3,4,1,2]])"

Output is to STDOUT and will be each input array followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS AND MODULES USED:

use v5.38;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';
use Sys::Binmode;
use Time::HiRes 'time';

# ------------------------------------------------------------------------------------------------------------
# START TIMER:
our $t0;
BEGIN {$t0 = time}

# ------------------------------------------------------------------------------------------------------------
# SUBROUTINES:

sub is_array_of_pos_ints($aref) {
   return 0 if 'ARRAY' ne ref $aref;
   for (@$aref) {
      return 0 if !/^[1-9]\d*$/;
   }
   return 1;
}

sub sort_by_popularity($aref1, $aref2) {
   # First make an array of [language, popularity] pairs:
   my @pairs;
   for ( my $i = 0 ; $i <= $#$aref1 ; ++$i )
   {push @pairs, [$$aref1[$i],$$aref2[$i]]}
   # Sort the pairs by popularity, then return the
   # 0th elements (language names) of the sorted pairs:
   return map {$_->[0]} sort {$a->[1]<=>$b->[1]} @pairs;
}

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:

# Inputs:
my @arrays = @ARGV ? eval($ARGV[0]) :
(
   # Example 1 Inputs:
   [
      ['perl', 'c', 'python'],
      [2, 1, 3],
   ],
   # Expected Output: ('c', 'perl', 'python')

   # Example 2 Inputs:
   [
      ['c++', 'haskell', 'java'],
      [1, 3, 2],
   ],
   # Expected Output: ('c++', 'java', 'haskell')
);

# Main loop:
for my $aref (@arrays) {
   say '';
   my $aref1 = $aref->[0];
   my $aref2 = $aref->[1];
   say 'Languages    = (' . join(', ', map {"'$_'"} @$aref1) . ')';
   say 'Popularities = (' . join(', ',              @$aref2) . ')';
   if ( scalar(@$aref1) != scalar(@$aref2) ) {
      say 'Error: subarrays are of unequal lengths.';
      say 'Moving on to next array.';
      next;
   }
   if ( !is_array_of_pos_ints($aref2) ) {
      say 'Error: second subarray is not array of positive integers.';
      say 'Moving on to next array.';
      next;
   }
   my @sorted = sort_by_popularity($aref1, $aref2);
   say 'Sorted       = (' . join(', ', map {"'$_'"} @sorted) . ')';
}
exit;

# ------------------------------------------------------------------------------------------------------------
# DETERMINE AND PRINT EXECUTION TIME:
END {my $µs = 1000000 * (time - $t0);printf("\nExecution time was %.0fµs.\n", $µs)}
__END__
