#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# dir-tree.pl
# Prints tree of all sub-directories of the current working directory.
#
# Edit history:
# Fri Apr 24, 2015: Wrote it.
# Fri Jul 17, 2015: Upgraded for utf8.
# Thu Apr 14, 2016: Now using -CSDA.
# Sat Feb 13, 2021: Changed encoding of this file to ASCII. Changed width to 110. Dramatically simplified method of
#                   passing code ref to RecurseDirs.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use RH::Dir;

RecurseDirs {say cwd_utf8};
