#!/usr/bin/env perl

=pod

The Weekly Challenge 003-1, "Regular Numbers"
Solution in Perl by Robbie Hatley, Wed Aug 28, 2024
Problem description: Write a script to generate "Regular Numbers", aka "5-Smooth Numbers". These are formally
defined as "integers of the form 2^i*3^j*5^k for non-negative integers i,j,k. The smallest Regular Number is
thus 1, which is 2^0*3^0*5^0.

=cut

1 != scalar(@ARGV) || $ARGV[0] !~ m/^[1-9][0-9]*$/ || $ARGV[0] > 1000000000
and die "Error: This program must have exactly 1 argument which must be a positive\n"
       ."integer from 1 to 1 billion. This program will then print all Regular Numbers\n"
       ."from 1 through that given upper limit.";

my $upper = $ARGV[0];
for (1..$upper) {
   my $test = $_;
   $test/=2 while 0==$test%2;
   $test/=3 while 0==$test%3;
   $test/=5 while 0==$test%5;
   print "$_\n" if 1==$test;
}
