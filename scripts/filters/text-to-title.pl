#!/usr/bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# text-to-title.pl
# Converts text to title-case.
#
# Written by Robbie Hatley on Wednesday December 8, 2021.
#
# Edit history:
# Wed Dec 08, 2021: Wrote it.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

print for map {$_=fc($_); s/([~']?\b\w)/\u$1/gr;} <>;
