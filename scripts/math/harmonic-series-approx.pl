#!/usr/bin/env perl
use bignum;
use constant EULER => 0.5772156649;
exit if 1 != scalar(@ARGV);
my $n = $ARGV[0];
printf("%lf\n", log($n+1) + EULER*(1-1/($n+1)));
