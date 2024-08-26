#!/usr/bin/env perl

# TITLE AND ATTRIBUTION:
# Solutions in Perl for The Weekly Challenge 002-2,
# written by Robbie Hatley on Sat Aug 24, 2024.

# PROBLEM DESCRIPTION:
# Task 002-2:
# Write a script that can convert integers to and from a base35 representation,
# using the characters 0-9 and A-Y.

# PROBLEM NOTES:
# Just the usual place-value system, but in different bases. I think I'll write
# a script that can convert between any bases in the range 2-62.

# IO NOTES:
# Input is via @ARGV. First arg is "from" base (in decimal), second arg is
# "to" base (in decimal), and all subsequent args are integers to be converted.

sub help {
   warn ((<<'   END_OF_HELP') =~ s/^   //gmr);

   Welcome to Robbie Hatley's nifty number base converter.
   This program needs at least 3 arguments:
   The first  argument is "base to be converted from", 2-62, in decimal.
   The second argument is "base to be converted to"  , 2-62, in decimal.
   All remaining arguments are positive integers to be converted, using digits
   0-9,A-Z,a-z in increasing order of value.
   END_OF_HELP
}

for my $arg (@ARGV) {
   if ('--help' eq $arg || '-h' eq $arg) {help; exit 777;}
}

@ARGV < 3
and warn "\nError: insufficient number of arguments.\n" and help and exit 666;

for (@ARGV) {
   $_ !~ m/^-[1-9A-Za-z][0-9A-Za-z]*$|^0$|^[1-9A-Za-z][0-9A-Za-z]*$/
   and warn "\nError: invalid characters in one-or-more arguments.\n" and help and exit 666;
}

my $base1 = shift @ARGV;
$base1 !~ m/^[1-9][0-9]*$/ || $base1 < 2 || $base1 > 62
and warn "\nError: First  base must be decimal integer 2-62.\n" and help and exit 666;

my $base2 = shift @ARGV;
$base2 !~ m/^[1-9][0-9]*$/ || $base2 < 2 || $base2 > 62
and warn "Error: second base must be decimal integer 2-62.\n" and help and exit 666;

my %value =
(
   '0' =>  0, '1' =>  1, '2' =>  2, '3' =>  3, '4' =>  4, '5' =>  5,
   '6' =>  6, '7' =>  7, '8' =>  8, '9' =>  9, 'A' => 10, 'B' => 11,
   'C' => 12, 'D' => 13, 'E' => 14, 'F' => 15, 'G' => 16, 'H' => 17,
   'I' => 18, 'J' => 19, 'K' => 20, 'L' => 21, 'M' => 22, 'N' => 23,
   'O' => 24, 'P' => 25, 'Q' => 26, 'R' => 27, 'S' => 28, 'T' => 29,
   'U' => 30, 'V' => 31, 'W' => 32, 'X' => 33, 'Y' => 34, 'Z' => 35,
   'a' => 36, 'b' => 37, 'c' => 38, 'd' => 39, 'e' => 40, 'f' => 41,
   'g' => 42, 'h' => 43, 'i' => 44, 'j' => 45, 'k' => 46, 'l' => 47,
   'm' => 48, 'n' => 49, 'o' => 50, 'p' => 51, 'q' => 52, 'r' => 53,
   's' => 54, 't' => 55, 'u' => 56, 'v' => 57, 'w' => 58, 'x' => 59,
   'y' => 60, 'z' => 61,
);

my %repre =
(
    0 => '0',  1 => '1',  2 => '2',  3 => '3',  4 => '4',  5 => '5',
    6 => '6',  7 => '7',  8 => '8',  9 => '9', 10 => 'A', 11 => 'B',
   12 => 'C', 13 => 'D', 14 => 'E', 15 => 'F', 16 => 'G', 17 => 'H',
   18 => 'I', 19 => 'J', 20 => 'K', 21 => 'L', 22 => 'M', 23 => 'N',
   24 => 'O', 25 => 'P', 26 => 'Q', 27 => 'R', 28 => 'S', 29 => 'T',
   30 => 'U', 31 => 'V', 32 => 'W', 33 => 'X', 34 => 'Y', 35 => 'Z',
   36 => 'a', 37 => 'b', 38 => 'c', 39 => 'd', 40 => 'e', 41 => 'f',
   42 => 'g', 43 => 'h', 44 => 'i', 45 => 'j', 46 => 'k', 47 => 'l',
   48 => 'm', 49 => 'n', 50 => 'o', 51 => 'p', 52 => 'q', 53 => 'r',
   54 => 's', 55 => 't', 56 => 'u', 57 => 'v', 58 => 'w', 59 => 'x',
   60 => 'y', 61 => 'z',
);

INPUT: for my $input (@ARGV) {
   my $value = 0;
   my @digits = reverse split '', $input;
   for my $digit (@digits) {
      !defined($value{$digit}) || $value{$digit} > $base1 - 1
      and warn "\nError: $input is not a valid number in base $base1;\nMoving on to next input."
      and next INPUT;
   }
   for my $idx (0..$#digits) {
      $value += $value{$digits[$idx]} * $base1 ** $idx;
   }
   my $output = '';
   my $width = int(log($value)/log($base2));
   for my $idx (0..$width) {
      $output .= $repre{int($value/$base2**($width-$idx))%$base2};
   }
   print "Base $base1 number $input converted to base $base2 = $output\n";
}
