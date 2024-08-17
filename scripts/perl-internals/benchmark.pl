#!/usr/bin/perl

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

# "benchmark.pl"

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

use Time::HiRes 'time';

my ($t1, $t2, $elapsed);
my $p = 1;

BEGIN
{
   $t1 = time();
   warn("Entry   time: $t1 seconds\n");
}

{
   for ( 1 .. 1000 )
   {
      $p *= 1.00248567;
   }
   say "\$p = $p";
}

END
{
   $t2 = time();
   $elapsed = $t2 - $t1;
   warn("Exit    time: $t2 seconds\n");
   warn("Elapsed time: $elapsed seconds\n");
}
