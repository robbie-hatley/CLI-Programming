#! /usr/bin/perl

# This is an 79-character-wide ASCII-encoded Perl source-code text file.
# =======|=========|=========|=========|=========|=========|=========|=========

###############################################################################
# Euler-048_Self-Powers.perl                                                  #
# Edit history:                                                               #
#    Sun Feb 11, 2018 - Wrote it.                                             #
###############################################################################

use 5.026_001;
use strict;
use warnings;

use bigint;
use Time::HiRes qw( time );

use RH::Util;
use RH::Math;

sub IntPow ($$)
{
   my $b = shift;
   my $x = shift;
   my $result = 1;
   $result *= $b for (1..$x);
   return $result;
}

#main()
{
   my $t0=time();
   my $result = 0;
   for (1..1000)
   {
      $result += IntPow($_,$_);
   }
   say $result;
   say "Elapsed time = ", time()-$t0, " seconds.";
   exit 0;
}
