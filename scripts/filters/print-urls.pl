#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# print-urls.pl
# Prints those lines of a file which contain "http:".
#
# Written by Robbie Hatley on Saturday January 10, 2015.
#
# Edit history:
# Sat Jan 10, 2015: Wrote it.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Sun Apr 17, 2016: Changed regex to "/https?:/".
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

while (<>)
{
   print if /https?:/;
}
