#!/usr/bin/env -S perl -C63

=pod

The Weekly Challenge #009-1: "Distinct Squares"
Original task: What is the smallest square with 5 distinct decimal digits?
I expanded on that, and found ALL squares with unique digits, and also
note the smallest and greatest in each size group.
Solution in Perl written by Robbie Hatley on Fri Aug 30, 2024.

=cut

use v5.000;
use List::Util 'uniq';
use utf8;
use POSIX 'floor', 'ceil';
$"=', ';

my
(
   $lower, $upper, $base, $num_squares,
   $smallest_square, $smallest_base,
   $greatest_square, $greatest_base,
);
my @squares;

for my $digits (1..10) {
   @squares = ();
   if (1 == $digits) {$lower = 0}
   else {$lower = ceil(sqrt(10**($digits-1)))}
   $upper = floor(sqrt(10**$digits-1));
   for my $base ($lower..$upper) {
      my $square = $base**2;
      push @squares, $square if $digits == scalar uniq sort split '', $square;
   }
   $num_squares = scalar @squares;
   $smallest_square = $squares[0];
   $smallest_base   = sqrt $smallest_square;
   $greatest_square = $squares[-1];
   $greatest_base   = sqrt $greatest_square;
   print "\n";
   print "-------------------------------------------------------------------------------\n";
   print "digits = $digits   lower = $lower   upper = $upper\n";
   print "Found $num_squares squares with $digits unique digits:\n";
   print "@squares\n";
   print "The smallest of these is $smallest_base² = $smallest_square.\n";
   print "The greatest of these is $greatest_base² = $greatest_square.\n";
}

