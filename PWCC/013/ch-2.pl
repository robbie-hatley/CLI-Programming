#!/usr/bin/env perl

=pod

The Weekly Challenge #013-2: "Hofstadter Male Female"
Task: Write a script which uses mutually-recursive subroutines
to generate Hofstadter Female and Male sequences.

=cut

use v5.36;

my @f;
my @m;
sub fem;
sub mal;
sub fem ($n) {
   if ($n>0) {$f[$n] = $n-mal(fem($n-1))}
   else      {$f[$n] = 1            }
}
sub mal ($n) {
   if ($n>0) {$m[$n] = $n-fem(mal($n-1))}
   else      {$m[$n] = 0            }
}
fem(20);
mal(20);
$"=', ';
say "\@f = @f";
say "\@m = @m";
