#!/usr/bin/env -S perl -CSDA

=pod

The Weekly Challenge 004-2, "Can Make".
Solution in Perl, written by Robbie Hatley on Wed Aug 28, 2024.

Problem description:
You are given a file containing a list of words, one word per
line, and a list of letters. Print each word from the file that
can be made using only letters from the list (case-shifted if
necessary). You can use each letter instance in the letter list
only once. There can be duplicate letters in the letter list and
you can use each of them at most once. You don’t have to use all
the letters. This challenge was proposed by Scimon Proctor.

Problem notes:
I'll pass the file to the program via STDIN.
The letter list, I'll pass-in via $ARGV[0].

=cut

use v5.15;

1!=scalar(@ARGV) || $ARGV[0] !~ m/^[a-zA-Z]+$/
and die "Error: This program must have 1 argument which must be a cluster of letters.\n";
my $list = $ARGV[0];
my $l    = fc $list;
my @l    = split '', $l;
my %l; ++$l{$_} for @l;
WORD: foreach my $word (<STDIN>) {
   chomp $word;
   my $f = fc $word;
   my @f = split '', $f;
   my %f; ++$f{$_} for @f;
   LETTER: foreach my $letter (keys %f) {
      next WORD if $f{$letter} > $l{$letter};
   }
   say $word;
}
