#! /usr/bin/perl
# Euler-048_Self-Powers_V4.perl
# Written Sun Feb 11, 2018 by Robbie Hatley
use 5.026_001;
no strict;
no warnings;
use Math::BigInt;
use Time::HiRes qw( time );
my $t0=time();
my $result    = Math::BigInt->new(0);
my $base      = Math::BigInt->new(1);
my $exponent  = Math::BigInt->new(1);
my $power     = Math::BigInt->new(1);

foreach (1..1000)
{
   $base     = Math::BigInt->new($_);
   $exponent = $base;
   $power    = $base->bpow($exponent);
   $result += $power;
}

say $result % Math::BigInt->new(10000000000);
say "Elapsed time = ", time()-$t0, " seconds.";
exit 0;
