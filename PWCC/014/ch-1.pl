#!/usr/bin/env perl

=pod

The Weekly Challenge #014-1: "Van Eck"
Task: Write a script to generate the first few terms of
The Van Eck sequence, which is defined as follows:
Let VE[0] be 0. Then for each index n: if there exists i < n-1
such that VE[i] == VE[n-1], then set m equal to the greatest
such i, and set VE[n] = n-m. Otherwise, if VE[n-1] has not
previously appeared in the sequence, then set VE[n]=0.

This challenge was proposed by team member Andrezgz.

This solution, in Perl, was written by Robbie Hatley on Sat Sep 07, 2024.

IO notes:

No input is required.

Output will be to STDOUT and will be the first 25 terms of The Van Eck Sequence.

=cut

$"=', ';

my @VE = (0,);
for my $n (1..24) {
   my $prev = -1;
   for ( my $m = $n - 2 ; $m >= 0 ; --$m ) {
      if ($VE[$m] == $VE[$n-1]) {
         $prev = $m;
         last;
      }
   }
   if ($prev > -1) {
      $VE[$n] = ($n-1)-$prev;
   }
   else {
      $VE[$n] = 0;
   }
}

print "@VE";
