#!/usr/bin/env perl
use v5.36;
use constant EULER => 0.5772156649;
exit if 1 != scalar(@ARGV);
my $n = $ARGV[0];
my $sum = 0;
for my $i (1..$n) {$sum += 1/$i}
my $approx = log($n+1) + EULER*(1-1/($n+1));
say "Sum    = $sum";
say "Approx = $approx";
