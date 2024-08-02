#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# bubble-babble.pl
# Encrypts text into "Bubble Babble" format.
#
# Edit history:
# Mon Feb 24, 2020: Wrote it.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Fri Aug 04, 2023: Updated from "v5.32" to "v5.36". Got rid of "common::sense" (antiquated). Moved to "filters".
# Fri Aug 02, 2024: Got rid of "use strict", "use warnings", "use Sys::Binmode".
########################################################################################################################

use v5.36;
use utf8;

use Digest::BubbleBabble 'bubblebabble';

while(<>) {
   s/\s+$//;
   say(bubblebabble(Digest=>$_));
}
