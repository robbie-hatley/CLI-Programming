#! /bin/perl

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks (\x{0A}).
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

################################################################
# "comb.pl"
# Prints number of combinations of n things taken k at a time.
# Edit history:
#    Sun Feb 28, 2016 - Wrote it.
################################################################

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

use Math::BigInt;

my $n = Math::BigInt->new($ARGV[0]);
my $k = Math::BigInt->new($ARGV[1]);
my $nok = $n->copy()->bnok($k);
say "$n comb $k = $nok";
exit 0;
