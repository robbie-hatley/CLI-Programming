#!/usr/bin/env perl

# This is a 110-character-wide ASCII-encoded Perl-source-code text file with hard Unix line breaks ("\x0A").
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# prime-regexp.pl
# Finds primes using regexps?
# Written by Robbie Hatley.
# Edit history:
# Sat Nov 02, 2024: Wrote it.
##############################################################################################################

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PRAGMAS, MODULES, AND SUBS:

use v5.40;
use Scalar::Util 'looks_like_number';

# Does a non-negative integer $x NOT match our regexp?
sub nomatch ($x) {
   $x !~ m/^.?$|^(..+?)\1+$/;
}

# Is $x a prime number?
sub is_prime ($x) {
   $x < 2      and return 0;
   2 == $x     and return 1;
   0 == $x % 2 and return 0;
   my $limit = int sqrt $x;
   for ( my $divisor = 3 ; $divisor <= $limit ; $divisor+=2 ) {
      0 == $x % $divisor and return 0;
   }
   return 1;
}

# Print help:
sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   Welcome to "prime-regexp.pl". This program prints all non-negative integers
   from 0 through 999 which do NOT match a regexp which apparently is geared
   towards finding composite numbers. It does not take any inputs, arguments,
   or options.
   END_OF_HELP
} # end sub help

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MAIN BODY OF PROGRAM:
for (@ARGV) {'-h' eq $_ || '--help' eq $_ and help and exit}
my @nums = 0..5_000_000;
say "Exceptions found in the non-negative integers from 0 through 5 million: ";
for (@nums) {
   0 == $_ % 10_000 and say "$_";
   nomatch('1'x$_) && !is_prime($_) and say "$_: no  match but isn't prime";
  !nomatch('1'x$_) &&  is_prime($_) and say "$_: yes match but is    prime";
}
