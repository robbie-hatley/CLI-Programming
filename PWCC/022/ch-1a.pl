#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:

Adjunct to solution in Perl for The Weekly Challenge 022-1,
written by Robbie Hatley on Fri Oct 09, 2026.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:

Task 022-1a: Prime Quadruplets
Write a script to print first 1000 Prime Quadruplets. A Prime
Quadruplet is a set of 4 primes p, p+2, p+6, p+8.

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:

I'll let the routines from CPAN module "Math::Prime::Util" come to my aid.

--------------------------------------------------------------------------------------------------------------
IO NOTES:

No input is needed or accepted. Any attempts to provide any input will be ignored.

Output is to STDOUT and will be quad primes (if any exist).

=cut

use v5.40;
use Math::Prime::Util 'next_prime';
$"=', ';

# Print Prime Quads (if any):
my @primes = (2, 3, 5, 7);
my @quads  = ();
while ( scalar(@quads) < 1000 ) {
   my $next = next_prime($primes[-1]);
   push @primes, $next;
   if ( 2 == $primes[-3] - $primes[-4]
     && 4 == $primes[-2] - $primes[-3]
     && 2 == $primes[-1] - $primes[-2] ) {
      push @quads, [$primes[-4], $primes[-3], $primes[-2], $primes[-1]];
   }
}

say "($_->[0], $_->[1], $_->[2], $_->[3])" for @quads;

