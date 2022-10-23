#! /usr/bin/perl

# This is a 120-character-wide UTF-8 Unicode Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# /cygdrive/D/rhe/modules/RH/Math.pm
# Robbie Hatley's Math Module
# Written by Robbie Hatley, starting 2016-02-20
# Contains math subroutines.
# Edit history:
#    Sat Feb 20, 2016: Started writing it.
#    Tue Jul 25, 2017: Removed "number-to-words" (it's not general-purpose
#                      enough to warrant being included here).
#    Sun Dec 31, 2017: use 5.026_001. use Exporter.
#    Tue Jun 05, 2018: use v5.20
# Sat Nov 20, 2021: use v5.32. Renewed colophon. Revamped pragmas & encodings.
########################################################################################################################

# Package:
package RH::Math;

# Pragmas:
use v5.32;
use strict;
use warnings;
use experimental 'switch';
use utf8;
use warnings FATAL => 'utf8';

# Encodings:
use open ':std', IN  => ':encoding(UTF-8)';
use open ':std', OUT => ':encoding(UTF-8)';
use open         IN  => ':encoding(UTF-8)';
use open         OUT => ':encoding(UTF-8)';
# NOTE: these may be over-ridden later. Eg, "open($fh, '< :raw', e $path)".

# CPAN modules:
use Sys::Binmode;
use parent 'Exporter';
use Regexp::Common;
use bignum;
Math::BigFloat->accuracy(250);

# Symbols to be exported by default:
our @EXPORT = 
   qw
   (
      @PrimeWheel              number_of_digits         logb
      is_number                is_integer               is_nonnegative_integer
      is_positive_integer      is_negative_integer      is_prime
      primes_up_to
   );

# Private variables:
my $db = 1;

# Global variables:
our @PrimeWheel =
   (
        1,  11,  13,  17,  19,  23,  29,  31,  37,  41,  43,  47,
       53,  59,  61,  67,  71,  73,  79,  83,  89,  97, 101, 103,
      107, 109, 113, 121, 127, 131, 137, 139, 143, 149, 151, 157,
      163, 167, 169, 173, 179, 181, 187, 191, 193, 197, 199, 209
   );

# Subroutine Predeclarations And Prototypes:

sub number_of_digits         ($)   ; # Number of decimal digits in an integer.
sub logb                     ($$)  ; # Logarithm to base b of n.
sub is_number                ($)   ; # Is a value a real number?
sub is_integer               ($)   ; # Is a value an integer?
sub is_nonnegative_integer   ($)   ; # Is a value a non-negative integer?
sub is_positive_integer      ($)   ; # Is a value a positive integer?
sub is_negative_integer      ($)   ; # Is a value a negative integer?
sub is_prime                 ($)   ; # Is a value a prime number?
sub primes_up_to             ($)   ; # Generate prime numbers up to a value.

# Subroutine Definitions:

# Return number of digits in integer argument:
sub number_of_digits ($)
{
   my $n      = int(abs(shift));
   my $digits = 1;
   my $power  = 1;
   while ( $n / $power >= 10 )
   {
      ++$digits;
      $power *= 10;
   }
   return $digits;
}

# Log to base b of n:
sub logb ($$)
{
   my $b = shift;
   my $n = shift;
   return log($n)/log($b);
}

sub is_number ($)
{
   my $x = shift;
   if ($x =~ m/$RE{num}{real}/)
      {return 1;}
   else
      {return 0;}
}

sub is_integer ($)
{
   my $x = shift;
   if ($x =~ m/^-?\d+$/)           # If arg is digits w optional sign,
      {return 1;}                  # then arg represents an integer;
   else                            # otherwise,
      {return 0;}                  # it doesn't.
}   

sub is_nonnegative_integer ($)
{
   my $x = shift;                  # Get arg.
   if ($x =~ m/^\d+$/ && $x >= 0)  # If arg is digits only and is >= 0, 
      {return 1;}                  # then arg represents a non-negative integer;
   else                            # otherwise,
      {return 0;}                  # it doesn't.
}   

sub is_positive_integer ($)
{
   my $x = shift;                  # Get arg.
   if ($x =~ m/^\d+$/ && $x  > 0)  # If arg is digits-only and is > 0,
      {return 1;}                  # then arg represents a positive integer;
   else                            # otherwise,
      {return 0;}                  # it doesn't.
}   

sub is_negative_integer ($)
{
   my $x = shift;                  # Get arg.
   if ($x !~ m/^-\d+$/ && $x < 0)  # If arg is a negative sign followed by all-digits and is < 0,
      {return 1;}                  # then arg represents a negative integer;
   else                            # otherwise,
      {return 0;}                  # it doesn't.
}   

sub is_prime ($)
{
   my $i = 0 + shift;

   # If $i is not a positive integer, it is not a Prime Number:
   #return 0 if not is_positive_integer($i);

   # If $i is 1,4,6,8,9,10, $i is not prime:
   return 0 if $i==1||$i==4||$i==6||$i==8||$i==9||$i==10;

   # If $i is 2,3,5, or 7, then $i is prime:
   return 1 if $i==2||$i==3||$i==5||$i==7;

   # If $i is divisible by any of the first few primes, it's not prime:
   return 0 if !($i%2)||!($i%3)||!($i%5)||!($i%7);

   # If $i is divisible by any spoke numbers up to it's sqrt, it's not prime, 
   # so return 0:
   my $Limit = Math::BigInt->new(int(Math::BigFloat->new($i)->bsqrt()));
   say "\$Limit = $Limit" if $db;
   my $Test  = Math::BigInt->new(0);
   my $Ring  = Math::BigInt->new(0);
   my $Spoke = 1;
   for ( ; ; )
   {
      $Test = 210*$Ring + $PrimeWheel[$Spoke];
      if ($Test > $Limit) {say "TEST > LIMIT"    if $db; return 1;}
      if (0 == $i%$Test)  {say "MODULUS IS ZERO" if $db; return 0;}
      ++$Spoke;
      if ($Spoke == 48) {$Spoke = 0; ++$Ring;}
   }
}

sub primes_up_to ($)
{
   my $UpTo = shift;
   my @Primes = ();
   my $Candidate;
   my $Limit;

   for ( $Candidate = 2 ; $Candidate <= $UpTo ; $Candidate += 2 )
   {
      next if not is_prime($Candidate);
      push @Primes, $Candidate;
   }
   return \@Primes;
}

1;
