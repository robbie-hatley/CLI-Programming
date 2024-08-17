#!/usr/bin/env -S perl -CSDA

# This is an 78-character-wide Unicode UTF-8 Perl-source-code text file.
# ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|========

# "de-vowel.pl"

use v5.32;
use strict;
use warnings;
use warnings FATAL => "utf8";
use utf8;

while (<>)
{
   tr/aeiouAEIOU//d;
   print;
}
