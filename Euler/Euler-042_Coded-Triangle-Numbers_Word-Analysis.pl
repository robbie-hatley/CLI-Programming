#! /usr/bin/perl
# This is an 79-character-wide ASCII-encoded Perl source-code text file.
# =======|=========|=========|=========|=========|=========|=========|=========
###############################################################################
# "Euler-042_Coded-Triangle-Numbers_Word-Analysis.perl"                       #
# Analizes this file:                                                         #
# "Euler-042_Coded-Triangle-Numbers_Words.txt"                                #
# Author: Robbie Hatley.                                                      #
# Edit history:                                                               #
#   Sat Feb 03, 2018: Wrote it.                                               #
###############################################################################
use 5.026_001;
use strict;
use warnings;

my $FH; # file handle
open($FH, '<', 'Euler-042_Coded-Triangle-Numbers_Words.txt') or die;
$/=',';
my @words = map {chomp; s/\"//rg;} readline($FH);
close($FH) or die;
my $MaxLen = 0;
for (@words)
{
   say;
   $MaxLen = length($_) if length($_) > $MaxLen;
}
say "Number of words = ${\scalar @words}";
say "Max word length = $MaxLen";
say "Max word value  = ", 26 * $MaxLen;
