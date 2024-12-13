#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 299-2,
written by Robbie Hatley on Mon Dec 09, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 299-2: Word Search
Submitted by: Mohammad Sajid Anwar
You are given a grid of characters and a string. Write a script
to determine whether the given string can be found in the given
grid of characters. You may start anywhere and take any
orthogonal path, but may not reuse a grid cell.

Example #1:
Input: @chars =
['A', 'B', 'D', 'E'],
['C', 'B', 'C', 'A'],
['B', 'A', 'A', 'D'],
['D', 'B', 'B', 'C'],
$str = 'BDCA'
Output: true

Example #2:
Input: @chars =
['A', 'A', 'B', 'B'],
['C', 'C', 'B', 'A'],
['C', 'A', 'A', 'A'],
['B', 'B', 'B', 'B'],
$str = 'ABAC'
Output: false

Example #3:
Input: @chars =
['B', 'A', 'B', 'A'],
['C', 'C', 'C', 'C'],
['A', 'B', 'A', 'B'],
['B', 'B', 'A', 'A'],
$str = 'CCCAA'
Output: true

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
This problem begs for recursion, real or fake. No need to pass "cells used" to next level, just "partial
path", because the cells of a partial path ARE the "cells used". (That issue was holding me up until I made
that realization.) And there's no need to check ALL paths, just "paths that match the given string so far".

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of matrix/string pairs, in proper Perl syntax, like so:
./ch-2.pl '([[["a","p","p","g"],["f","q","l","z"],["b","n","e","y"]], "apple"],
            [[["a","p","r","g"],["f","q","l","z"],["b","n","e","y"]], "apple"],)'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

   use v5.36;
   use utf8;
   use List::Util qw( none );
   my $db = 0;

   # Can a path be formed in a given matrix matching a given string?
   sub word_search ($mref, $string, @path) {
      # If @path is empty, check paths using every cell as starting point:
      if ( 0 == scalar @path ) {
         for    ( my $i = 0 ; $i <= $#$mref         ; ++$i ) {
            for ( my $j = 0 ; $j <= $#{$mref->[$i]} ; ++$j ) {
               return 1 if (word_search($mref, $string, ([$i,$j])));
            }
         }
         # If we get to here, we couldn't find a match at the highest recursive level, so return 0 to caller:
         return 0;
      } # end if (path is empty)

      # If @path is NOT empty, first see if path matches string; if not, try all possible next cells, but reject
      # any next cells that are out-of-bounds or re-use cells of path
      else {
         # Make a test string consisting of the characters of @path:
         my $test = '';
         for my $cell (@path) {
            $test .= $mref->[$cell->[0]]->[$cell->[1]];
         }
         say "In word_search, in else(non-empty path). String = \"$string\"  Test = \"$test\"" if $db;
         # If $test matches $string, we're finished, so return 1:
         return 1 if $test eq $string;
         # If we get to here, the current @path does not match the string, so if the path length is less than the
         # string length, try all 1-cell extensions of @path that don't go out-of-bounds or reuse @path's cells:
         my $plen = scalar(@path); my $slen = length($string);
         if ($plen < $slen) {
            say "In word_search, inside if (path<string); plen = $plen  slen = $slen" if $db;
            # Make an array of 4 sets of cell coordinates, Right, Up, Left, and Down relative to current head:
            my @next =
            (
               [$path[-1]->[0]+1,$path[-1]->[1]+0], # Right
               [$path[-1]->[0]+0,$path[-1]->[1]+1], # Up
               [$path[-1]->[0]-1,$path[-1]->[1]+0], # Left
               [$path[-1]->[0]+0,$path[-1]->[1]-1], # Down
            );
            # For each of those possible "next" cells, if it's in-bounds and doesn't re-use cells from @path,
            # make a new path using the "next" cell as new head, and recurse this subroutine on the new path:
            for my $cell (@next) {
               my ($i,$j) = @$cell;
               # If cell ($i,$j) is within the bounds of the matrix:
               if ($i >= 0 && $i <= $#$mref && $j >= 0 && $j <= $#{$mref->[$i]}) {
                  say "In word_search, inside if(in-bounds). i = $i  j = $j" if $db;
                  # If cell doesn't re-use any of the cells of the given partial path:
                  if (none {$i == $_->[0] && $j == $_->[1]} @path) {
                     # Make a new path with current cell as new head:
                     my @new_path; push @new_path, @path; push @new_path, $cell;
                     say 'In word_search, about to recurse. Length of new path = ', scalar(@new_path) if $db;
                     # RECURSE!!!!!!!
                     return 1 if word_search($mref, $string, @new_path);
                  } # end if (doesn't re-use)
               } # end if (in-bounds)
            } # end for (each cell of @next)
         } # end if (path length < string length)
         # If we get to here, we couldn't recursively find a match for the given non-empty @path, so return 0:
         return 0;
      } # end else (path is not empty)
   } # end sub word_search

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @pairs = @ARGV ? eval($ARGV[0]) :
(
   # Example #1 input:
   [
      [
         ['A', 'B', 'D', 'E'],
         ['C', 'B', 'C', 'A'],
         ['B', 'A', 'A', 'D'],
         ['D', 'B', 'B', 'C'],
      ],
      'BDCA',
   ],
   # Expected output: true

   # Example #2 input:
   [
      [
         ['A', 'A', 'B', 'B'],
         ['C', 'C', 'B', 'A'],
         ['C', 'A', 'A', 'A'],
         ['B', 'B', 'B', 'B'],
      ],
      'ABAC',
   ],
   # Expected output: false

   # Example #3 input:
   [
      [
         ['B', 'A', 'B', 'A'],
         ['C', 'C', 'C', 'C'],
         ['A', 'B', 'A', 'B'],
         ['B', 'B', 'A', 'A'],
      ],
      'CCCAA',
   ],
   # Expected output: true
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $pref (@pairs) {
   say '';
   my $mref   = $pref->[0];
   my $string = $pref->[1];
   say 'Matrix =';
   say "[@$_]" for @$mref;
   say "String = $string";
   word_search($mref, $string)
   and say "Word search succeeded."
   or  say "Word search failed.";
}
