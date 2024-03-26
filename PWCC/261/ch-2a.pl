#!/bin/perl
use v5.36;
use List::Util 'any';
sub mult_by_two ($start, @array) {
   $start *= 2 while any {$_ == $start} @array;
   return $start;
}
my @arrays = @ARGV ? eval($ARGV[0]) :
([5,3,6,1,12,3],[1,2,4,3,1],[5,6,7,2]);
for my $aref (@arrays) {
   say '';
   my @array = @$aref;
   my $start = pop @array;
   say 'Array  = (', join(', ', @array), ')';
   say 'Start  = ', $start;
   if ( 0 == $start ) {
      say 'Error: $start may not be 0.';
      say 'Moving on to next array.';
      next;
   }
   say 'Finish = ', mult_by_two($start, @array);
}
