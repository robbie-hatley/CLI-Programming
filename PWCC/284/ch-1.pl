#!/usr/bin/env perl

# TITLE AND ATTRIBUTION:
# Solutions in Perl for The Weekly Challenge 284-1,
# written by Robbie Hatley on Sun Aug 25, 2024.

# PROBLEM DESCRIPTION:
# Task 284-1: Lucky Integer
# Submitted by: Mohammad Sajid Anwar
# You are given an array of integers, @ints. Write a script to
# find the lucky integer if found otherwise return -1. If there
# are more than one then return the largest. A lucky integer is
# an integer that has a frequency in the array equal to its
# value.

# PROBLEM NOTES:
# Abundance, pushing, and popping will be involved.

use List::Util 'uniqint';
sub lucky_integer {
   my %abundance; ++$abundance{$_} for @_;
   my @unique = uniqint sort {$a<=>$b} @_;
   my @lucky = (-1); for (@unique) {push @lucky, $_ if $_ == $abundance{$_}}
   pop @lucky;
}

my @arrays = @ARGV ? eval($ARGV[0]) : ([2, 2, 3, 4],[1, 2, 2, 3, 3, 3],[1, 1, 1, 3]);
#                                          2                  3             -1

for my $aref (@arrays) {
   my @array = @$aref;
   my $lucky = lucky_integer @array;
   print "\n";
   print "Array = @array\n";
   print "Lucky Number = $lucky\n";
}
