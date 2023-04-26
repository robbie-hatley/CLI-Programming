#! /bin/perl -CSDA

=pod

------------------------------------------------------------------------------------------
COLOPHON:
This is a 90-character-wide UTF-8 Perl-source-code text file with hard Unix line breaks.
¡Hablo Español! ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。麦藁雪、富士川町、山梨県。
=========|=========|=========|=========|=========|=========|=========|=========|=========|

------------------------------------------------------------------------------------------
TITLE BLOCK:
ch-2.pl
Robbie Hatley's Perl solutions for The Weekly Challenge 214-2.
Written by Robbie Hatley on Tue Apr 25, 2023.

------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:

Task 2: Collect Points
Submitted by: Mohammad S Anwar

You are given a list of numbers.

You will perform a series of removal operations. For each operation, you remove from the list N (one or more) equal and consecutive numbers, and add to your score N × N.

Determine the maximum possible score.
Example 1:

Input: @numbers = (2,4,3,3,3,4,5,4,2)
Output: 23

We see three 3's next to each other so let us remove that first and collect 3 x 3 points.
So now the list is (2,4,4,5,4,2).
Let us now remove 5 so that all 4's can be next to each other and collect 1 x 1 point.
So now the list is (2,4,4,4,2).
Time to remove three 4's and collect 3 x 3 points.
Now the list is (2,2).
Finally remove both 2's and collect 2 x 2 points.
So the total points collected is 9 + 1 + 9 + 4 => 23.

Example 2:

Input: @numbers = (1,2,2,2,2,1)
Output: 20

Remove four 2's first and collect 4 x 4 points.
Now the list is (1,1).
Finally remove the two 1's and collect 2 x 2 points.
So the total points collected is 16 + 4 => 20.

Example 3:

Input: @numbers = (1)
Output: 1

Example 4:

Input: @numbers = (2,2,2,1,1,2,2,2)
Output: 40

Remove two 1's = 2 x 2 points.
Now the list is (2,2,2,2,2,2).
Then reomove six 2's = 6 x 6 points.

------------------------------------------------------------------------------------------
PROBLEM NOTES:



------------------------------------------------------------------------------------------
INPUT / OUTPUT NOTES:

Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument
which must be a 'single-quoted' array of arrays in proper Perl syntax, with each array
consisting of the sequence to be partitioned followed by the desired part size, like so:
./ch-2.pl '([2, -36, 5, -37, 4, -35, 3, -34, 4],[1,7,6,2,2])'

Output is to STDOUT and will be the input array and part size followed by either a
compliant partition or by "-1" if no compliant partition is possible.

=cut

# ======= PRELIMINARIES: =================================================================
# 
use v5.32;
use strict;
use warnings;
use utf8;
use Sys::Binmode;
use Time::HiRes 'time';
$"=', ';

# ======= SUBROUTINES: ===================================================================

sub consecutive_partition ($aref){
   my @set = @{$aref};
   my $size = pop @set;
   my $card = scalar @set;
   if ( 0 != $card % $size ){
      return "-1";
   }
   my $numpar = $card/$size;
   my @sorted = sort {$a<=>$b} @set;

   # Try to partition @sorted into $numpar parts:
   my @parts;
   for ( my $i = 0 ; $i < $numpar ; ++$i ){
      # Start-off the $i'th part with the least remaining element:
      push @{$parts[$i]}, shift @sorted;
      # Try to fill the part with $size consecutive integers from @sorted:
      for ( my $j = 0 ; $j <= $#sorted && scalar(@{$parts[$i]}) < $size ; ++$j ) {
         if    ( $sorted[$j]  < $parts[$i]->[-1]+1 ) {
            next;
         }
         elsif ( $sorted[$j] == $parts[$i]->[-1]+1 ) {
            push @{$parts[$i]}, splice @sorted, $j, 1;
            --$j;
            next;
         }
         elsif ( $sorted[$j]  > $parts[$i]->[-1]+1 ) {
            last;
         }
      }
      # If that failed, return "-1":
      if (scalar(@{$parts[$i]}) < $size) {return "-1"}
   }

   # If we get to here, we've made a valid partition of @sorted (and hence also a valid
   # partition of @set), so make and return the final "partition" string:
   my $partition = '(';
   for ( my $i = 0 ; $i < $numpar ; ++$i ){
      $partition .= "[@{$parts[$i]}]";
      if ($i < $numpar-1) {$partition .= ',';}
   }
   $partition .= ')';
   return $partition;
}

# ======= DEFAULT INPUTS: ================================================================

my @arrays = 
(
   [1,2,3,5,1,2,7,6,3,3],
   [1,2,3,2],
   [1,2,4,3,5,3,3],
   [1,5,2,6,4,7,3],
   [2,-36,5,-37,4,-35,3,-34,4],
   [1,7,6,2,2]
);

# ======= NON-DEFAULT INPUTS: ============================================================

if (@ARGV) {@arrays = eval($ARGV[0]);}

# ======= MAIN BODY OF PROGRAM: ==========================================================

{ # begin main
   my $t0 = time;
   for (@arrays){
      say '';
      say "array: (@$_[0..scalar(@{$_})-2])";
      say "psize: $$_[-1]";
      say "parts: ", consecutive_partition($_);
   }
   my $t1 = time; my $te = $t1 - $t0;
   say "\nExecution time was $te seconds.";
   exit 0;
} # end main
