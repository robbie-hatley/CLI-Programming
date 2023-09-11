#!/usr/bin/perl

# This is an 120-character-wide ASCI Perl source-code text file.
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# /rhe/scripts/util/grawlix.pl
# Generates 200 grawlix.
# Edit history:
#    Wed Apr 29, 2015 - Wrote it.
#    Fri Jul 17, 2015 - Upgraded for utf8.
#    Wed Dec 27, 2017 - Reverted to ASCII; moved to humor.
########################################################################################################################

use v5.32;
use strict;
use warnings;

use RH::Util;

our $symbols = '^*@@&&$$%%??!!!#';

for (1...200)
{
   print substr($symbols, rand_int(0,length($symbols)-1), 1);
}
