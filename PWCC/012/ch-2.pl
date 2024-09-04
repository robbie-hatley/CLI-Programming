#!/usr/bin/env -S perl -C63

=pod

The Weekly Challenge #012-2: "Common Directory Path"
Solution in Perl written by Robbie Hatley on Mon Sep 02, 2024.

=cut

use v5.16;
use utf8;
use List::Util 'min';
$"=', ';
my @paths = @ARGV;
$_ =~ s/^\s+// for @paths;
$_ =~ s/\s+$// for @paths;
my $numps = scalar(@paths);
my @subds;
for my $i (0..$#paths) {
   my $path = $paths[$i];
   $path =~ s#^/+##;
   $path =~ s#/+$##;
   push @{$subds[$i]}, split '/', $path;
}
my $depth = min map {scalar(@$_)} @subds;
my $same = 0;
I: for my $i (0..$depth-1) {
   J: for my $j (1..$numps-1) {
      if ($subds[$j]->[$i] ne $subds[0]->[$i]) {
         $same = $i-1;
         last I;
      }
      else {
         $same = $i;
      }
   }
}
my $common = '';
for my $k (0..$same) {$common = $common . '/' . $subds[0]->[$k]}
if ('' eq $common) {$common = '/';}
say $common;
