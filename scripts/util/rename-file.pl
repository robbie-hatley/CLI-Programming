#!/usr/bin/env -S perl -C63

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# rename-file.pl
# Renames a file.
# Written by Robbie Hatley.
# Edit history:
# Tue Apr 14, 2015: Wrote it.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and
#                   "Sys::Binmode".
# Thu Sep 07, 2023: Upgraded from "v5.32" to "v5.36". Reduced width from 120 to 110.
# Wed Aug 14, 2024: Removed unnecessary "use" statements.
##############################################################################################################

use v5.36;
use utf8;
use RH::Dir;
if ( 2 != scalar(@ARGV) || ! -e $ARGV[0] ) {
   warn "Error: \"rename-file.pl\" needs exactly two arguments.\n"
       ."The first  argument must be a path to an existing file.\n"
       ."The second argument must be a valid path to rename the file to.\n"
       ."Aborting program execution.\n";
   exit 666;
}
say "\"rename-file.pl\" will attempt the following file rename:";
say "Original file path: $ARGV[0]";
say "Proposed file path: $ARGV[1]";
rename_file($ARGV[0], $ARGV[1])
and say "Rename succeeded."
or  say "Rename failed.";
