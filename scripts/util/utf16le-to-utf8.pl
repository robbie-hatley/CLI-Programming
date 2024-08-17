#!/usr/bin/perl

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# utf16le-to-utf8.pl
# Converts UTF-16LE text to UTF-8 text.
# Written Wed Dec 01, 2021 by Robbie Hatley.
# Edit history:
# Wed Dec 01, 2021: Wrote it.
# Wed Aug 09, 2023: Upgraded from "v5.32" to "v5.36". Reduced width from 120 to 110. Added "use utf8".
# Wed Aug 14, 2024: Removed unnecessary "use" statements.
##############################################################################################################

use v5.36;
use utf8;
use Encode qw( encode decode );

my $cmd = $ARGV[0];
my @lines = map {decode('UTF-16LE', $_)} <>;

for (@lines)
{
   s/\s+$//;
   say encode('UTF-8', $_);
}
