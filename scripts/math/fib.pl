#!/usr/bin/perl

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

# "fib.pl"

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

use bignum;

@ARGV >= 1 && $ARGV[0] =~ m/^\d+$/ && $ARGV[0] >= 3
or die "Error: this program requires one arguments, which must be a non-negative\n".
       "integer n >= 3. This program will then print the first n elements of\n".
       "The Fibonacci Sequence.\n";

my $n = $ARGV[0];
my $i = 1;
my $j = 1;
my $k;

printf("%125s\n", $i);
printf("%125s\n", $j);
foreach ( 3 .. $n )
{
   $k = $i + $j;
   printf("%125s\n", $k);
   $i = $j;
   $j = $k;
}
