#! /bin/perl

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks (\x{0A}).
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# polynomial.pl
# Calculates polynomial functions.
#
# Edit history:
#    Sun Jan 31, 2021: Wrote it.
########################################################################################################################

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

use common::sense;
sub Poly
{
   my @coefs = @_;
   return sub
   {
      my $x = shift;
      my $v = 0;
      $v = $x * $v + $_ for @coefs;
      return $v
   }
}
my $f = Poly(@ARGV);
my ($x, $y);
for ( $x = -5.0 ; $x < 5.001 ; $x += 0.1 )
{
   $y = &$f($x);
   printf("f(%7.4f) = %10.4f\n", $x, $y);
}
