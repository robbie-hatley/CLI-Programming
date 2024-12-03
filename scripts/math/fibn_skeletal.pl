#!/usr/bin/env perl
my $n = $ARGV[0];
print((((1+sqrt(5))/2)**($n+1)-((1-sqrt(5))/2)**($n+1))/sqrt(5));
