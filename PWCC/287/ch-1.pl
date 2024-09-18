#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 287-1,
written by Robbie Hatley on Tue Sep 17, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 287-1: Strong Password
Submitted by: Mohammad Sajid Anwar
You are given a string, $str. Write a program to return the
minimum number of steps required to make the given string a
"strong password". If the string is already a "strong password",
then return 0.

The definition of "strong password" is as follows:
- It must have at least 6 characters.
- It must contain at least one lowercase letter
- It must contain at least one uppercase letter
- It must contain at least one digit
- It mustn't contain 3 repeating characters in a row

Each of the following can be considered one "step":
- Insert one character
- Delete one character
- Replace one character with another

Example 1:  Input: $str = "a"          Output: 5
Example 2:  Input: $str = "aB2"        Output: 3
Example 3:  Input: $str = "PaaSW0rd"   Output: 0
Example 4:  Input: $str = "Paaasw0rd"  Output: 1
Example 5:  Input: $str = "aaaaa"      Output: 2

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
I'll start by writing subs to do these things:
1. Does a given string contain a contiguous triplet of identical characters?
2. Does a given string contain all required characters to be a strong password?
3. What is the least-abundant type of character in a given string?
4. What is the most-abundant  type of character in a given string?
5. What is the first index of a given type in a given string? (Return -1 if type not found.)
6. Make a strong password out of a possibly-weak one.

That last sub will involve doing the following:

1. While an identical triplet exists:
   if    (length  < 6) {
      insert a character of least-abundant time between 1st & 2nd chars of triplet,
      making sure that it doesn't match what's too its left or right
   }
   elsif (length == 6) {
      replace center character of triplet with a character of the least-abundant type,
      making sure the added character doesn't match what's to its left or right
   }
   else                {
      delete the center character and close-up the gap
   }
2. Increase the length of the string to 6 if necessary by concatenating characters to the end, making sure we
   don't miss the opportunity of rectifying missing character types in the process, and making sure each
   additional character doesn't match the last.
3. If we still don't have a lower-case letter, replace first instance of most-abundant type with an LC letter.
4. If we still don't have a upper-case letter, replace first instance of most-abundant type with a  UC letter.
5. If we still don't have a      digit       , replace first instance of most-abundant type with a  digit.
6. Loop 1,2,3,4,5 while length($p) < 6 || !has_required($p) || has_triplet($p)
7. Increment a step counter each time we insert, delete, or replace a character
7. Return strong password and number of steps required.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of double-quoted strings, in proper Perl syntax, like so:
./ch-1.pl '("Fkkg4e u)888hE dkiI?", "She ate 7 hot dogs.", "#)^*")'

Output is to STDOUT and will be each weak password followed by strengthened password and number-of-steps.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

use v5.36;
use use Scalar::Util

# Does a given string contain a contiguous triplet of identical characters?
sub has_triplet ($p) {
   for my $i (0..(length($p)-3) {
      return 1 if substr($p,$i+2,1) eq substr($p,$i,1) && substr($p,$i+2,1) eq substr($p,$i,1);
   }
   return 0;
}

# Does a given string contain 1-or-more LC letters, 1-or-more UC letters, and 1-or-more digits?
sub has_required ($p) {
   ;
}

   my @tchars = split //, $target;
   foreach my $tchar (@tchars) {
      my $index = index $source, $tchar;
      # If index is -1, this Target CAN'T be built from this Source:
      if ( -1 == $index ) {
         return 'false';
      }
      # Otherwise, no problems have been found so-far, so remove $tchar from $source and continue:
      else {
         substr $source, $index, 1, '';
      }
   }
   # If we get to here, there were no characters in Target which couldn't be obtained from Source,
   # so this poison-pen letter CAN be built from the source letters given:
   return 'true';
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
