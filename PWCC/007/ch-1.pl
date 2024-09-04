#!/usr/bin/env perl

=pod

The Weekly Challenge #007-1: "Niven Numbers"
Task: print all of the "Niven Numbers" (non-negative integers
divisible by the sum of their digits) from 1 through 50.
Solution in Perl written by Robbie Hatley on Fri Aug 30, 2024.

=cut

use v5.00; # We don't need no stinking special features.
use List::Util 'sum0';
$"=', ';

sub digit_sum {
   my $x = shift;
   sum0(split '', $x);
}

sub is_niven {
   my $x = shift;
   0 == $x % digit_sum($x);
}

my @niven = ();

for (1..50) {
   push @niven, $_ if is_niven($_);
}

print "The Niven Numbers within the closed interval [1,50] are\n";
print "@niven\n";
