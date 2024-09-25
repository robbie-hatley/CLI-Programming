#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 288-2,
written by Robbie Hatley on Mon Sep 23, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 288-2: Contiguous Block
Submitted by: Peter Campbell Smith

You are given a rectangular matrix where all the cells contain
either x or o. Write a script to determine the size of the
largest contiguous block. A "contiguous block" consists of
elements containing the same symbol which share an edge (not just
a corner) with other elements in the block, and where there is a
path between any two of these elements that crosses only those
shared edges.

Example 1:
Input: $matrix = [
['x', 'x', 'x', 'x', 'o'],
['x', 'o', 'o', 'o', 'o'],
['x', 'o', 'o', 'o', 'o'],
['x', 'x', 'x', 'o', 'o'],
]
Ouput: 11
(There is a block of 9 contiguous cells containing 'x'.
There is a block of 11 contiguous cells containing 'o'.)

Example 2:
Input: $matrix = [
['x', 'x', 'x', 'x', 'x'],
['x', 'o', 'o', 'o', 'o'],
['x', 'x', 'x', 'x', 'o'],
['x', 'o', 'o', 'o', 'o'],
]
Ouput: 11
(There is a block of 11 contiguous cells containing 'x'.
There is a block of 9 contiguous cells containing 'o'.)

Example 3:
Input: $matrix = [
['x', 'x', 'x', 'o', 'o'],
['o', 'o', 'o', 'x', 'x'],
['o', 'x', 'x', 'o', 'o'],
['o', 'o', 'o', 'x', 'x'],
]
Ouput: 7
(There is a block of 7 contiguous cells containing 'o'.
There are two other 2-cell blocks of 'o'.
There are three 2-cell blocks of 'x' and one 3-cell.)


--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
This one is complicated! This is the approach I came up with:
 1. Assign a unique id integer to every cell in matrix.
 2. Make a hash to keep track of block number assigned to each id.
 3. Initialize all hash elements to "-1", meaning "no block has been assigned yet".
 3. Make a single pass through each cell of matrix, comparing each "current" cell to all neighbors.
 4. If current cell matches a neighbor, and both have no block, assign a new block number to both.
 5. If current cell matches a neighbor, and one has a block, assign block to cell that doesn't have one.
 6. If current cell matches a neighbor, and both have a block, and they're the same, do nothing.
 7. If current cell matches a neighbor, and both have a block, and they're different, then reassign lesser
    block number to all cells with greater block number.
 8. Make array to serve as list of block sizes.
 9  For each key of hash, increment the value of the size-list element having that key's value as its index.
10. Reverse-sort the list of block sizes.
11. Return 0th element of reverse-sorted list of block sizes.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of arrays of double-quoted "x" and "o" only, in proper Perl syntax, like so:
./ch-2.pl '([["x","x","x"],["x","o","o"],["x","x","o"],["x","x","o"],["x","o","o"]],
             [["x","x","o"],["x","o","o"],["x","o","o"],["x","o","o"],["x","x","o"]],
             [["x","o","x"],["o","x","o"],["x","o","x"],["o","x","o"],["x","o","x"]],)'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

use v5.36;

sub is_matrix ($mref) {
   return 0 if 'ARRAY' ne ref $mref;
   my @matrix = @$mref;
   for my $i (0..$#matrix) {
      return 0 if 'ARRAY' ne ref $matrix[$i];
      return 0 if scalar(@{$matrix[$i]}) != scalar(@{$matrix[0]});
   }
   return 1;
}

