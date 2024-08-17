#!/usr/bin/perl

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

our $range = (defined $ARGV[0]) ? $ARGV[0] : 10;
our @array = (1..$range);

for my $i (0..$#array) {
   my $span = rand(4)+1;
   $array[$i] += (rand(2*$span) - $span);
   say $array[$i];
}
