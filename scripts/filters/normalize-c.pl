#!/usr/bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# normalize-c.pl
# Normalizes input text (from stdin) to Unicode form-c and outputs (to stdout).
#
# Written by Robbie Hatley on Monday February 26, 2018.
#
# Edit history:
# Mon Feb 26, 2018: Wrote it.
# Wed Feb 24, 2021: Got rid of Settings hash.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Unicode::Normalize qw( NFC );

print map {NFC($_)} <> ; # Normalize to Form C.
