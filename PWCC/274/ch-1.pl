#!/usr/bin/env -S perl -CSDA

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:
Solutions in Perl for The Weekly Challenge 274-1,
written by Robbie Hatley on Mon Jun 17, 2024.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:
Task 274-1: Goat Latin
Submitted by: Mohammad Sajid Anwar
You are given a sentence, $sentance. Write a script to convert
$sentence to Goat Latin, a made up language similar to Pig Latin.

Rules for Goat Latin:

1) If a word begins with a vowel ("a", "e", "i", "o", "u"), append
   "ma" to the end of the word.
2) If a word begins with consonant i.e. not a vowel, remove first
   letter and append it to the end then add "ma".
3) Add letter "a" to the end of first word in the sentence, "aa"
   to the second word, etc.

Example 1:
Input: $sentence = "I love Perl"
Output: "Imaa ovelmaaa erlPmaaaa"

Example 2:
Input: $sentence = "Perl and Raku are friends"
Output: "erlPmaa andmaaa akuRmaaaa aremaaaaa riendsfmaaaaaa"

Example 3:
Input: $sentence = "The Weekly Challenge"
Output: "heTmaa eeklyWmaaa hallengeCmaaaa"


--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:
This one is pretty simple, just a matter of making the prescribed changes to each word. The only tricky parts
are determining what's a "vowel", what's a "consonant", and what's a "word". My approach was like this:

   use Unicode::Normalize 'NFD';
   sub is_vowel ($x) {lc(NFD $x) =~ m/^[aeiou]$/}
   sub is_conso ($x) {!is_vowel $x}
   sub goat     ($x) {
      my @words = split /[ \t.,;:\?!'"\/\(\)\[\]\{\}\*&\^%\$#\@`~]+/, $x;
      for ( my $idx = 0 ; $idx <= $#words ; ++$idx ) {
         if ( is_vowel substr($words[$idx], 0, 1) ) {$words[$idx] .= "ma"}
         if ( is_conso substr($words[$idx], 0, 1) ) {$words[$idx]  = substr($words[$idx], 1, -1)
                                                                   . substr($words[$idx], 0,  1)
                                                                   . "ma"}
         $words[$idx] .= "a"x(1+$idx);
      }
      return join ' ', @words;
   }

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
   use strict;
   use warnings;
   use utf8;
   use warnings FATAL => 'utf8';

   use Unicode::Normalize 'NFD';

   sub is_vowel ($x) {lc(NFD $x) =~ m/^[aeiou]$/}
   sub is_conso ($x) {!is_vowel $x}
   sub goat     ($x) {
      my @words = split /[ \t.,;:\?!'"\/\(\)\[\]\{\}\*&\^%\$#\@`~]+/, $x;
      for ( my $idx = 0 ; $idx <= $#words ; ++$idx ) {
         if ( is_vowel substr($words[$idx], 0, 1) ) {$words[$idx] .= "ma"}
         if ( is_conso substr($words[$idx], 0, 1) ) {$words[$idx]  = substr($words[$idx], 1, -1)
                                                                   . substr($words[$idx], 0,  1)
                                                                   . "ma"}
         $words[$idx] .= "a"x(1+$idx);
      }
      return join ' ', @words;
   }

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @strings = @ARGV ? eval($ARGV[0]) :
(
   # Example 1 input:
   "I love Perl",
   # Expected output: "Imaa ovelmaaa erlPmaaaa"

   # Example 2 input:
   "Perl and Raku are friends",
   # Expected output: "erlPmaa andmaaa akuRmaaaa aremaaaaa riendsfmaaaaaa"

   # Example 3 input:
   "The Weekly Challenge",
   # Expected output: "heTmaa eeklyWmaaa hallengeCmaaaa"
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
for my $string (@strings) {
   say '';
   say "Original string = $string";
   say "Goat     string = ${\goat($string)}";
}
