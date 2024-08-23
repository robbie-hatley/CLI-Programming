#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 001-1,
written by Robbie Hatley on Fri Aug 23, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 001-1:
Submitted by: @oneandoneis2 as DM on Twitter.
Write a script to replace the character ‘e’ with ‘E’ in the
string ‘Perl Weekly Challenge’. Also print the number of times
the character ‘e’ is found in the string.

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
s///g

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of double-quoted strings, in proper Perl syntax, like so:
./ch-1.pl '("She shaved?", "Eighty elephants elvated.")'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @strings = @ARGV ? eval($ARGV[0]) : ("Perl Weekly Challenge");

# ------------------------------------------------------------------------------------------------------------
# SOLUTION:
for my $string (@strings) {
   print "\n";
   my $E = $string;
   my $count = $E =~ s/e/E/g;
   print "Original string: \"$string\"\n";
   print "Altered  string: \"$E\"\n";
   print "Number of replacements = $count\n"
}
