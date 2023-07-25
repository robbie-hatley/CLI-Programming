#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks (\x{0A}).
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

use v5.32;
use utf8;
use Sys::Binmode;
use experimental 'switch';
use strict;
use warnings;
use warnings FATAL => "utf8";

for my $key (keys %main::)
{
   my $value = $main::{$key};
   $key   =~ s/[^\pL\pN\pM\pP\pS]+/↑/g;
   $value =~ s/[^\pL\pN\pM\pP\pS]+/↑/g;
   printf("%-30s%-30s\n", $key, $value);
}
