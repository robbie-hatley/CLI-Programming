#!/usr/bin/env perl

=pod

The Weekly Challenge 004-1, "Pi".
Solution in Perl, written by Robbie Hatley on Wed Aug 28, 2024.

Problem descrition:
Write a script to print as many digits of Pi as there are bytes in the script.

Problem notes:
The size of the script is given by "-s $0", so "bpi($size)" from "bignum" should
do exactly what we want.

=cut

use bignum 'bpi';
my $size = -s $0;
my $Pi = bpi($size);
print "Size of this script = $size\n";
print "First $size digits of Pi = $Pi\n";
