#!/usr/bin/env perl

=pod

The Weekly Challenge #011-2: "Identity Matrix"
Task: For any positive integer n given as first argument, print the order-n identity matrix.
Solution in Perl written by Robbie Hatley on Mon Sep 02, 2024.

=cut

sub help {
   print "This program needs exactly one argument, which must be\n"
        ."a positive integer. This program will then print the\n"
        ."identity matrix of that size.\n";
}

for (@ARGV) {
   if ('-h' eq $_ || '--help' eq $_) {
      help;
      exit;
   }
}

if (1 != @ARGV || $ARGV[0] !~ m/^[1-9][0-9]*$/) {
   print "Error: Invalid input.\n";
   help;
   exit;
}

my $n = $ARGV[0];
my @m;
for my $i (0..$n-1) {
   for my $j (0..$n-1) {
      if ($j == $i) {
         $m[$i]->[$j] = 1;
      }
      else {
         $m[$i]->[$j] = 0;
      }
   }
}
$"=' ';
for (@m) {print "@{$_}\n"}
