#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:

Solution in Perl for The Weekly Challenge 395-1,
written by Robbie Hatley on Tue Oct 13, 2026.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:

Task 395-1: Complex Number
Submitted by: Mohammad Sajid Anwar
You are given two complex numbers as strings. Write a script to
return the multiplication of the given complex numbers, using
the formula: (a + bi) x (c + di) = (ac - bd) + (ad + bc)i

(See "# INPUTS:" section below for examples.)

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:

I'm torn as to whether to do this manually or by using "Math::Complex". I think I'll do the latter, because
that's actually better Perl: don't reinvent the wheel.

--------------------------------------------------------------------------------------------------------------
IO NOTES:

Input is via either default data or @ARGV. If using @ARGV, provide one-or-more space-separated single-quoted
arguments. Each argument must be comma-separated pair of complex numbers in a+bi format. For example:

./ch-1.pl '7.3-5.2i,-3.4-2.7j' '7.2+(-3.6)i,-8+7i' '-9-9i,-7+3i'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS, MODULES, AND SUBS:

   use v5.40;

   # Multiply two complex-number strings:
   sub mult_comp_str ( $s1 , $s2 ) {
      my ($a, $b, $c, $d) = (0,0,0,0);
      if ( $s1 =~ m// ) {
         $a = 
         $b = 
      }
   }

   # Parse lists of strings:
   sub parse_argv_1 ( @bash_args ) {
      my @args = ();
      foreach my $bash_arg (@bash_args) {
         push @args, [map {trim $_} split /,/, $bash_arg, -1];
      }
      return @args;
   }

# ------------------------------------------------------------------------------------------------------------
# INPUTS:
my @arrays = @ARGV ? parse_argv_1(@ARGV) :
(
   [ "1+1i",       "1+1i"    ], # 0+2i
   [ "1+(-1)i",    "1+(-1)i" ], # 0+(-2)i
   [ "0+3i",       "0+4i"    ], # -12+0i
   [ "3+4i",       "3+(-4)i" ], # 25+0i
   [ "50+(-20)i",  "-10+30i" ], # 100+1700i
);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:
for my $aref (@arrays) {
   say '';
   my ($s1, $s2) = @$aref;
   say "num1 = $s1   num2 = $s2";
   $s1 =~ s/\+\(-([^\)]+)\)/-$1/;
   $s2 =~ s/\+\(-([^\)]+)\)/-$1/;
   if ( $s1 !~ m/^((?:-?[1-9]\d*(?:\.\d+)?)|0)(?:\+|-)((?:-?[1-9]\d*(?:\.\d+)?)|0)i$/
      ||$s2 !~ m/^((?:-?[1-9]\d*(?:\.\d+)?)|0)(?:\+|-)((?:-?[1-9]\d*(?:\.\d+)?)|0)i$/ ) {
      warn "Error: invalid argument(s).\n";
      next;
   }
   my $c1 = cplx($s1);
   my $c2 = cplx($s2);
   my $c3 = $c1 * $c2;
   my $s3 = sprintf("%s", $c3);
   say "product = $s3";
}
