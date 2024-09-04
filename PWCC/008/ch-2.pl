#!/usr/bin/env -S perl -C63

=pod

The Weekly Challenge #008-1: "Center"
Task: Write a script that centers text.

Solution in Perl written by Robbie Hatley on Sun Sep 01, 2024.

=cut

use v5.16; # To get "say".

my @lines = <STDIN>;
my $max = 0;
for ( my $idx = 0 ; $idx <= $#lines ; ++$idx ) {
   $lines[$idx] =~ s/^\s+//; # Cut leading space.
   $lines[$idx] =~ s/\s+$//; # Cut training space (including newline if any).
   my $length = length $lines[$idx];
   if ($length > $max) {$max = $length}
}
for ( my $idx = 0 ; $idx <= $#lines ; ++$idx ) {
   $lines[$idx] = ' ' x (5 + int(($max - length $lines[$idx])/2)) . $lines[$idx];
}
say for @lines;
