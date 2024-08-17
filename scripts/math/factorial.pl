#!/usr/bin/perl

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

# factorial.pl (currently identical to factorial-bfac.pl except no benchmarking)

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

use common::sense;
use Math::BigInt;
scalar(@ARGV) >= 1 && $ARGV[0] =~ m/^\d+$/
or die "Error: This program requires one argument, which must be a non-negative\n"
     . "integer. This program will then print the factorial of that number.\n";
my $x = $ARGV[0];
my $f = Math::BigInt->bfac($x);
say "$x! = $f";
exit 0;
