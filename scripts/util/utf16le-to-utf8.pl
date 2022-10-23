#! /bin/perl

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# utf16le-to-utf8.pl
# Converts UTF-16LE text to UTF-8 text.
# Written Wed Dec 01, 2021 by Robbie Hatley.
# Edit history:
# Wed Dec 01, 2021: Wrote it.
########################################################################################################################

use v5.32;
use Sys::Binmode;
use Encode;

my $cmd = $ARGV[0];
my @lines = map {decode('UTF-16LE', $_)} <>;

for (@lines)
{
   s/\s+$//;
   say encode('UTF-8', $_);
}
