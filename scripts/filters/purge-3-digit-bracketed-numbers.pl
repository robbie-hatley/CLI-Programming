#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# purge-3-digit-bracketed-numbers.pl
#
# Written by Robbie Hatley (date unknown).
#
# Edit history:
# Fri Jan 01, 2021: I probably wrote this in 2021, but I neglected to write-down the date.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
# Sun Aug 04, 2024: Reduced width from 120 to 110. Upgraded from "v5.32" to "v5.36".
#                   Got rid of "use common::sense". Got rid of "use Sys::Binmode". Added "use utf8".
##############################################################################################################

use v5.36;
use utf8;

while (<>) {say s/\[\d{3}\]//gr;}
