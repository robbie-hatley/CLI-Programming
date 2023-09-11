#!/usr/bin/perl

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks (\x{0A}).
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

################################################################
# "comb-non-bigint.pl"
# Prints number of combinations of n things taken k at a time.
# Edit history:
#    Sun Feb 28, 2016 - Wrote it.
################################################################

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

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
   my $n = $ARGV[0];
   my $k = $ARGV[1];
   my $nok = comb($n, $k);
   say "$n comb $k = $nok";
   exit 0;
}
