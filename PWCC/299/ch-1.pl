#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 299-1,
written by Robbie Hatley on Mon Dec 09, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 299-1: Replace Words
Submitted by: Mohammad Sajid Anwar
You are given an array of words and a sentence. Write a script
to replace all words in the given sentence that start with any
of the words in the given array.

Example #1:
Input: @words = ("cat", "bat", "rat")
$sentence = "the cattle was rattle by the battery"
Output: "the cat was rat by the bat"

Example #2:
Input: @words = ("a", "b", "c")
$sentence = "aab aac and cac bab"
Output: "a a a c b"

Example #3:
Input: @words = ("man", "bike")
$sentence = "the manager was hit by a biker"
Output: "the man was hit by a bike"

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
To solve this problem, ahtaht the elmu over the kuirens until the jibits koleit the smijkors.

--------------------------------------------------------------------------------------------------------------
IO NOTES:
Input is via either built-in variables or via @ARGV. If using @ARGV, provide one argument which must be a
single-quoted array of arrays of double-quoted strings, apostrophes escaped as '"'"', in proper Perl syntax:
./ch-1.pl '(["She shaved?", "She ate 7 hot dogs."],["She didn'"'"'t take baths.", "She sat."])'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

use v5.38;
use utf8;
sub replace_words :prototype(\@$) ($rref, $sentence) {
   my @replacements = @$rref;
   my @words = split /[^\pL']/, $sentence;
   foreach my $word (@words) {
      foreach my $replacement (@replacements) {
         if ($word =~ m/^$replacement/) {
            $sentence =~ s/$word/$replacement/g;
         }
      }
   }
   return $sentence;
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @pairs = @ARGV ? eval($ARGV[0]) :
(
   # Example #1 input:
   [
      ["cat", "bat", "rat"],
      "the cattle was rattle by the battery",
   ],
   # Expected output: "the cat was rat by the bat"

   # Example #2 input:
   [
      ["a", "b", "c"],
      "aab aac and cac bab",
   ],
   # Expected output: "a a a c b"

   # Example #3 input:
   [
      ["man", "bike"],
      "the manager was hit by a biker",
   ],
   # Expected output: "the man was hit by a bike"
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
$"=', ';
for my $pref (@pairs) {
   say '';
   my @replacements = @{$$pref[0]};
   my $sentence     = $$pref[1];
   my $replaced     = replace_words(@replacements, $sentence);
   say "Original sentence: $sentence";
   say "Replaced sentence: $replaced";
}
