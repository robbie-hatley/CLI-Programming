#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# text-to-fold.pl
# Converts text to fold-case.
#
# Written by Robbie Hatley on Tuesday January 26, 2021.
#
# Edit history:
# Tue Jan 26, 2021: Wrote it.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Renamed to "text-to-fold.pl" and reformatted titlecard.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

print for map {fc} <>;
