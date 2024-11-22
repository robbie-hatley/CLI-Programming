#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 122-1,
written by Robbie Hatley on Fri Nov 22, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 122-1: Average of Stream
Submitted by: Mohammad S Anwar
Write a scripts to print the running average of an incoming
stream of real numbers.

Example #1:
Input:  10, 20, 30, 40, 50, 60, 70, 80, 90, ...
Output: 10, 15, 20, 25, 30, 35, 40, 45, 50, ...

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
To avoid filling memory, I can just keep a running total in "$accumulator", an index in "$index", and a
running average in "$average" ("$average = $accumulator/($index+1);").

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of real numbers, in proper Perl syntax, like so:
./ch-1.pl '([1.7,-0.6,3.9,2.4,-1.7,-2.1,8.8,4.1,4.9],[1,-1,2,-2,3,-3,4,-4,5,-5])'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

sub running_average {
   my $accumulator = 0;
   my $index       = 0;
   my $average     = 0;
   print "Averages = (";
   foreach my $value (@_) {
      $accumulator += $value;
      $average = $accumulator/($index+1);
      0 != $index and print ', ';
      print $average;
      ++$index;
   }
   print ")\n";
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) : ([10, 20, 30, 40, 50, 60, 70, 80, 90,]);
                   # Expected output:   10, 15, 20, 25, 30, 35, 40, 45, 50

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $array (@arrays) {
   print "\n";
   print "Array    = (@$array)\n";
   running_average(@$array);
}