sub max_contiguous_block_size ($mref) {
   my $w = scalar @{$mref->[0]};  # Width  of matrix.
   my $h = scalar @{$mref};       # Height of matrix.
   my %ids;                       # Block membership of each id.
   my @blocks;                    # Number of ids for each block.
   my $num_blks = 0;              # How many blocks currently exist?
   # Assign a unique integer id for each of the $w*$h elements in this matrix,
   # and assign block number "-1" to each id, meaning "no block yet":
   for my $id (0..$w*$h-1) {
      $ids{$id} = -1;
   }
   # Assign a block number for every cell of matrix:
   for my $id (0..$w*$h-1) {
      # Calculate ->[$j]->[$i] coordinates for this id:
      my $i = $id%$w;
      my $j = ($id-$i)/$w;
      # Create a list of our neighbors:
      my @neighbors;
      if ( $i+1 >= 0 && $i+1 < $w && $j+0 >= 0 && $j+0 < $h ) {push @neighbors, ($i+1)+$w*($j+0);} # Right
      if ( $i+0 >= 0 && $i+0 < $w && $j+1 >= 0 && $j+1 < $h ) {push @neighbors, ($i+0)+$w*($j+1);} # Up
      if ( $i-1 >= 0 && $i-1 < $w && $j+0 >= 0 && $j+0 < $h ) {push @neighbors, ($i-1)+$w*($j+0);} # Left
      if ( $i+0 >= 0 && $i+0 < $w && $j-1 >= 0 && $j-1 < $h ) {push @neighbors, ($i+0)+$w*($j-1);} # Down
      # Consider how each neighbor influences block assignments:
      for my $ne (@neighbors) {
         # Calculate ->[$l]->[$k] coordinates for this id:
         my $k = $ne%$w;
         my $l = ($ne-$k)/$w;
         # If content of neighbor is same as content of current, they're part of the same block:
         if ( $mref->[$l]->[$k] eq $mref->[$j]->[$i] ) {
            # If current cell has no block assigned yet:
            if (-1 == $ids{$id}) {
               # If neighbor has no block assigned yet:
               if (-1 == $ids{$ne}) {
                  # Assign new block number to both:
                  $ids{$id} = $num_blks;
                  $ids{$ne} = $num_blks;
                  ++$num_blks;
               }
               # Else if neighbor DOES have a block assigned:
               else {
                  # Assign neighbor's block number to current:
                  $ids{$id} = $ids{$ne};
               }
            }
            # Else if current cell DOES have a block assigned:
            else {
               # If neighbor has no block assigned yet:
               if (-1 == $ids{$ne}) {
                  # Assign current block number to neighbor:
                  $ids{$ne} = $ids{$id};
               }
               # Else if neighbor DOES have a block assigned:
               else {
                  # If we get to here, current AND neighbor already have block numbers.
                  # If they're the same, take no action:
                  next if $ids{$ne} == $ids{$id};
                  # Otherwise, assign the lesser block number to all cells with the greater block number:
                  my ($l, $g);
                  if ($ids{$id}<$ids{$ne}) {$l = $ids{$id}; $g = $ids{$ne};}
                  if ($ids{$id}>$ids{$ne}) {$g = $ids{$id}; $l = $ids{$ne};}
                  for my $key (keys %ids) {
                     if ($ids{$key} == $g) {$ids{$key} = $l;}
                  }
               }
            }
         }
      }
      # If block number is still -1, then this block is isolated, so assign a new block number:
      if (-1 == $ids{$id}) {$ids{$id} = $num_blks; ++$num_blks;}
   }
   for my $id (keys %ids) {++$blocks[$ids{$id}]}
   my @sorted = reverse sort {$a<=>$b} @blocks;
   return $sorted[0];
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @matrices = @ARGV ? eval($ARGV[0]) :
(
   [
      ['x', 'x', 'x', 'x', 'o'],
      ['x', 'o', 'o', 'o', 'o'],
      ['x', 'o', 'o', 'o', 'o'],
      ['x', 'x', 'x', 'o', 'o'],
   ],
   [
      ['x', 'x', 'x', 'x', 'x'],
      ['x', 'o', 'o', 'o', 'o'],
      ['x', 'x', 'x', 'x', 'o'],
      ['x', 'o', 'o', 'o', 'o'],
   ],
   [
      ['x', 'x', 'x', 'o', 'o'],
      ['o', 'o', 'o', 'x', 'x'],
      ['o', 'x', 'x', 'o', 'o'],
      ['o', 'o', 'o', 'x', 'x'],
   ],
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $mref (@matrices) {
   say '';
   my @matrix = @$mref;
   say 'Matrix = ';
   say "@$_" for @matrix;
   if (!is_matrix($mref)) {say 'Not a rectangular matrix!'; next;}
   my $MCBS = max_contiguous_block_size($mref);
   say "Max contiguous block size = $MCBS";
}
