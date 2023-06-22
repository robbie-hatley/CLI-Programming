#! /bin/perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
COLOPHON:
This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。麦藁雪、富士川町、山梨県。

--------------------------------------------------------------------------------------------------------------
TITLE BLOCK:
File name:    "ch-2.pl"
Description:  Solutions in Perl for The Weekly Challenge 222-2.
Authorship:   Written by Robbie Hatley on Thu Jun 22, 2023.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 2: Last Member
Submitted by: Mohammad S Anwar

You are given an array of positive integers, @ints. Write a script to find the last member if found,
otherwise return 0. Each turn pick 2 biggest members (x, y), then decide based on the following conditions,
continue this until you are left with 1 member or none.
    a) if x == y then remove both members
    b) if x != y then remove both members and add new member (y-x)

Example 1:
Input: @ints = (2, 7, 4, 1, 8, 1)
Output: 1
Step 1: pick 7 and 8, we remove both and add new member 1 => (2, 4, 1, 1, 1).
Step 2: pick 2 and 4, we remove both and add new member 2 => (2, 1, 1, 1).
Step 3: pick 2 and 1, we remove both and add new member 1 => (1, 1, 1).
Step 4: pick 1 and 1, we remove both => (1).

Example 2:
Input: @ints = (1)
Output: 1

Example 3:
Input: @ints = (1, 1)
Output: 0
Step 1: pick 1 and 1, we remove both and we left with none.

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
Blah blah blah.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of arrays in proper Perl syntax, like so:
./ch-2.pl '([13,0,27,-13], [7,5,2], [3,11], [42], [])'

Output is to STDOUT and will be each input array, followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRELIMINARIES:
use v5.36;
use strict;
use warnings;
use utf8;
use Sys::Binmode;
use Time::HiRes 'time';
use List::Util  'max';
use Math::Combinatorics;
$"=', ';

# ------------------------------------------------------------------------------------------------------------
# SUBROUTINES:


# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:

# Start timer:
my $t0 = time;

# Default inputs:
my @arrays =
(
   [9, 4, 7, 2, 10],
   [3, 6, 9, 12],
   [20, 1, 15, 3, 10, 5, 8],
);

# Non-default inputs:
if (@ARGV) {@arrays = eval($ARGV[0]);}

# Main loop:
for my $aref (@arrays) {
   say '';
   my @longest = longest_arithmetic_subsequence($aref);
   my $length = scalar(@longest);
   say "sequence = (@$aref)";
   say "longest arithmetic subsequence: (@longest)";
   say "length = $length";
}

# Determine and print execution time:
my $µs = 1000000 * (time - $t0);
printf("\nExecution time was %.3fµs.\n", $µs);
