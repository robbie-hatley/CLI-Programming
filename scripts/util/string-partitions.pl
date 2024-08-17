#!/usr/bin/perl
use v5.36;
use utf8;
$, = ' ';

sub string_partitions ($string) {
   my @partitions;
   my $size = length($string);
   if ( 0 == $size )
   {
      @partitions = ([]);
   }
   else
   {
      my ($first, $second);
      for ( my $part = 1 ; $part <= $size ; ++$part )
      {
         $first  = substr($string, 0,     $part        );
         $second = substr($string, $part, $size - $part);
         my @partials = string_partitions($second);
         for (@partials) {unshift @$_, $first;}
         push @partitions, @partials;
      }

   }
   return @partitions;
}

for (@ARGV)
{
   say '';
   say "All possible partitions of \"$_\":";
   for (string_partitions($_))
   {
      say @$_;
   }
}
