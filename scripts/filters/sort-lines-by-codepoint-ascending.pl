#!/usr/bin/env -S perl -CSDA

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# sort-lines-by-codepoint-ascending.pl
#
# Written by Robbie Hatley (date unknown).
#
# Edit history:
# Wed Jun 24, 2015: Wrote it.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Refactored and reformatted titlecard.
# Sun Aug 04, 2024: Reduced width from 120 to 110. Upgraded from "v5.32" to "v5.36". Added "use utf8".
#                   Got rid of "common::sense" and "Sys::Binmode".
##############################################################################################################

use v5.36;
use utf8;

use Unicode::Normalize qw( NFD );

print for sort {   NFD($a)  cmp    NFD($b) } <> ;
