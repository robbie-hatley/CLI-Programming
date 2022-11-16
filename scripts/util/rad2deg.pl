#! /usr/bin/perl
# rad2deg.pl
use v5.36;
use Math::Trig;
sub RadToDeg ($rad) {return 180 * $rad / pi;}
exit if 1 != @ARGV;
say RadToDeg($ARGV[0]);
