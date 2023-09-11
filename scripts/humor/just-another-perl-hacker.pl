#!/usr/bin/perl

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks (\x{0A}).
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

# "big-int.pl"

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

use bigint;
$n=71423350343770280161397026330337371139054411854220053437565440;
$m=-8,;;$_=$n&(0xff)<<$m,,$_>>=$m,,print+chr,,while(($m+=8)<=200);
