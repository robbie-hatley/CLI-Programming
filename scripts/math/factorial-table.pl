#!/usr/bin/perl

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks (\x{0A}).
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

# "factorial-table.pl"

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

use Math::BigInt;
scalar(@ARGV) >= 1 && $ARGV[0] =~ m/^\d+$/
or die "Error: this program requires one argument, which must be a non-negative\n".
       "integer. This program will print the factorials of all integers from 1\n".
       "through that number.\n";
my $n = $ARGV[0];
my $x = Math::BigInt->new(1);
printf("%3d! = %125s\n", $_, $x *= $_) for 1 .. $n;
