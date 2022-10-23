#! /bin/perl

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks (\x{0A}).
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# /rhe/scripts/math/divide.pl
# Divides one positive integer by another and prints the quotient, offset to
# repetition, and period of repetition.
# Author: Robbie Hatley
# Edit history:
#    Thu Jan 11, 2018: Wrote first draft.
#    Sat Jan 13, 2018: Finally got it working correctly.
########################################################################################################################

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

use bigint;

sub divide($$);

# Main body of program:
{
   my $dividend = shift;
   my $divisor  = shift;
   my ($quotient, $offset, $period) = divide($dividend,$divisor);
   say "quotient = $quotient";
   say "offset   = $offset";
   say "period   = $period";
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
         foreach (@Remainders)                # Riffle through logged remainders.
         {
            last DIGIT if ($remainder == $_); # End division process if remainder is a repeat.
            ++$offset;                        # Increment $offset
         }
         push @Remainders, $remainder;        # Otherwise, push remainder onto @Remainders.
         $into = int($remainder / $divisor);  # How many times does divisor go INTO remainder?
         $quotient .= $into;                  # INTO is 10^(-$index) digit of quotient.
         $product = $into * $divisor;         # Multiply INTO by divisor.
         $remainder -= $product;              # Subtract product from remainder.
         last DIGIT if $remainder == 0;       # If remainder is 0, this is a terminating decimal expansion.
         ++$index;                            # Increment place value one right-ward and iterate.
         if ($index > 1000000) {die "Error in \"divide.pl\": over a million iterations.\n";}
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

=pod

   1m = (100cm/1m)(1in/2.54cm)
      = 100/2.54 inches
      = 10000/254 inches
      = 5000/127

=cut

