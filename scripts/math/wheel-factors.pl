#!/usr/bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks (\x{0A}).
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

# wheel-factors.pl

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

my @Wheel =
(
    11,  13,  17,  19,  23,  29,  31,  37,  41,  43,
    47,  53,  59,  61,  67,  71,  73,  79,  83,  89,
    97, 101, 103, 107, 109, 113, 121, 127, 131, 137,
   139, 143, 149, 151, 157, 163, 167, 169, 173, 179,
   181, 187, 191, 193, 197, 199, 209, 211
);

system("factor $_") for @Wheel;
