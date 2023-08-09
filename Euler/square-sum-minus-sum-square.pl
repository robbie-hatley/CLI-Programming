#!/usr/bin/perl
#square-sum-minus-sum-square.perl
use v5.022;
use strict;
use warnings;
my $sumsqr = 0;
my $sum    = 0;
my $sqrsum = 0;
for (1...$ARGV[0])
{
   $sum    += $_;
   $sumsqr += $_**2;
}
$sqrsum = $sum**2;
say $sqrsum - $sumsqr;
exit 0;
