#!/usr/bin/env perl
# is-prime-regexp.pl
# Finds primes using a regexp.
# Written by Robbie Hatley on
# Sat Nov 02, 2024.
use utf8;
1 != @ARGV || $ARGV[0] !~ m/^0$|^[1-9]\d*$/ and die
"Must have one non-negative integer argument.";
('茶'x$ARGV[0]) =~ m/^.?$|^(..+?)\1+$/
and print "composite\n"
or  print "prime\n";
