#!/usr/bin/perl

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# list-open-windows.pl
#
# Written by Robbie Hatley on Thursday December 9, 2021.
#
# Edit history:
# Thu Dec 09, 2021: Wrote it.
# Wed Aug 14, 2024: Narrowed to 110. Upgraded from "v5.32" to "v5.36". Removed unnecessary "use" statements.
##############################################################################################################

use v5.36;
use utf8;
use Encode;

my @lines =   map {decode('UTF-16LE', $_) } `list-open-windows.exe`;
for (@lines) {say  encode('UTF-8'   , $_);}
