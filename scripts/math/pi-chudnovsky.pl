#!/usr/bin/env perl

##############################################################################################################
# File name: "pi-chudnovsky.pl"
# Prog name: "pi-chudnovsky"
# Prog dscr: Prints first 10,000 digits of Pi, using the Chudnovsky series.
# Written by Robbie Hatley.
# Edit history:
# Sun Dec 01, 2024: Wrote it.
##############################################################################################################

use v5.36;
use bignum 'lib'=>'GMP', 'a'=>12000;

sub sum ($n) {
   my $sum = 0+0;
   for my $k (0..$n) {
      my $skf = 6*$k;$skf->bfac();
      my $tkf = 3*$k;$tkf->bfac();
      my $okf = 1*$k;$okf->bfac();
      my $num = (0-1)**(1*$k)*$skf*(13591409+545140134*$k);
      my $den = $tkf*$okf**(0+3)*(0+640320)**(3*$k);
      my $quo = $num/$den;
      $sum += $quo;
   }
   return $sum;
}

sub pi ($n) {
   return(426880*sqrt(10005)/sum($n));
}

my $pi = pi(1000);
say substr $pi->bstr(), 0, 10003;
