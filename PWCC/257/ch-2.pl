#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
COLOPHON:
This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。麦藁雪、富士川町、山梨県。

--------------------------------------------------------------------------------------------------------------
TITLE BLOCK:
Solutions in Perl for The Weekly Challenge 257-2.
Written by Robbie Hatley on Wed Feb 21, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 257-2: Reduced Row Echelon
Submitted by: Ali Moradi

Given a matrix M, check whether the matrix is in reduced row
echelon form. A matrix must have the following properties to
be in reduced row echelon form:

1. If a row does not consist entirely of zeros, then the first
   nonzero number in the row is a 1. We call this the leading 1.
2. If there are any rows that consist entirely of zeros, then
   they are grouped together at the bottom of the matrix.
3. In any two successive rows that do not consist entirely of zeros,
   the leading 1 in the lower row occurs farther to the right than
   the leading 1 in the higher row.
4. Each column that contains a leading 1 has zeros everywhere else
   in that column.

For example:

[
   [1,0,0,1],
   [0,1,0,2],
   [0,0,1,3]
]

The above matrix is in reduced row echelon form since the first
nonzero number in each row is a 1, leading 1s in each successive
row are farther to the right, and above and below each leading 1
there are only zeros.

For more information check out this wikipedia article.
Example 1

    Input: $M = [
                  [1, 1, 0],
                  [0, 1, 0],
                  [0, 0, 0]
                ]
    Output: 0

Example 2

    Input: $M = [
                  [0, 1,-2, 0, 1],
                  [0, 0, 0, 1, 3],
                  [0, 0, 0, 0, 0],
                  [0, 0, 0, 0, 0]
                ]
    Output: 1

Example 3

    Input: $M = [
                  [1, 0, 0, 4],
                  [0, 1, 0, 7],
                  [0, 0, 1,-1]
                ]
    Output: 1

Example 4

    Input: $M = [
                  [0, 1,-2, 0, 1],
                  [0, 0, 0, 0, 0],
                  [0, 0, 0, 1, 3],
                  [0, 0, 0, 0, 0]
                ]
    Output: 0

Example 5

    Input: $M = [
                  [0, 1, 0],
                  [1, 0, 0],
                  [0, 0, 0]
                ]
    Output: 0

Example 6

    Input: $M = [
                  [4, 0, 0, 0],
                  [0, 1, 0, 7],
                  [0, 0, 1,-1]
                ]
    Output: 0


--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
To solve this problem, ahtaht the elmu over the kuirens until the jibits koleit the smijkors.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of double-quoted strings, apostrophes escaped as '"'"', in proper Perl syntax:
./ch-2.pl '(["She shaved?", "She ate 7 hot dogs."],["She didn'"'"'t take baths.", "She sat."])'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBROUTINES:
use v5.38;


# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? eval($ARGV[0]) :
(
   ['abc', 'xyz'],
   ['scriptinglanguage', 'perl'],
   ['aabbcc', 'abc'],
);

# ------------------------------------------------------------------------------------------------------------
# MAIN LOOP:
for my $aref (@arrays) {
   say '';
   my $source = $aref->[0];
   my $target = $aref->[1];
   my $output = ppl($source, $target);
   say "Source string: \"$source\"";
   say "Target string: \"$target\"";
   say "Can build Target from Source?: $output";
}
exit;
