#!/usr/bin/env perl

=pod

The Weekly Challenge 006-1, "Compact Number List".
Solution in Perl written by Robbie Hatley on Fri Aug 30, 2024.

=cut

use v5.16; # To get "say".
$"=',';
my $db = 0;

for (@ARGV) {
   /^-h$|^--help$/
   and print "This program, given a space-separated sequence of integers as arguments,\n"
            ."prints the sequence as a \"Compact Number List\".\n";
}

my @numbers = @ARGV;

$db and say '';
$db and say "\@numbers = \"@numbers\"";
$db and say '';

use constant {
   BEG_SEG => 1, # Set $state to this to indicate that next index  begins   a segment.
   CNT_SEG => 2, # Set $state to this to indicate that next index continues a segment.
};

my $state = BEG_SEG;
my $seg_start_idx;
my @segments;
my $output = '';

for my $idx (0..$#numbers) {
   # If we're at the beginning of a segment:
   if    (BEG_SEG == $state) {
      $db and say "\$state = BEG_SEG, \$idx = $idx, \$numbers[\$idx] = $numbers[$idx]";
      $seg_start_idx = $idx;
      # If we're at the end, push this solo orphan onto @segments:
      if ($idx == $#numbers) {
         push @segments, "$numbers[$idx]";
         ; # Don't change states; the time for states has passed.
      }
      # If we're NOT at the end, set state depending on whether next number is 1 + current number:
      else {
         # If next number is a continuation, set state to CNT_SEG:
         if ((1 + $numbers[$idx]) == $numbers[$idx+1]) {
            ; # Don't push; we're not done creating this range.
            $state = CNT_SEG;
         }
         # Otherwise, push this orphan to @segments and set state to BEG_SEG:
         else {
            push @segments, "$numbers[$idx]";
            $state = BEG_SEG;
         }
      }
   }

   # Else if we're in a continuation of a segment:
   elsif (CNT_SEG == $state) {
      $db and say "\$state = CNT_SEG, \$idx = $idx, \$numbers[\$idx] = $numbers[$idx]";
      # If we're at the end, push this current range onto @segments:
      if ($#numbers == $idx) {
         push @segments, "$numbers[$seg_start_idx]-$numbers[$idx]";
         ; # Don't change states; the time for states has passed.
      }
      # If we're NOT at the end, set state depending on whether next number is 1 + current number:
      else {
         # If next number is a continuation, leave state set to CNT_SEG:
         if ((1 + $numbers[$idx]) == $numbers[$idx+1]) {
            ; # Don't push; we're not done creating this range.
            ; # Don't change state; leave it set to CNT_SEG.
         }
         # Otherwise, push this range to @segments and set state to BEG_SEG:
         else {
            push @segments, "$numbers[$seg_start_idx]-$numbers[$idx]";
            $state = BEG_SEG;
         }
      }
   }

   # We can't possibly get here. But if we do:
   else {
      die "Hello, hello! Nice to meet you, Voice Inside My Head!\n"
         ."Hello, hello! I believe you! How can I forget?!\n"
         ."Is this a place that I call home? To find what I've become?\n"
         ."Walk along the path unknown! We live, we love, we lie!\n"
   }
}

# Print @segments interpolated into a single string:
say "@segments";
