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
# Thu Feb 09, 2023: Can now print dir-tree of any directory, not just curdir.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use RH::Dir;

if (@ARGV && ('-h' eq $ARGV[0] || '--help' eq $ARGV[0]))
{
   say "This program prints the directory structure of the current working directory,";
   say "or of the directory given as its first argument.";
   exit;
}

if (@ARGV)
{
   chdir e $ARGV[0] or die "Couldn't chdir to directory '$ARGV[0]'."
}

RecurseDirs {say cwd_utf8};
