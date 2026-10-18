#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:

Solution in Perl for The Weekly Challenge 022-1,
written by Robbie Hatley on Fri Oct 09, 2026.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:

Task 022-1: Sexy prime pairs
Write a script to print first 10 Sexy Prime Pairs. Sexy primes
are prime numbers that differ from each other by 6. For example,
the numbers 5 and 11 are both sexy primes, because 11 - 5 = 6.
The term “sexy prime” is a pun stemming from the Latin word for
six: sex.

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:

I'll let the routines from CPAN module "Math::Prime::Util" come to my aid.

--------------------------------------------------------------------------------------------------------------
IO NOTES:

No input is needed or accepted. Any attempts to provide any input will be ignored.

Output is to STDOUT and will be the first 10 sexy prime pairs.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

   use v5.40;
   use Math::Prime::Util 'next_prime';
   $"=', ';

   # Find the first 10 sexy prime pairs:
   my @primes = (2, 3, 5, 7);
   sub spp {
      my @pairs = ();
      while (scalar @pairs < 10) {
         my $next = next_prime($primes[-1]);
         push @primes, $next;
         if ( 6 == $primes[-1] - $primes[-4] )
            {push @pairs, [$primes[-4], $primes[-1]];}
         if ( 6 == $primes[-1] - $primes[-3] )
            {push @pairs, [$primes[-3], $primes[-1]];}
         if ( 6 == $primes[-1] - $primes[-2] )
            {push @pairs, [$primes[-2], $primes[-1]];}
      }
      @pairs;
   }

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
my @pairs = spp;
say "($_->[0], $_->[1])" for @pairs;
