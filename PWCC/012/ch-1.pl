#!/usr/bin/env perl

=pod

The Weekly Challenge #012-1: "Smallest Non-Prime Euclid Number"
Solution in Perl written by Robbie Hatley on Mon Sep 02, 2024.

=cut

use Math::Prime::Util qw( primorial is_prime );

for ( my $n = 1 ; ; ++$n ) {
   my $Euclid = primorial($n)+1;
   if (!is_prime($Euclid)) {
      print "The smallest non-prime Euclid number is $Euclid\n";
      exit;
   }
}
