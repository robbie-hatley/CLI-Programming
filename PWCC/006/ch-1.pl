#!/usr/bin/env perl

=pod

The Weekly Challenge 006-1, "Compact Number List".
Solution in Perl written by Robbie Hatley on Fri Aug 30, 2024.

=cut

use v5.16;

@ARGV < 2
   and die "Error: Must have a space-separated list of 2-or-more integers as arguments.\n";
for (@ARGV) {
   $_ !~ m/^-[1-9][0-9]*$|^0$|^[1-9][0-9]*$/
   and die "Error: Must have a space-separated list of 2-or-more integers as arguments.\n";
}

my @numbers = @ARGV;

use constant {
   BEG_SEG => 0,
   CNT_SEG => 1,
};

my $state = BEG_SEG;
my $seg_start;
my $prev;
my $number;
my @segments;
my $output = '';

for $number (@numbers) {
   if    (BEG_SEG == $state) {
      $seg_start = $number;
      $prev = $number;
      $state = CNT_SEG;
   }
   elsif (CNT_SEG == $state) {
      if ($number == $prev+1) {
         $prev = $number;
         $state = CNT_SEG;
      }
      else {
         $prev == $seg_start and push @segments, "$prev"
         or push @segments, "$seg_start-$prev";
         $seg_start = $number;
         $prev = $number;
         $state = BEG_SEG;
      }
   }
}

# Handle final numbers:
# If list ends with a single orphan, push that single number to @segments:
if    (BEG_SEG == $state) {
   push @segments, "$number";
}
# Else if list ends with 2-or-more orphans, push that range or those numbers to @segments:
elsif (CNT_SEG == $state) {
   # If segment continues to be unfractured, push range to @segments:
   if ($number == $prev+1) {
      push @segments, "$seg_start-$number"
   }
   # Else if last number is a discontinuity, push previous numbers-or-range to @segments,
   # then push final number to @segments:
   else {
      $prev == $seg_start and push @segments, "$prev"
      or  push @segments, "$seg_start-$prev";
   }
}

# Print @segments interpolated into a single string:
$"=',';
say "@segments";
