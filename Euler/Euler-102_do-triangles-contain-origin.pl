#!/usr/bin/perl
# /rhe/scripts/Euler/Euler-0102_do-triangles-contain-origin.perl
# Determines whether triangles contain origin.

use v5.022;
use strict;
use warnings;

$, = ' ' ;  # output field  separator
$\ = "\n";  # output record separator
$" = ' ' ;  # interpolation separator

sub ($$) intercept
{
   my $Point1 = shift;
   my $Point2 = shift;
   


}
   

# main
{
   open (H, '<', '/rhe/scripts/Euler/p102_triangles.txt')
      or die "Can't open p102_triangles.txt.\n$!";
   my $Index = 0;
   my $Count = 0;
   while (<H>)
   {
      chomp;
      my @Numbers = split /,/, $_;
      my $Triangle;
      $Triangle->{point1}->[0] = $Numbers[0];
      $Triangle->{point1}->[1] = $Numbers[1];
      $Triangle->{point2}->[0] = $Numbers[2];
      $Triangle->{point2}->[1] = $Numbers[3];
      $Triangle->{point3}->[0] = $Numbers[4];
      $Triangle->{point3}->[1] = $Numbers[5];
      print "Triangle $Index point 0: @{$Triangle->{point1}}";
      print "Triangle $Index point 1: @{$Triangle->{point2}}";
      print "Triangle $Index point 2: @{$Triangle->{point3}}";
      # Calculate the intercepts:
      $Triangle->{intercept12} = 
         intercept($Triangle->{point1},$Triangle->{point2});
      $Triangle->{intercept23} = 
         intercept($Triangle->{point2},$Triangle->{point3});
      $Triangle->{intercept31} = 
         intercept($Triangle->{point3},$Triangle->{point1});
      # How many intercepts are <= 0?
      my $Under = 0;
      ++$Under if defined($Triangle->{intercept12}) 
                       && $Triangle->{intercept12} <= 0;
      ++$Under if defined($Triangle->{intercept23}) 
                       && $Triangle->{intercept23} <= 0;
      ++$Under if defined($Triangle->{intercept31}) 
                       && $Triangle->{intercept31} <= 0;
      # How many intercepts are >= 0?
      my $Over = 0;
      ++$Over  if defined($Triangle->{intercept12}) 
                       && $Triangle->{intercept12} <= 0;
      ++$Over  if defined($Triangle->{intercept23}) 
                       && $Triangle->{intercept23} <= 0;
      ++$Over  if defined($Triangle->{intercept31}) 
                       && $Triangle->{intercept31} <= 0;
      ++$Count if $Under > 0 && $Over > 0;
      ++$Index;
   }

   close H;
   exit 0;
} # end MAIN

