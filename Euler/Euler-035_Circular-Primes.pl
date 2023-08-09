#! /usr/bin/perl
# This is an 79-character-wide ASCII-encoded Perl source-code text file.
# =======|=========|=========|=========|=========|=========|=========|=========
###############################################################################
# "Euler-035_Circular-Primes.perl"                                            #
# Finds, prints, and counts all "circular primes" (prime numbers whose        #
# "rotations" -- eg, 197, 719, 971 -- are all prime) under one million.       #
# Author: Robbie Hatley.                                                      #
# Edit history:                                                               #
#   Fri Jan 19, 2018: Wrote it.                                               #
###############################################################################
use 5.026_001;
use strict;
use warnings;

sub Rotate ($$);
sub is_prime ($);

my $time0 = time;
my ($i,$j);
my $cntr = 0;
my $composite_flag;

# The Euler Project states that the first 4 prime numbers are
# "circular primes", so I'll stipulate that, even though I don't agree.
# (How can a number be a "circular prime" if it can't be rotated?)
# But we'll have to print and count those separately:
foreach (2,3,5,7)
{
   say $_ , " is a circular prime.";
   ++$cntr;
}

# Now let's check the numbers from 11 through 999999:
for ( $i = 11 ; $i < 1000000 ; $i += 2 )
{
   if (is_prime($i))
   {
      # If we get to here, this number is a prime.
      # Are its rotations also prime?
      $composite_flag = 0;
      for ( $j = 0 ; $j < length($i) ; ++$j )
      {
         if (not is_prime(Rotate($i, $j)))
         {
            # Drat, this rotation is composite.
            $composite_flag = 1;
            next;
         }
      }
      if (not $composite_flag)
      {
         # If $composite_flag never got set, then all rotations of $i are 
         # prime, so $i is a circular prime. Announce it and increment
         # our circular-primes counter:
         say $i , " is a circular prime.";
         ++$cntr;
      }
   }
}

# We're done, so print total count and scram:
say "Found " , $cntr , " circular primes.";
say "Elapsed time = " , time-$time0 , " seconds.";
exit 0;

sub Rotate ($$)
{
   my $InpStr = shift;
   my $RotAmt = shift;
   my $OutStr = 
      substr($InpStr, length($InpStr)-$RotAmt, $RotAmt) . 
      substr($InpStr, 0, length($InpStr)-$RotAmt);
   return $OutStr;
}

sub is_prime ($)
{
   my ($i, $j, $Limit);
   $i = shift;
   return 0 if $i==1||$i==4||$i==6||$i==8||$i==9||$i==10;
   return 1 if $i==2||$i==3||$i==5||$i==7;
   # If we get to here, $i >= 11. 
   # First check to see if $i is divisible by any of the first few primes:
   return 0 if (!($i%2)||!($i%3)||!($i%5)||!($i%7));
   # Otherwise, see if $i is divisible by any odd numbers up to it's sqrt.
   # If so,  $i is composite.
   # If not, $i is prime.
   $Limit = int(sqrt($i));
   for ( $j = 11 ; $j <= $Limit ; $j += 2 )
   {
      return 0 if !($i%$j);
   }
   return 1;
}
