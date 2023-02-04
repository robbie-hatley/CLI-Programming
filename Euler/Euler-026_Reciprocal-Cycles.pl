#! /usr/bin/perl

# This is an 79-character-wide ASCII-encoded Perl source-code text file.
# =======|=========|=========|=========|=========|=========|=========|=========

###############################################################################
# /rhe/Euler/Euler-026_Reciprocal-Cycles.perl                                 #
# Prints the integer 0<d<1000 with the longest decimal repeat pattern.        #
# Author: Robbie Hatley                                                       #
# Edit history:                                                               #
#    Thu Jan 11, 2018: Wrote first draft.                                     #
#    Sat Jan 13, 2018: Finally got it working correctly.                      #
#    Sun Jan 14, 2018: Added elapsed-time measurement.                        #
###############################################################################

use 5.026_001;
use strict;
use warnings;

sub divide($$);

# main() :
{
   my $x;
   my $quotient;
   my $offset;
   my $period;
   my $longest_x = 0;
   my $longest_p = 0;
   my $time0     = 0;
   my $time1     = 0;
   my $time2     = 0;

   $time0 = time();

   for ( $x = 1 ; $x < 1000 ; ++$x )
   {
      ($quotient, $offset, $period) = divide(1, $x);
      if ($period > $longest_p)
      {
         $longest_x = $x; 
         $longest_p = $period;
      }
      #say "x        = $x";
      #say "quotient = $quotient";
      #say "offset   = $offset";
      #say "period   = $period";
      #say '';
   }
   say "Longest   x    = $longest_x";
   say "Longest period = $longest_p";

   $time1 = time();
   $time2 = $time1 - $time0;
   printf("\nElapsed time = %.3f seconds.\n", $time2);

   # We be done, so scram:
   exit 0;
}

# Divide one positive integer by another, returning floating-point quotient
# up to repetition point (if any), periodicity of repeating decimal (0 if none), 
# and repeated string of digits ('' if none):
sub divide($$)
{
   my $dividend    = shift;
   my $divisor     = shift;
   my $index       = 0;
   my $dotindex    = 0;
   my $remainder   = 0;
   my @Remainders  = ();
   my $into        = 0;
   my $product     = 0;

   my $quotient    = 0;
   my $offset      = 0;
   my $period      = 0;

   # If dividend >= divisor, this is an "improper fraction", 
   # so make it "proper":
   if ($dividend >= $divisor )               # eg, 36/7
   {
      $quotient = (int($dividend/$divisor));
      $dividend -= ($quotient * $divisor);
   }

   # The integral part of the quotient, if any, has now been calculated.
   # Now, what about the fractional part, if any?

   # If there IS NO fractional part,
   # Leave the quotient as it is, an integer with no decimal point.
   # Leave the period   as it is, 0.
   # Leave the pattern  as it is, ''.
      
   # But if there IS a fractional part to this quotient, then:
   # 1. Find the quotient (up to repetition point, if any).
   # 2. Find the period  of repetition (if any).
   # 3. Find the pattern of repetition (if any).
   if (0 < $dividend && $dividend < $divisor)
   {
      $quotient .= '.';                       # Tack on decimal point.
      $remainder = $dividend;                 # Load dividend into remainder.
      $index = 1;                             # Place value = 10^(-$index)
      DIGIT: while (1)
      {
         $remainder .= '0';                   # Bring down the first of the infinite zeros.
         $offset = 0;
         foreach (@Remainders)                # Riffle through logged remainders,
         {
            if ($_ == $remainder)             # and if current remainder is a repeat,
            {
               last DIGIT;                    # end the division process.
            }
            ++$offset
         }
         push @Remainders, $remainder;        # Otherwise, push remainder onto @Remainders.
         $into = int($remainder / $divisor);  # How many times does divisor go INTO remainder?
         $quotient .= $into;                  # INTO is 10^(-$index) digit of quotient.
         $product = $into * $divisor;         # Multiply INTO by divisor.
         $remainder -= $product;              # Subtract product from remainder.
         last if $remainder == 0;
         ++$index;                            # Increment place value one right-ward and iterate.
         die "Error: over a million iterations.\n$!\n" if $index > 1000000;
      }
      if ($remainder == 0)                    # If remainder is now 0,
      {
         $period  = 0;                        # this decimal fraction is non-periodic.
      }
      else                                    # Otherwise, determine period and pattern.
      {
         $period   = scalar(@Remainders) - $offset;
         $dotindex = index($quotient, '.');
      }
   } # End if (there's a fractional part).
   if ($period > 0)
   {
      $quotient = substr($quotient, 0, $dotindex + 1 + $offset)
          . '(' . substr($quotient,    $dotindex + 1 + $offset) . ')';
   }
   return ($quotient, $offset, $period); # Return results to caller.
}
