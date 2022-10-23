#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# /rhe/scripts/util/rot13.pl
# Performs ROT13 encoding on text.
#
# Written by Robbie Hatley circa Friday July 4, 2014.
#
# Edit history:
# Fri Jul 04, 2014: Wrote it. (Date is a wild guess.)
# Fri Jul 17, 2015: Made minor improvements.
# Fri Feb 05, 2016: Cleaned up formatting.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

while(<>)
{
   tr/A-Za-z/N-ZA-Mn-za-m/; # rot13 encryption.
   print;
}
