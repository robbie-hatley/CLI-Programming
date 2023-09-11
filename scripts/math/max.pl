#!/usr/bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks (\x{0A}).
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

# "max.pl"
# Prints maximum of numbers given as CL args.

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

use List::Util qw( max );
say max @ARGV;
