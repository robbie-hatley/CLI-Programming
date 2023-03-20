#! /bin/perl
# deg2rad.pl
use v5.36;
use Math::Trig;
sub DegToRad ($deg) {return pi * $deg / 180;}
exit if 1 != @ARGV;
say DegToRad($ARGV[0]);
