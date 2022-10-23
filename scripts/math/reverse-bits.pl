#! /usr/bin/perl
# reverse-bits.pl
use v5.30;
use Scalar::Util qw( looks_like_number );
sub reverse_bits
{
   my $x = shift;
   my $r = 0;
   for (0..7) {$r += 128 >> $_ if $x & 1 << $_ ;}
   return $r;
}
exit if 1 != @ARGV;
exit if !looks_like_number($ARGV[0]);
my $n = int($ARGV[0]+0);
exit if $n < 0;
exit if $n > 255;
say reverse_bits $ARGV[0];
