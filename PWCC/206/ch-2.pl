#! /usr/bin/perl
# Robbie Hatley's Solution to PWCC 206-2

=pod

Task 2: Array Pairings
Submitted by: Mohammad S Anwar
Given an array of integers having even number of elements, find the
maximum sum of the minimum of each pair.

Example 1: 

Input: @array = (1,2,3,4)
Output: 4

Possible Pairings are as below:
a) (1,2) and (3,4). So min(1,2) + min(3,4) => 1 + 3 => 4
b) (1,3) and (2,4). So min(1,3) + min(2,4) => 1 + 2 => 3
c) (1,4) and (2,3). So min(1,4) + min(2,3) => 2 + 1 => 3

So the maxium sum is 4.

Example 2:

Input: @array = (0,2,1,3)
Output: 2

Possible Pairings are as below:
a) (0,2) and (1,3). So min(0,2) + min(1,3) => 0 + 1 => 1
b) (0,1) and (2,3). So min(0,1) + min(2,3) => 0 + 2 => 2
c) (0,3) and (2,1). So min(0,3) + min(2,1) => 0 + 1 => 1

So the maximum sum is 2.

=cut

# IO NOTES:
# NOTE: Input is by either built-in array-of-arrays, or @ARGV. If using @ARGV,the args should be a space-separated
#       sequence of integers, which will be interpreted as being a single array.
# NOTE: Output is to STDOUT and will be the third-highest unique value if the number of unique values is at least 3;
#       otherwise, the output will be the maximum unique value.

# PRELIMINARIES:
use v5.36;
use List::Util 'uniqint';
$"=", ";

# DEFAULT INPUTS:
my @arrays = ([5,4,3], [5,6], [5,4,4,3]);

# NON-DEFAULT INPUTS:
if (@ARGV) {@arrays = ([@ARGV]);}

# MAIN BODY OF SCRIPT:
for (@arrays){
   say '';
   my @array = @{$_};
   say "array: (@array)";
   my @unique = uniqint reverse sort @array;
   if (@unique >= 3) {say "Third-highest unique value = $unique[2]"}
   else              {say "Maximum unique value = $unique[0]"}}
