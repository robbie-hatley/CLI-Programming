#! /bin/perl
# dna.pl
use v5.32;
my $dna='GTAAACCCCTTTTCATTTAGACAGATCGACTCCTTATCCATTCTCAGAGATGTGTTGCTGGTCGCCG';
say 'DNA = ', $dna;
printf("%d cytosine\n", scalar(@{[$dna =~ m/C/g]}));
printf("%d guanine\n",  scalar(@{[$dna =~ m/G/g]}));
printf("%d adenine\n",  scalar(@{[$dna =~ m/A/g]}));
printf("%d thymine\n",  scalar(@{[$dna =~ m/T/g]}));
print 'complement = ', $dna =~ tr/TAGC/ATCG/r;

=pod

Nucleobases:
cytosine (C)
guanine  (G)
adenine  (A)
thymine  (T)

Complements:
T => A
A => T
C => G
G => C

=cut

