#!/usr/bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# rebrace.pl
# Brace-adjusting utility for Perl scripts.
# Converts left braces from end-of-line style to separate-line style.
#
# Written Monday May 11, 2015, by Robbie Hatley.
#
# Edit history:
# Mon May 11, 2015: Wrote first draft.
# Fri Jul 17, 2015: Upgraded for utf8, but it has some bugs.
# Sat Apr 16, 2016: Now using -CSDA.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use RH::WinChomp;

while (<>)
{
   winchomp;
   s/^(\s*)(\S.*\S)\s*\{(\s*#.*)$/$1$2 $3\n$1\{/;
   s/^(\s*)(\S.*\S)\s*\{\s*$/$1$2\n$1\{/;
   say;
}
