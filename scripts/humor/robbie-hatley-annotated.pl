#! /bin/perl

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks (\x{0A}).
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

# "big-int-2.pl"

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

use common::sense;
use bigint;
# my $n = 0x79656C74614820656962626F52;
#            y e l t a H   e i b b o R
# Then convert that back to decimal:
my $n=9617996763795502534212842581842;
my $m=-8;$_=$n&(0xff)<<$m,$_>>=$m,
print chr while(($m+=8)<=96);print "\n";
