#! /bin/perl

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks (\x{0A}).
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

# "factorials.pl"

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

use Math::BigInt;

@ARGV == 2 && $ARGV[0] =~ m/^\d+$/ && $ARGV[1] =~ m/^\d+$/ && $ARGV[0] < $ARGV[1]
or die "Error: this program requires two arguments, which must be non-negative integers\n".
       "with the second greater than the first. This program will print the factorials\n".
       "of all numbers from the first argument to the second argument.\n";

my $m = $ARGV[0];
my $n = $ARGV[1];

foreach ( $m .. $n )
{
   say "$_! = ", Math::BigInt->bfac($_);
}

exit 0;
