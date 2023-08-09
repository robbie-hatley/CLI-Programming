#! /usr/bin/perl

###############################################################################
# /rhe/scripts/util/Euler-0022_name-scores.perl                               #
# Sums name scores of names in a list                                         #
# Author: Robbie Hatley                                                       #
# Edit history:                                                               #
#    Thu Feb 25, 2016 - Wrote it.                                             #
###############################################################################

use v5.022;
use strict;
use warnings;
no  warnings 'experimental::smartmatch';
use List::Util 'sum';

$, = ' ';


sub score ($$)
{
   my $Name  = shift;
   my $Index = shift;
   return $Index * sum map {$_ - 64} unpack 'C*', $Name;
}

# main
{
   my $Score = 0;
   my $Index = 0;
   my $Name  = '';
   open(HNDL, '<', '/rhe/Euler/Euler-022_names.txt') 
      or die "Can't open names file.\n$!\n";
   while ($Name = <HNDL>)
   {
      ++$Index;
      chomp $Name;
      $Score += score $Name, $Index;
   }
   close(HNDL)
      or die "Can't close names file.\n$!\n";
   say $Score;
   exit 0;
}
