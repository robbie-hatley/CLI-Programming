#! /usr/bin/perl
# "Euler-033_Digit-Cancelling-Fractions_V2.perl"
# Finds all "digit-cancelling" fraction pairs of the form a/b=c/d
# were a/b and c/d are both < 1.
use 5.026_001;
use strict;
use warnings;
use bigrat;

our @Fracs2 = ();
our @Fracs3 = ();

my $i;
my $j;
my $fract;
my $product;
my $time0;
my $a;
my $b;
my $c;
my $d;

$time0 = time;

for ( $j = 11 ; $j <= 99 ; ++$j )
{
   for ( $i = 10 ; $i < $j ; ++$i )
   {
      push @Fracs2, [$i,$j];
   }
}

for ( $i = 0 ; $i < scalar(@Fracs2) ; ++$i )
{
   $a = int substr($Fracs2[$i]->[0],0,1);
   $b = int substr($Fracs2[$i]->[0],1,1);
   $c = int substr($Fracs2[$i]->[1],0,1);
   $d = int substr($Fracs2[$i]->[1],1,1);

   # Skip current fraction if its right digits are 0, top or bottom.
   # (No need to check for left digits being 0; they never are.
   # And cancelling right 0s are considered "trivial".)
   next if $b == 0 || $d == 0;

   # Is digit cancelling happening?
   $fract = int($Fracs2[$i]->[0]) / int($Fracs2[$i]->[1]);
   if ($a == $c && $fract == $b / $d ||
       $a == $d && $fract == $b / $c ||
       $b == $c && $fract == $a / $d ||
       $b == $d && $fract == $a / $c   )
   {
      say           $Fracs2[$i]->[0], "/", $Fracs2[$i]->[1], " = ", 
                    $Fracs2[$i]->[0]   /   $Fracs2[$i]->[1];
      push @Fracs3, $Fracs2[$i]->[0]   /   $Fracs2[$i]->[1];
   }
}

$product = 1/1;
foreach $fract (@Fracs3)
{
   $product *= $fract;
}
say "Product = $product";
say "Elapsed time = ", time-$time0, " seconds.";
