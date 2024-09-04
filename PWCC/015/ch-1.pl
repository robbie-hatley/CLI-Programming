#!/usr/bin/env perl

=pod

The Weekly Challenge #015-1: "Weak/Strong Primes":
Task: Generate a list of the prime numbers in the range 1-125,
then label the primes in the range 3-99
as "Weak"   (p[n]<(p[n-1]+p[n+1])/2)
or "Strong" (p[n]>(p[n-1]+p[n+1])/2).

Solution in Perl written by Robbie Hatley on Mon Sep 02, 2024.

=cut

use Math::Prime::Util 'primes';
my @primes = @{primes(225)};
print "The first few prime numbers, labeled as \"weak\", \"strong\", \"balanced\", or \"Neither\" are:\n";
printf("%4d  Neither\n", 2);
for my $n (1..$#primes-1) {
   if    ( $primes[$n] < ($primes[$n-1]+$primes[$n+1])/2 ) {printf("%4d  Weak    \n", $primes[$n]);}
   elsif ( $primes[$n] > ($primes[$n-1]+$primes[$n+1])/2 ) {printf("%4d  Strong  \n", $primes[$n]);}
   else                                                    {printf("%4d  Balanced\n", $primes[$n]);}
}
