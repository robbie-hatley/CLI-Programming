#! /bin/perl -CSDA

=pod

------------------------------------------------------------------------------------------
COLOPHON:
This is a 90-character-wide UTF-8 Perl-source-code text file with hard Unix line breaks.
¡Hablo Español! ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。麦藁雪、富士川町、山梨県。
=========|=========|=========|=========|=========|=========|=========|=========|=========|

------------------------------------------------------------------------------------------
TITLE BLOCK:
ch-1.pl
Robbie Hatley's Perl solutions for The Weekly Challenge 214-1.
Written by Robbie Hatley on Tue Apr 25, 2023.

------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 1: Rank Score
Submitted by: Mohammad S Anwar

You are given a list of scores (>=1).

Write a script to rank each score in descending order. First three will get medals i.e. G (Gold), S (Silver) and B (Bronze). Rest will just get the ranking number.

    Using the standard model of giving equal scores equal rank, then advancing that number of ranks.


Example 1

Input: @scores = (1,2,4,3,5)
Output: (5,4,S,B,G)

Score 1 is the 5th rank.
Score 2 is the 4th rank.
Score 4 is the 2nd rank i.e. Silver (S).
Score 3 is the 3rd rank i.e. Bronze (B).
Score 5 is the 1st rank i.e. Gold (G).

Example 2

Input: @scores = (8,5,6,7,4)
Output: (G,4,B,S,5)

Score 8 is the 1st rank i.e. Gold (G).
Score 4 is the 4th rank.
Score 6 is the 3rd rank i.e. Bronze (B).
Score 7 is the 2nd rank i.e. Silver (S).
Score 4 is the 5th rank.

Example 3

Input: @list = (3,5,4,2)
Output: (B,G,S,4)

Example 4

Input: @scores = (2,5,2,1,7,5,1)
Output: (4,S,4,6,G,S,6)

------------------------------------------------------------------------------------------
PROBLEM NOTES:



------------------------------------------------------------------------------------------
INPUT / OUTPUT NOTES:

Input is either from built-in array of arrays or from @ARGV. If using @ARGV, provide one
argument which must be a 'single-quoted' array of arrays of integers in correct Perl
syntax. For example:
./ch-1.pl '([7,3,11,8], [3,19,3,42], [5,-7,10,2,8,4,3,6,19,14,9])'

Output is to STDOUT and will be the input array followed by the "Fun Sort" of the array.

=cut

# ======= PRELIMINARIES: =================================================================
use v5.32;
use strict;
use warnings;
use utf8;
use Sys::Binmode;
use Time::HiRes 'time';
$"=', ';

# ======= SUBROUTINES: ===================================================================

sub even_odd {
   my $aref  = shift;
   my $sref  = shift;
   my @evens = ();
   my @odds  = ();
   for my $x (@{$aref}) {
      if (0 == $x % 2) {push @evens, $x;}
      else             {push @odds , $x;}
   }
   push @$sref, (sort {$a<=>$b} @evens), (sort {$a<=>$b} @odds);
}

# ======= DEFAULT INPUT: =================================================================
my @arrays =
(
   [1,2,3,4,5,6],
   [1,2],
   [1],
   [5,-7,4,9,10,2,-8,7],
);

# ======= NON-DEFAULT INPUT: =============================================================
if (@ARGV) {@arrays = eval($ARGV[0])}

# ======= MAIN BODY OF PROGRAM: ==========================================================

{ # begin main
   my $t0 = time;
   for (@arrays) {
      my @sorted = ();
      even_odd($_, \@sorted);
      say '';
      say " un-sorted array: (@{$_})";
      say "Fun-Sorted array: (@sorted)";
   }
   my $t1 = time; my $te = 1000000*($t1-$t0);
   printf("\nExecution time was %.3fµs.\n", $te);
   exit 0;
} # end main
