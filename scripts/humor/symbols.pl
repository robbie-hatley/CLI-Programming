#! /bin/perl -CSDA

# This is an 120-character-wide UTF-8-encoded Perl script source-code text file.
# ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# symbols.pl
# Prints various symbols.
# Edit history:
# Thu Mar 04, 2021:
#    Wrote it.
########################################################################################################################

use v5.32;
use strict;
use warnings;
use warnings FATAL => "utf8";
use utf8;

use RH::Util;
use RH::Dir;

my %Scripts;

push @{$Scripts{Alchemy}}, 0x1F700..0x1F773;

push @{$Scripts{Ancient}}, 0x10190..0x101A0;

push @{$Scripts{Transport}}, 0x1F680..0x1F6D7, 0x1F6E0..0x1F6EC, 0x1F6F0..0x1F6FC;

for my $key (sort keys %Scripts)
{
   printf("%-13s", ($key.':')); say join '', map {chr $_} @{$Scripts{$key}};
}
