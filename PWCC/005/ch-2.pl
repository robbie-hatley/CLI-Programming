#!/usr/bin/env perl

=pod

The Weekly Challenge #004, "Most Anagrams".
Solution in Perl, written by Robbie Hatley on Wed Aug 28, 2024.

Problem description:
Of the lines of text from STDIN, which has the most unique anagrams
(after removing all whitespace and converting to fold-case)?
(Submitted by Neil Bowers.)

Problem notes:
Not all permutations are unique anagrams. For example, "Robbie" (with the first and second letters "b"
swapped) is a permutation of "Robbie" (with the first and second letters "b" in their original locations),
but it's not an anagram of "Robbie", it's the same word. Also, let's stipulate that "rObBiE" and "RoBbIe"
are the same "word". So for each incoming line from STDIN, let's first remove all whitespace, then apply
fold-case, before finding permutations.

As for how to find permutations, I'll use "permute" from "Math::Combinatorics".

Then it's just a matter of recording which of the lines from STDIN has the most unique anagrams. (If two
words have the same number of anagrams, the first one wins.)

=cut

use v5.36;
use Math::Combinatorics 'permute';
use List::Util 'uniq';

sub anagrams :prototype($) ($word) {
   uniq sort map {join '', @$_} permute split '', $word;
}

my $max_ana = 0;
my $max_wrd = '';
foreach my $word (<STDIN>) {
   $word =~ s/\s+//g;
   $word = fc $word;
   my @anagrams = anagrams $word;
   my $num_ana = scalar @anagrams;
   $num_ana > $max_ana and $max_ana = $num_ana and $max_wrd = $word;
}
say "The word \"$max_wrd\" has $max_ana anagrams."
