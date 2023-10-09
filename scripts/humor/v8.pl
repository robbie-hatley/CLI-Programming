#!/usr/bin/perl
# Script: "v8.pl".
# Description: Prints all possible firing orders for a V8 gasoline engine.
use v5.10;
use Math::Combinatorics;
my $perms = Math::Combinatorics->new(count => 8, data => [1,2,3,4,5,6,7,8]);
while (my @perm = $perms->next_permutation) {say '(', join(', ', @perm), ')'}
