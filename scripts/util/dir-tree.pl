#!/usr/bin/env -S perl -CSDA

# This is a 110-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# dir-tree.pl
# Prints tree of all sub-directories of the current working directory.
#
# Edit history:
# Fri Apr 24, 2015: Wrote it.
# Fri Jul 17, 2015: Upgraded for utf8.
# Thu Apr 14, 2016: Now using -CSDA.
# Sat Feb 13, 2021: Changed encoding of this file to ASCII. Changed width to 110. Dramatically simplified
#                   method of passing code ref to RecurseDirs.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and
#                   "Sys::Binmode".
# Thu Feb 09, 2023: Can now print dir-tree of any directory, not just curdir.
# Thu Sep 07, 2023: Reduced width from 120 to 110. Upgraded from "v5.32" to "v5.36". Got rid of CPAN module
#                   "common::sense" (antiquated). Can now run RecurseDirs once for each argument.
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

use Sys::Binmode;
use Cwd;

use RH::Dir;

for ( @ARGV ) {
   if ( /^-h$/ || /^--help$/ ) {
      say "This program prints the directory structure of the current working directory,";
      say "or of directories given as arguments.";
      exit;
   }
}

if ( @ARGV ) {
   my $starting_directory = d(getcwd);
   for ( @ARGV ) {
      chdir(e($_)) or die "Couldn't chdir to directory \"$_\".\n$!\n";
      RecurseDirs {say(d(getcwd))};
      chdir(e($starting_directory)) or die "Couldn't chdir to directory \"$starting_directory\".\n$!\n";
   }
}
else {
   RecurseDirs {say(d(getcwd))};
}
