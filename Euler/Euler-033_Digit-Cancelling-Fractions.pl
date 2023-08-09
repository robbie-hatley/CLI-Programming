#! /usr/bin/perl
# "Euler-033_Digit-Cancelling-Fractions.perl"
# Finds all "digit-cancelling" fraction pairs of the form a/b=c/d
# were a/b and c/d are both < 1.
use 5.026_001;
use strict;
use warnings;
use bigrat;

our @Fracs1 = ();
our @Fracs2 = ();
our @Fracs3 = ();

my $i;
my $j;
my $frac1;
my $frac2;
my $fract;
my $product;
my $time0;

$time0 = time;

for ( $j = 2 ; $j <= 9 ; ++$j )
{
   for ( $i = 1 ; $i < $j ; ++$i )
   {
      push @Fracs1, [$i,$j];
   }
}

for ( $j = 11 ; $j <= 99 ; ++$j )
{
   for ( $i = 10 ; $i < $j ; ++$i )
   {
      push @Fracs2, [$i,$j];
   }
}

foreach $frac2 (@Fracs2)
{
   foreach $frac1 (@Fracs1)
   {
      if ($frac2->[0]/$frac2->[1] == $frac1->[0]/$frac1->[1])
      {
         if (substr($frac2->[0],0,1) == substr($frac2->[1],0,1) &&
             substr($frac2->[0],1,1) == $frac1->[0]             &&
             substr($frac2->[1],1,1) == $frac1->[1]             ||
             substr($frac2->[0],0,1) == substr($frac2->[1],1,1) &&
             substr($frac2->[0],1,1) == $frac1->[0]             &&
             substr($frac2->[1],0,1) == $frac1->[1]             ||
             substr($frac2->[0],1,1) == substr($frac2->[1],0,1) &&
             substr($frac2->[0],0,1) == $frac1->[0]             &&
             substr($frac2->[1],1,1) == $frac1->[1]             ||
             substr($frac2->[0],1,1) == substr($frac2->[1],1,1) &&
             substr($frac2->[0],0,1) == $frac1->[0]             &&
             substr($frac2->[1],0,1) == $frac1->[1]             &&
             substr($frac2->[0],1,1) != 0                         )
         {
            say $frac2->[0], "/", $frac2->[1], " = ", 
                $frac1->[0], "/", $frac1->[1];
            push @Fracs3, $frac1->[0] / $frac1->[1];
         }
      }
   }
}

$product = 1/1;
foreach $fract (@Fracs3)
{
   $product *= $fract;
}
say "Product = $product";
say "Elapsed time = ", time-$time0, " seconds.";
