#! /bin/perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
COLOPHON:
This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。麦藁雪、富士川町、山梨県。

--------------------------------------------------------------------------------------------------------------
TITLE BLOCK:
ch-1.pl
Solutions in Perl for The Weekly Challenge 216-1.
Written by Robbie Hatley on Sat May 13, 2023.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 2: Box Coins
Submitted by: Mohammad S Anwar
You are given an array representing box coins, @box. Write a script to collect the maximum coins until you 
took out all boxes. If we pick box[i] then we collect the coins $box[i-1] * $box[i] * $box[i+1]. 
If $box[i+1] or $box[i-1] is out of bound then treat it as 1 coin.

Example 1:  Input: @box = (3, 1, 5, 8)  Output: 167
Step 1: pick box [i=1] and collected coins 3 * 1 * 5 => 15.  Boxes available (3, 5, 8).
Step 2: pick box [i=1] and collected coins 3 * 5 * 8 => 120. Boxes available (3, 8).
Step 3: pick box [i=0] and collected coins 1 * 3 * 8 => 24.  Boxes available (8).
Step 4: pick box [i=0] and collected coins 1 * 8 * 1 => 8.   No more box available.

Example 2:  Input: @box = (1, 5)  Output: 10
Step 1: pick box [i=0] and collected coins 1 * 1 * 5 => 5. Boxes available (5).
Step 2: pick box [i=0] and collected coins 1 * 5 * 1 => 5. No more box available.

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
To solve this problem, ahtaht the elmu over the kuirens until the jibits koleit the smijkors.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of arrays in proper Perl syntax, like so:
./ch-1.pl '([[13,0,96],[-8,3,11],[2,6,4]], [[-83,-42,-57],[-99,478,952],[113,127,121]])'

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
sub is_in_list ($item, $list) {
   for (@$list) {$item eq $_ and return 1;}
   return 0;
}

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:

# Start timer:
my $t0 = time;

# Default inputs:
my @arrays =
(
   [
      [40,3,17],
      [19,7,438],
      [5,191,18],
   ],
   [
      [7,3,2],
      [8,9,10],
      [18,6,34],
   ],
   [
      [9,5,33],
      [1,2,1],
      [8,17,64],
   ],
);

# Non-default inputs:
if (@ARGV) {@arrays = eval($ARGV[0]);}

# Main loop:
for my $mref (@arrays) {
   my $max = $mref->[0]->[0];
   for my $rref (@$mref) {
      for my $element (@$rref) {
         $element > $max and $max = $element;
      }
   }
   say '';
   say 'matrix:';
   for my $rref (@$mref) {
      say "[@$rref],";
   }
   say "max = $max";
}

# Determine and print execution time:
my $µs = 1000000 * (time - $t0);
printf("\nExecution time was %.3fµs.\n", $µs);
