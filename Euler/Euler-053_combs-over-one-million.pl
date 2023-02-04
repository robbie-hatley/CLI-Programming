#!/usr/bin/perl

# This is an 79-character-wide ASCII-encoded Perl source-code text file.
# =======|=========|=========|=========|=========|=========|=========|=========

###############################################################################
# /rhe/scripts/Euler/Euler-0053_combs-over-one-million.perl
# Uses Pascal's triangle to find out how many of comb(n,k) values are greater
# that 1,000,000 for 1<=n<=100.
# Edit history:
#    Sun Feb 28, 2016 - Wrote it.
###############################################################################
use v5.022;
use strict;
use warnings;
use bigint;

sub fact ($)
{
   my $x = shift;
   my $fact = 1;
   $fact *= $_ for (2..$x);
   return $fact;
}

sub comb ($$)
{
   my $n = shift;
   my $k = shift;
   my $comb = fact($n)/fact($n-$k)/fact($k);
   return $comb;
}

# main
{
   my $Total = 0;
   # For the purposes of this exercise, we're starting with row 20 of
   # Pascal's triangle, because none of the first 20 rows have any numbers 
   # over 1,000,000.
   my $n = 20;
   while ($n <= 100)
   {
      # While it's tempting to start with $k = 1, that would be DISASTROUS!
      # The nth row of Pascal's triangle contains n+1 numbers indexed
      # k = 0 through n, with the values of the numbers equal to 
      # comb(n,0) through comb(n,n). The numbers on the outer edges of the
      # triangle are all 1, and the biggest numbers are clustered around
      # the center vertical axis, and every row is not only symmetric, 
      # but also palindromic.
      my $k = 0;

      # We need to iterate up to, and including, but not beyond, the center
      # center point of this row of pascal's triangle:
      while ($k <= $n/2)
      {
         my $comb = comb($n, $k);
         say "$n comb $k = $comb";
         if ($comb > 1000000)
         {
            last;
         }
         ++$k;
      }

      # If $k is now past the center, then none of the numbers on the 
      # current row of Pascal's triangle are greater than 1,000,000. 
      # Hence do not increase $Total:
      if ($k > $n/2)
      {
         ; # Do nothing. (Leave $Total as it was.)
      }

      # Otherwise, we DID find a number above 1,000,000, at position $k. 
      # And because every row of Pascal's triangle is palindromic, all of the 
      # numbers on this row of Pascal's triangle will be greater than 
      # 1,000,000 EXCEPT FOR $k numbers on the left and $k numbers on the 
      # right. Hence the number of numbers on this row which are > 1,000,000 
      # is ($n+1)-2*$k. (Remember that the rows of Pascal's Triangle are 
      # zero-indexed both horizontally and vertically, with row numbers 
      # 0,1,2,... and with row $n having $n+1 entries  with col numbers 
      # 0 through $n. Therefore the number of numbers to the left of index $k 
      # is $k, not $k-1.)
      else
      {
         my $millionaires = ($n+1) - 2*$k;
         say "n = $n    k = $k";
         say "millionaires on this row = $millionaires";
         $Total += ($millionaires);
      }
      ++$n;
   }
   say "Total = $Total";
   exit 0;
}
