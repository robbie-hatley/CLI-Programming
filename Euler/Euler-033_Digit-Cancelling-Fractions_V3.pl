#! /usr/bin/perl
# "Euler-033_Digit-Cancelling-Fractions_V3.perl"
# Finds all "digit-cancelling" fraction pairs of the form a/b=c/d
# were a/b and c/d are both < 1.
use 5.026_001;
use strict;
use warnings;
use bigrat;

our @Fracs = ();

my $time0;
my $ab;
my $cd;
my $a;   
my $b;
my $c;
my $d;
my $fract;
my $product;

$time0 = time;

for ( $cd = 12 ; $cd <= 99 ; ++$cd )
{
   for ( $ab = 11 ; $ab < $cd ; ++$ab )
   {
      $a = 0 + substr($ab, 0, 1);
      $b = 0 + substr($ab, 1, 1);
      $c = 0 + substr($cd, 0, 1);
      $d = 0 + substr($cd, 1, 1);
      # Skip this fraction if right digit of $ab or $cd is 0:
      next if $b == 0 || $d == 0;
      # Is digit cancelling happening?
      $fract = $ab / $cd;
      if ($a == $c && $fract == $b / $d ||
          $a == $d && $fract == $b / $c ||
          $b == $c && $fract == $a / $d ||
          $b == $d && $fract == $a / $c   )
      {
         say $ab , "/" , $cd , " = " , $fract ;
         push @Fracs, $fract;
      }
   }
}

$product = 1/1;
foreach $fract (@Fracs)
{
   $product *= $fract;
}
say "Product = $product";

say "Elapsed time = ", time-$time0, " seconds.";
