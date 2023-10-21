#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# sort-lines-by-codepoint-ascending-case-insensitively.pl
#
# Written by Robbie Hatley on Wednesday June 24, 2015.
#
# Edit history:
# Wed Jun 24, 2015: Wrote it.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Refactored and reformatted titlecard.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Unicode::Normalize qw( NFD );

print for         sort {fc(NFD($a)) cmp fc(NFD($b))} <> ;
