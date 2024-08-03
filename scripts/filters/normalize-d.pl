#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# normalize-d.pl
# Normalizes input text (from stdin) to Unicode form-d and outputs (to stdout).
#
# Written by Robbie Hatley on Monday February 26, 2018.
#
# Edit history:
# Mon Feb 26, 2018: Wrote it.
# Wed Feb 24, 2021: Got rid of "Settings" hash.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
# Thu Aug 01, 2024: Upgraded to "v5.36" and got rid of CPAN modules "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.36;
use Unicode::Normalize 'NFD';

print map {NFD($_)} <> ; # Normalize to Form D.
