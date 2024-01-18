#!/usr/bin/env -S perl -CSDA
# hailstone.pl
use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';
sub c($x) {0 == $x%2 and return $x/2 or  return 3*$x+1}
exit if @ARGV != 1;
my $x=$ARGV[0];
exit if $x !~ m/^[1-9]\d*$/;
my $n;
for($n=0;say($x),1!=$x;++$n){$x=c($x)}
say "Total Stopping Time = ", $n;
