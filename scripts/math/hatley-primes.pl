#!/usr/bin/perl

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks (\x{0A}).
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

# hatley-primes.pl

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

use experimental 'switch';
use bigint;

use RH::Math;

my $n          = 0+1;    # exponent for 30
my $candidate  = 0;      # Candidate for primeness.
my $isprime    = 0;      # Is 30^n-1 prime?

for ( $n = 1 ; $n < 100 ; ++$n )
{
   $candidate = 2**$n - 1;
   say "Candidate = $candidate";
   $isprime   = is_prime($candidate);
   printf("%100s", $candidate);
   $isprime ? printf(" is prime.\n")
            : printf(" is composite.\n");
}
