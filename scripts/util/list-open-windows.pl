#! /bin/perl

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# list-open-windows.pl
#
# Written by Robbie Hatley on Thursday December 9, 2021.
#
# Edit history:
# Thu Dec 09, 2021: Wrote it.
########################################################################################################################

use v5.32;
use Sys::Binmode;
use Encode;

my @lines =   map {decode('UTF-16LE', $_) } `list-open-windows.exe`;
for (@lines) {say  encode('UTF-8'   , $_);}
