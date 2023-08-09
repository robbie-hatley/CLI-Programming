#! /usr/bin/perl
# Euler-048_Self-Powers_V5.perl
# Written Sun Feb 11, 2018 by Robbie Hatley
use 5.026_001;
use strict;
use warnings;
use bigint;
use Time::HiRes qw( time );
my $t0       = time();
my $result   = 0;
my $base     = 1;
foreach (1..1000)
{
   $base = Math::BigInt->new($_);
   $result += $base->bpow($base);
}
say $result % 10000000000;
say "Elapsed time = ", time()-$t0, " seconds.";
exit 0;
