#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# make-x-list.pl
# Intended to be called by maketail to make lists of exe files corresponding to        *.cpp files in
# the current directory. If any of the source or header files in /rhe/src/librh change, then the files in
# @library_dependent will be re-made. The assumption here is that all C and C++ files are library-dependent.
# That's not fully true, but keeping track of which are and which aren't quickly became futile, so if ANYTHING
# in librh changes, I remake ALL executables which are based on ANY c, cpp, h, or hpp files.
#
# Edit history:
# Thu Apr 02, 2015: Wrote it.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and
#                   "Sys::Binmode".
# Thu Nov 25, 2021: Simplified and synchronized comments.
# Fri Aug 11, 2023: Upgraded from "v5.32" to "v5.36". Got rid of "common::sense".
# Sat Aug 12, 2023: Reduced width from 120 to 110.
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';
use Sys::Binmode;

my @names = `ls -1`; # Doesn't need decoding! Due to piping from ls's STDOUT to this program's STDIN?
my @library_dependent;
foreach (@names)
{
   s/\s+$//;
   if (m/\.cpp$/)
   {
      if ($ENV{PLATFORM} eq 'Linux')
      {
         s/\.(cpp)$//;
      }
      else
      {
         s/\.(cpp)$/.exe/;
      }
      push(@library_dependent, $_);
   }
}
$, = ' '; # insert single space between fields
say @library_dependent;
