#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# reverse-line-order.pl
# Prints lines from stdin to stdout in reverse order.
#
# Written by Robbie Hatley on Monday April 20, 2020.
#
# Edit history:
# Mon Apr 20, 2020: Wrote it.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
# Thu Dec 09, 2021: Fixed bug in which lines were being printed in reverse-SORT order instead of REVERSE order.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

print for reverse <> ;
