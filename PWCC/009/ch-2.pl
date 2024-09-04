#!/usr/bin/env -S perl -C63

=pod

The Weekly Challenge #009-2: "Rankings"
Task: Write a script to provide Standard (1224), Modified (1334),
and Dense (1223) rankings.

=cut

use v5.16; # To get "fc" and "say".
use utf8;
$"=', ';

for (@ARGV) {
   /^-h$|^--help$/
   and print "This program, given a list of strings, one per line, on STDIN,\n"
            ."prints the Standard, Modified, and Dense rankings of those strings.\n"
   and exit;
}

my @lines = sort map {fc $_} map {$_ =~ s/\s+$//r} <STDIN>;

my $prev_seg_len   = 1;
my $curr_seg_len   = 1;
my $seg_start_idx  = 0;
my $r1224          = 0;
my $r1334          = 0;
my $r1223          = 0;
my %ranking; $ranking{$_} = [0,0,0] for @lines;

for my $i (0..$#lines) {
   # If we're at the end, or if next item differs from current item, update current segment length,
   # set ranks for this range, push to %ranking, save $curr_seg_len in $prev_seg_len,
   # and set start index for next segment:
   if ($i == $#lines || $lines[$i+1] ne $lines[$i]) {
      $curr_seg_len = $i - $seg_start_idx + 1;
      $r1224 = $r1224 + $prev_seg_len;
      $r1334 = $r1334 + $curr_seg_len;
      $r1223 = $r1223 + 1;
      for my $j ($seg_start_idx..$i) {
         $ranking{$lines[$j]}->[0] = $r1224;
         $ranking{$lines[$j]}->[1] = $r1334;
         $ranking{$lines[$j]}->[2] = $r1223;
      }
      $prev_seg_len = $curr_seg_len;
      $seg_start_idx = $i + 1;
   }
}

# Print ranking:
printf("  Std  Mod  Dns  Item\n");
for my $item (@lines) {
   printf("%5d%5d%5d  %s\n", $ranking{$item}->[0], $ranking{$item}->[1], $ranking{$item}->[2], $item);
}
