#!/usr/bin/env perl

##############################################################################################################
# File name: "pi-ramanujan.pl"
# Prog name: "pi-ramanujan"
# Prog dscr: Prints first 1000 digits of Pi, using the Ramanujan series.
# Written by Robbie Hatley.
# Edit history:
# Sun Dec 01, 2024: Wrote it.
##############################################################################################################

use v5.36;
use bignum 'lib'=>'GMP', a => 1200;

sub sum ($n) {
   my $sum = 0;
   for my $k (0..$n) {
      my $fkf = 4*$k;$fkf->bfac();
      my $okf = 1*$k;$okf->bfac();
      my $num = $fkf*(1103+26390*$k);
      my $den = $okf**4*396**(4*$k);
      my $quo = $num/$den;
      $sum += $quo;
   }
   return $sum;
}
sub pi ($n) {9801/2/sqrt(2)/sum($n)}
my $pi = pi(150);
say substr $pi->bstr(), 0, 1003;
