#!/usr/bin/perl -CSDA

# This is an 78-character-wide UTF-8-encoded Perl source-code text file.
# ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|========

# "my-name-is.pl"

use v5.32;
use strict;
use warnings;
use warnings FATAL => "utf8";
use utf8;

say "Hi! My name is $0!";
