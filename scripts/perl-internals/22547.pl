#!/usr/bin/env perl
use v5.40;
use Scalar::Util qw(weaken);

my $wref;
{
   my $x;
   my $subject = sub {
      $x = $_[0];

      my $y;
      return sub { $y };
   };
   my $subscriber = {};
   weaken($wref = $subscriber);
   $subscriber->{foo} = $subject->($subscriber);
}
!defined $wref or die "Leak";
