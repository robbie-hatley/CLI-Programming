#! /usr/bin/perl
# "Euler-032_Pandigital-Products.perl"
# Finds all products of positive integers a*b=c such that a, b, and c,
# when written in decimal, use each of the digits 123456789 once each.
# Example: 39 × 186 = 7254
# Such products are called "Pandigital Products".
use 5.026_001;
use strict;
use warnings;
use List::Util qw( sum sum0 uniq uniqnum uniqstr );

sub Extract;
sub Permute;

our @Permutations = ();
our @Orig_Numbers = ();
our @Uniq_Numbers = ();
our $digits       = '123456789';
our $perms        = 0;

# main
{
   my $t0        = time;
   my $equation  = '';
   my $sum       = 0;
  
   # Make a list of all permutations of the string "123456789":
   Permute('',$digits);

   say("Found $perms permutations of 123456789");
   # We must have exactly 5 digits on the left of the "=" and a 4-digit 
   # number to the right of the "=". That's the only combo that will work.
   # (2-to-4 digits left can't make 5 right. 6 digits left will make 5+ 
   # digits right. So only 5 digits left will work. And even most of 
   # *those* can't work. But we'll check all 5-digits-left combos.)
   foreach (@Permutations)
   {
      $equation = 
         substr($_, 0, 1) . '*' . substr($_, 1, 4) . '==' . substr($_, 5, 4);
      if (eval $equation)
      {
         push @Orig_Numbers, 0+substr($_, 5, 4);
         say $equation;
      }
      $equation = 
         substr($_, 0, 2) . '*' . substr($_, 2, 3) . '==' . substr($_, 5, 4);
      if (eval $equation)
      {
         push @Orig_Numbers, 0+substr($_, 5, 4);
         say $equation;
      }
      $equation = 
         substr($_, 0, 3) . '*' . substr($_, 3, 2) . '==' . substr($_, 5, 4);
      if (eval $equation)
      {
         push @Orig_Numbers, 0+substr($_, 5, 4);
         say $equation;
      }
      $equation = 
         substr($_, 0, 4) . '*' . substr($_, 4, 1) . '==' . substr($_, 5, 4);
      if (eval $equation)
      {
         push @Orig_Numbers, 0+substr($_, 5, 4);
         say $equation;
      }
   }
   @Uniq_Numbers = uniqnum @Orig_Numbers;
   $sum = sum0 @Uniq_Numbers;
   say "Sum = $sum";

   warn("Elapsed time = ", time - $t0, " seconds.\n");
   exit(0);
}

sub Permute 
{
   my $left  = shift;
   my $right = shift;
   my $length_left  = length($left);
   my $length_right = length($right);
   my $i;
   
   if (1 == $length_right) 
   {
      push @Permutations , $left . $right ;
      ++$perms;
   }
   else 
   {
      for ( $i = 0 ; $i < $length_right ; ++$i ) 
      {
         my $temp_left  = $left;
         my $temp_right = $right;
         $temp_left .= Extract(\$temp_right, $i);
         Permute($temp_left, $temp_right);
      }
   }
   return;
}

# Extract one character from a given index of a given string,
# close-up the gap, and return extracted character. 
# (NOTE: alters its first argument.)
sub Extract
{
   my $Text  = shift; # ref to text (NOT copy of text)
   my $Index = shift; # index to erase one char at
   my $Char  = substr(${$Text}, $Index, 1);
   ${$Text}  = substr(${$Text}, 0, $Index) . substr(${$Text}, $Index+1);
   return $Char;
}

