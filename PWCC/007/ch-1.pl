#!/usr/bin/env perl

=pod

The Weekly Challenge #007-1: "Niven Numbers"

Task: print all of the "Niven Numbers" (non-negative integers
divisible by the sum of their digits) from 0 through 50.

=cut

use List::Util 'sum0';
$"=', ';

sub digit_sum {
   my $x = shift;
   sum0(split '', $x)
}

sub is_niven {
   my $x = shift;
   0 == $x % digit_sum($x)
}

my @niven = ();

for (1..50) {
   push @niven, $_ if is_niven($_)
}

print "@niven\n"
