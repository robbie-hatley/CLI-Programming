#!/usr/bin/perl
# hailstone-total-stopping-times.pl
# Prints the Total Stopping Times of The Hailstone Sequence for positive-integer seeds from 1 through 100000.

use v5.38;

# Hailstone function:
sub h ($x) {return 0 == $x%2 ? $x/2 : 3*$x+1}

# Print Total Stopping Times for each seed from 1 through 1000:
my $mseed = 1;
my $mstop = 0;
foreach my $seed ( 1..100000 ) {
   my $n = 0;
   my $x = $seed;
   while (1) {
      last if 1 == $x;
      $x = h($x);
      ++$n;
   }
   say "$seed - $n";
   if ($n > $mstop) {$mseed = $seed; $mstop = $n;}
}
say "Seed for maximum stopping time: $mseed - $mstop";
