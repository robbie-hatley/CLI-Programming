#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 122-2,
written by Robbie Hatley on Fri Nov 22, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 122-2: Basketball Points
Submitted by: Mohammad S Anwar
Write a script to determine in which ways a given score can be
attained by shooting basketball shots of 1pt (free throw), 2pts
(regular shot), and 3pts (3-pointer).

Example #1:
Input: 4
Output:
1 1 1 1
1 1 2
1 2 1
1 3
2 1 1
2 2
3 1

Example #2:
Input: 5
Output:
1 1 1 1 1
1 1 1 2
1 1 2 1
1 1 3
1 2 1 1
1 2 2
1 3 1
2 1 1 1
2 1 2
2 2 1
2 3
3 1 1
3 2

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
This problem is equivalent to finding all max-value=3 integer partitionings of positive integers.
This is best done using recursion.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of non-negative integers, in proper Perl syntax, like so:
./ch-2.pl '(0,1,5,10,15)'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, VARIABLES, MODULES, AND SUBS:

sub part3 {
   my $score = shift;
   if ($score < 2) {return ([$score])}
   my @partitionings = ();
   foreach my $first (1,2,3) {
      if ($first > $score) {
         next;
      }
      elsif ($first == $score) {
         push @partitionings, ([$first])
      }
      else {
         my @partials = part3($score-$first);
         foreach my $partial (@partials) {
            my @partitioning = ($first, @$partial);
            push @partitionings, [@partitioning];
         }
      }
   }
   return @partitionings;
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @scores = @ARGV ? eval($ARGV[0]) : (4,5);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $score (@scores) {
   print "\n";
   print "Basketball score $score may be made in the following ways:\n";
   my @partitionings = part3($score);
   foreach my $partitioning (@partitionings) {
      print "@$partitioning\n";
   }
}
