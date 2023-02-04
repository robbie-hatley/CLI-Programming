#! /usr/bin/perl

# Euler-058_Spiral-Primes.pl

=pod

Starting with 1 and writing consecutive positive integers in an
anticlockwise pattern, a square spiral with side length 7 is formed:

37 36 35 34 33 32 31
38 17 16 15 14 13 30
39 18  5  4  3 12 29
40 19  6  1  2 11 28
41 20  7  8  9 10 27
42 21 22 23 24 25 26
43 44 45 46 47 48 49

It is interesting to note that the odd squares lie along the bottom
right diagonal, but what is more interesting is that 8 out of the 13
numbers lying along both diagonals are prime; that is, a ratio of
8/13 ≈ 62%.

If one complete new layer is wrapped around the spiral above, a
square spiral with side length 9 will be formed. If this process is
continued, what is the side length of the square spiral for which the
ratio of primes along both diagonals first falls below 10%?

=cut

use v5.36;
use bigint;
use bignum;
use Math::Prime::Util qw( is_prime );

# The 4 corners for 3 wraps, rotating CCW from upper-right:
my $c1 = 31;
my $c2 = 37;
my $c3 = 43;
my $c4 = 49;

# Stats for first 3 wraps:
my $nw = 3;         # number of wraps
my $nn = 13;        # number of numbers in diagonals
my $np = 8;         # number of primes  in diagonals
my $sl = 7;         # side length
my $pp = 100*8/13;  # prime percentage

# Add wraps until prime percentage drops below 10%:
while ( $pp >= 10 ) {
   ++$nw; # Add another wrap.
   $c1 += (3*2*($nw-1) + 1*2*$nw);
   $c2 += (2*2*($nw-1) + 2*2*$nw);
   $c3 += (1*2*($nw-1) + 3*2*$nw);
   $c4 += (0*2*($nw-1) + 4*2*$nw);
   $nn += 4;
   ++$np if (2 == is_prime($c1));
   ++$np if (2 == is_prime($c2));
   ++$np if (2 == is_prime($c3));
   # (No sense testing $c4 because it's always a perfect square.)
   $pp= 100*$np/$nn;}

$sl = ( 2 * $nw ) + 1;
say "Side length at which prime percentage first dropped below 10% = $sl";
say "Number of wraps required = $nw";
say "Number of numbers in diagonals = $nn";
say "Number of primes  in diagonals = $np";
say "Prime percentage = $pp%";