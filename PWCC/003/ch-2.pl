#!/usr/bin/env perl

=pod

The Weekly Challenge 003-2, "Pascal's Triangle"
Solution in Perl by Robbie Hatley, Wed Aug 28, 2024
Problem description: Write a script to generate the first n rows of Pascal's Triangle, for n >= 3.

Note: For practical reasons, I'm limiting this to 3 <= n <= 20, else the printing becomes a nightmare.

=cut

1 != scalar(@ARGV) || $ARGV[0] !~ m/^[1-9][0-9]*$/ || $ARGV[0] < 3 || $ARGV[0] > 20
and die "Error: This program must have exactly 1 argument which must be a positive\n"
       ."integer n from 3 to 20. This program will then print the first n rows of\n"
       ."Pascal's Triangle.";

# Get number of rows:
my $number = $ARGV[0];

# Make a triangle full of ones:
my @PT = ();
push @PT, [(1)x$_] for (1..$number);
for my $row (3..$number) {
   for my $idx (1..$row-2) {
      $PT[$row-1]->[$idx] = $PT[$row-2]->[$idx] + $PT[$row-2]->[$idx-1];
   }
}

for (1..$number) {
   my $format = '   'x($number-$_) . '%6d'x$_ . "\n";
   printf("$format", @{$PT[$_-1]});
}
