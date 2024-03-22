#!/bin/perl
use v5.10;
use List::Util 'sum0';
sub elem_sum (@ar) {return sum0(@ar)}
sub digi_sum (@ar) {return sum0(map {split//, $_} @ar)}
sub sum_diff (@ar) {return abs(elem_sum(@ar) - $digi_sum(@ar))}
my @arrays = @ARGV ? eval(@ARGV[0]) :
([1,2,3,45],[1,12,3],[1,2,3,4],[236,416,336,350]);
for my $aref (@arrays) {
   say '';
   my @array = @$aref;
   say 'Array = (', join(', ', @array), ')';
   say 'Sum of elements = ', elem_sum(@array);
   say 'Sum of digits   = ', digi_sum(@array);
   say 'Abs(Difference) = ', sum_diff(@array);
}
