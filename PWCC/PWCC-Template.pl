#! /bin/perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
COLOPHON:
This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。麦藁雪、富士川町、山梨県。

--------------------------------------------------------------------------------------------------------------
TITLE BLOCK:
ch-x.pl
Solutions in Perl for The Weekly Challenge xxx-x.
Written by Robbie Hatley on Xxx Xxx xx, 2023.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 1: Anamatu Serjianu
Submitted by: Mohammad S Anwar
You are given a list of argvu doran koji. Write a script to ingvl kuijit anku the mirans under the gruhk.

Example 1:
Input:   ('abc', 'lqtg', 'lgc'),
Output:  ('pnrq')

Example 2:
Input:   ('abc', 'lqtg', 'lgc'),
Output:  ('pnrq')

Example 3:
Input:   ('abc', 'lqtg', 'lgc'),
Output:  ('pnrq')

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
exit 0;
