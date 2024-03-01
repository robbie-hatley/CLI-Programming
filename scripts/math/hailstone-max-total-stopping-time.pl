#!/usr/bin/perl
# hailstone-total-stopping-time.pl
# Prints maximum Total Stopping Time for Hailstone Sequences for seeds from 1 through given limit.

use v5.38;

# Bail if number of arguments isn't 1:
exit if 1 != scalar @ARGV;

# Get argument:
my $limit=$ARGV[0];

# Bail if argument isn't a positive integer:
exit if $limit !~ m/^[1-9]\d*$/;

# Hailstone function:
sub h ($x) {return 0 == $x%2 ? $x/2 : 3*$x+1}

# Print maximum Total Stopping Time for seeds from 1 through $limit:
my $mseed = 1;
my $mstop = 0;
foreach my $seed ( 1..$limit ) {
   my $n = 0;
   my $x = $seed;
   while (1) {
      last if 1 == $x;
      $x = h($x);
      ++$n;
   }
   if ($n > $mstop) {$mseed = $seed; $mstop = $n;}
}
say "Seed under $limit for maximum stopping time: $mseed - $mstop";
