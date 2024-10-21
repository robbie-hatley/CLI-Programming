#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 292-2,
written by Robbie Hatley on Mon Oct 21, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 292-2: Zuma Game
Submitted by: Mohammad Sajid Anwar
You are given a single row of colored balls, $row, and a random
number of colored balls in $hand.

Here is the variation of Zuma Game. Your goal is to clear all of
the balls from the row. Pick any ball from your hand and insert
it in between two balls in the row or on either end of the row.
If there is a group of three or more consecutive balls of the
same color then remove the group of balls from the row. If
there are no more balls on the row then you win the game.
Repeat this process until you either win or do not have any more
balls in your hand.

Write a script to determine the minimum number of balls you need
to insert to clear all the balls from the row. If you cannot
clear all the balls from the row using the balls in your hand,
return -1.

Example 1:
Input: $row = "WRRBBW", $hand = "RB"
It is impossible to clear all the balls. The best you can do is:
- Insert 'R' so the row becomes WRRRBBW. WRRRBBW -> WBBW.
- Insert 'B' so the row becomes WBBBW. WBBBW -> WW.
There are still balls remaining on the row,
and you are out of balls to insert,
so Output = -1.

Example 2:
Input: $row = "WWRRBBWW", $hand = "WRBRW"
To make the row empty:
- Insert 'R' so the row becomes WWRRRBBWW -> WWBBWW
- Insert 'B' so the row becomes WWBBBWW   -> WWWW -> empty
2 balls from your hand were needed to clear the row,
so Output = 2.

Example 3:
Input: $row = "G", $hand = "GGGGG"
To make the row empty:
- Insert 'G' so the row becomes GG.
- Insert 'G' so the row becomes GGG. GGG -> empty.
2 balls from your hand were needed to clear the row,
so Output = 2.

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
I don't know about "minimum" (which would require elaborate mathematical proofs), but I can certainly come up
with an algorithm which makes "good effort" towards removing all the balls. I'll try this approach:
1. Process all balls in hand from left to right.
2. For each ball in hand:
      If there are two contiguous balls of that color on row, insert to their right.
      Else if there is 1 ball of that color on row, insert to its right.
      Else append ball to end of row.
3. If row is empty after hand is exhausted, we win; else we lose.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of two double-quoted strings, in proper Perl syntax, like so:
./ch-2.pl '(["RWPGPGPG", "RRWWPGPGPGPGPGPG"],["RWPGPGPG", "RRWWPGPGPGPG"])'
(You can use any characters you like; each variety of character will be interpretted as representing a color.)

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

use v5.38;
use utf8;

sub clear_colors ($row, $hnd) {
   for each my $color (split '', $hnd) {
      ;
   }
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) : (["WRRBBW","RB"],["WWRRBBWW","WRBRW"],["G","GGGGG"]);
#                  Expected outputs :          -1               2                 2

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $aref (@arrays) {
   my $row = $$aref[0];
   my $hnd = $$aref[1];
   my $rslt = clear_colors($row,$hnd);
   say '';
   say "Row = $row";
   say "Hnd = $hnd";
}
