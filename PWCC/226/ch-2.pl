#! /bin/perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
COLOPHON:
This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。麦藁雪、富士川町、山梨県。

--------------------------------------------------------------------------------------------------------------
TITLE BLOCK:
Solutions in Perl for The Weekly Challenge 226-2.
Written by Robbie Hatley on Mon Jul 17, 2023.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 2: Zero Array
Submitted by: Mohammad S Anwar

You are given an array of non-negative integers, @ints.

Write a script to return the minimum number of operations to make every element equal zero.

In each operation, you are required to pick a positive number less than or equal to the smallest element in the array, then subtract that from each positive element in the array.


Example 1:

Input: @ints = (1, 5, 0, 3, 5)
Output: 3

operation 1: pick 1 => (0, 4, 0, 2, 4)
operation 2: pick 2 => (0, 2, 0, 0, 2)
operation 3: pick 2 => (0, 0, 0, 0, 0)

Example 2:

Input: @ints = (0)
Output: 0

Example 3:

Input: @ints = (2, 1, 4, 0, 3)
Output: 4

operation 1: pick 1 => (1, 0, 3, 0, 2)
operation 2: pick 1 => (0, 0, 2, 0, 1)
operation 3: pick 1 => (0, 0, 1, 0, 0)
operation 4: pick 1 => (0, 0, 0, 0, 0)

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
To solve this problem, ahtaht the elmu over the kuirens until the jibits koleit the smijkors.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
double-quoted array of arrays of single-quoted strings, apostrophes escaped, in proper Perl syntax, like so:
./ch-1.pl "(['I go.', 'She ran home.', 'I ate seven hot dogs.'],['She sat.', 'I didn\'t sit.'])"

Output is to STDOUT and will be each input array followed by corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRELIMINARIES:

use v5.36;
use strict;
use warnings;
use utf8;
use Sys::Binmode;
use Time::HiRes 'time';
$"=', ';

# ------------------------------------------------------------------------------------------------------------
# SUBROUTINES:

sub ppl ($source, $target) { # ppl = "Poison Pen Letter"
   my @tchars = split //, $target;
   foreach my $tchar (@tchars) {
      my $index = index $source, $tchar;
      # If index is -1, this Target CAN'T be built from this Source:
      if ( -1 == $index ) {
         return 'false';
      }
      # Otherwise, no problems have been found so-far, so remove $tchar from $source and continue:
      else {
         substr $source, $index, 1, '';
      }
   }
   # If we get to here, there were no characters in Target which couldn't be obtained from Source,
   # so this poison-pen letter CAN be built from the source letters given:
   return 'true';
}

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:

# Start timer:
my $t0 = time;

# Default inputs:
my @arrays =
(
   ['abc', 'xyz'],
 ['scriptinglanguage', 'perl'],
 ['aabbcc', 'abc'],
);

# Non-default inputs:
@arrays = eval($ARGV[0]) if @ARGV;

# Main loop:
for my $aref (@arrays) {
   say '';
   my $source = $aref->[0];
   my $target = $aref->[1];
   my $output = ppl($source, $target);
   say "Source string: \"$source\"";
   say "Target string: \"$target\"";
   say "Can build Target from Source?: $output";
}

# Determine and print execution time:
my $µs = 1000000 * (time - $t0);
printf("\nExecution time was %.0fµs.\n", $µs);
