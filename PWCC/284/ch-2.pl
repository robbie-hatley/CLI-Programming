#!/usr/bin/env perl

# TITLE AND ATTRIBUTION:
# Solutions in Perl for The Weekly Challenge 284-2,
# written by Robbie Hatley on Sun Aug 25, 2024.

# PROBLEM DESCRIPTION:
# Task 284-2: You are given two list of integers, @list1 and
# @list2. The elements in the @list2 are distinct and also in the
# @list1. Write a script to sort the elements in the @list1 such
# that the relative order of items in @list1 is same as in the
# @list2. Elements that is missing in @list2 should be placed at
# the end of @list1 in ascending order.

# PROBLEM NOTES:
#

# PRAGMAS, MODULES, AND SUBS:
sub relative_sort {
   ;
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) :
(
   ['abc', 'xyz'],
   ['scriptinglanguage', 'perl'],
   ['aabbcc', 'abc'],
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
for my $aref (@arrays) {
   say '';
   my $source = $aref->[0];
   my $target = $aref->[1];
   my $output = ppl($source, $target);
   say "Source string: \"$source\"";
   say "Target string: \"$target\"";
   say "Can build Target from Source?: $output";
}
