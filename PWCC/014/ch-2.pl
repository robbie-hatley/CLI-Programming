#!/usr/bin/env -S perl -C63

=pod

The Weekly Challenge #014-2: "CA-LA-MA-RI"
Using only the 50 standard USA postal abbreviations for states,
what English words, 10 letters or less, can one spell using them?

Solution in Perl written by Robbie Hatley on Mon Sep 02, 2024.

=cut

use v5.36;
use utf8;
use List::Util 'any';
$"=', ';

# Declare arrays:
my @states; my @words; my @state_words;

# Get states:
@states =
(
   "al", "ak", "az", "ar", "ca", "co", "ct", "de", "dc", "fl", "ga", "hi", "id",
   "il", "in", "ia", "ks", "ky", "la", "me", "md", "ma", "mi", "mn", "ms", "mo",
   "mt", "ne", "nv", "nh", "nj", "nm", "ny", "nc", "nd", "oh", "ok", "or", "pa",
   "pr", "ri", "sc", "sd", "tn", "tx", "ut", "vt", "va", "wa", "wv", "wi", "wy",
);
my $num_states = scalar(@states);
say "Loaded $num_states states.";

# Get words:
my $fh=undef;
open ($fh, '<', 'words.txt');
if ($fh) {
   for my $word (<$fh>) {
      $word =~ s/^\s+//;  # Strip all leading  whitespace.
      $word =~ s/\s+$//;  # Strip all trailing whitespace.
      push @words, $word; # Push stripped word to end of @words.
   }
   close $fh;
}
else {
   die "Error: couldn't read  file \"words.txt\".\n";
}
my $num_words = scalar(@words);
say "Loaded $num_words words.";
say "38754th word = \"$words[38754]\".";
say "123456th word = \"$words[123456]\".";

# Subroutines:
my $cand_count = 0;
sub make_state_words; # Must pre-declare this subroutine because it's recursive.
sub make_state_words ($root) {
   for my $state (@states) {
      my $candidate = $root.$state;
      ++$cand_count;
      if (1 == $cand_count % 10_000) {say "...processing candidate #$cand_count...";}
      if (any {$_ eq $candidate} @words) {say $candidate; push @state_words, $candidate}
      if (length($candidate) < 6) {make_state_words $candidate}
   }
}

# Main body of program:
say 'The English words of length 2, 4, or 6 which can be made'; # 6, 8, or 10 which can be made';
say 'by concatenating US postal state abbreviations are:';
make_state_words('');
say "@state_words";
