#!/usr/bin/env -S perl -CSDA

# print-comments-loquacious.pl

use v5.38;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';
use List::Util 'uniq';

# Get lines of text from STDIN and/or files given as arguments:
my @lines = <>;

# Chomp newlines from ends of all lines:
my @chomped = map {chomp,$_} @lines;

# Select only lines consisting only of comments:
my @comments = grep {/^\s*#/} @chomped;

# Sort those lines:
my @sorted = sort {$a cmp $b} @comments;

# Get rid of any duplicates:
my @unique = uniq @sorted;

# Print result:
for my $line (@unique) {say $line;}
