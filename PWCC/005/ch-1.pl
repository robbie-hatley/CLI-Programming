#!/usr/bin/env perl

=pod

The Weekly Challenge #004, "Anagram".
Solution in Perl, written by Robbie Hatley on Wed Aug 28, 2024.

Problem description:
For a given word, print all of its anagrams.

Problem notes:
Not all permutations are unique anagrams. For example, "Robbie" (with the first and second letters "b"
swapped) is a permutation of "Robbie" (with the first and second letters "b" in their original locations),
but it's not an anagram of "Robbie", it's the same word. Also, let's stipulate that "rObBiE" and "RoBbIe"
are the same "word". So for each incoming line from STDIN, let's first remove all whitespace, then apply
fold-case, before finding permutations.

As for how to find permutations, I'll use "permute" from "Math::Combinatorics".

=cut

use v5.36;
use Math::Combinatorics 'permute';
use List::Util 'uniq';

sub anagrams :prototype($) ($word) {
   uniq sort map {join '', @$_} permute split '', $word;
}

foreach my $word (<STDIN>) {
   $word =~ s/\s+//g;
   $word = fc $word;
   my @anagrams = anagrams $word;
   my $num_ana = scalar @anagrams;
   say '';
   say "The word \"$word\" has $num_ana anagrams:";
   say for @anagrams;
}
