#!/usr/bin/perl

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# quadratic.pl
# Calculates quadratic functions.
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
exit 666 if 3 != scalar(@ARGV);
sub Quad
{
   my $a = shift;
   my $b = shift;
   my $c = shift;
   return sub {my $x = shift; return $a*$x*$x + $b*$x + $c;}
}
my $f = Quad(@ARGV);
my ($x, $y);
for ( $x = -5.0 ; $x < 5.001 ; $x += 0.1 )
{
   $y = &$f($x);
   printf("f(%7.4f) = %10.4f\n", $x, $y);
}
