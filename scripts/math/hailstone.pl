#!/usr/bin/perl
# hailstone.pl
use v5.10;
sub h {my $x = shift; return 0==$x%2 ? $x/2 : 3*$x+1}
exit if @ARGV != 1;
my $x=$ARGV[0];
exit if $x !~ m/^[1-9]\d*$/;
my $n;
for ($n=0;say($x),1!=$x;++$n) {$x=h($x)}
say "Total Stopping Time = ", $n;
