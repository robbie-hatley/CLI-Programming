#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# reverse-line-order.pl
# Prints lines from stdin to stdout in reverse order.
#
# Written by Robbie Hatley on Monday April 20, 2020.
#
# Edit history:
# Mon Apr 20, 2020: Wrote it.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
# Thu Dec 09, 2021: Now prints lines in Fixed bug in REVERSE order instead of reverse-SORT order.
# Sun Aug 04, 2024: Reduced width from 120 to 110. Upgraded from "v5.32" to "v5.36".
#                   Got rid of "use common::sense". Got rid of "use Sys::Binmode". Added "use utf8".
##############################################################################################################

use v5.36;
use utf8;

print for reverse <> ;
