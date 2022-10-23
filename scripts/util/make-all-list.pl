#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# make-all-list.pl
# Intended to be called by maketail to make lists of exe files corresponding to *.c or *.cpp files in the current
# directory. If any of the source or header files in /rhe/src/librh change, then the files in @library_dependent
# will be re-made. The assumption here is that all C and C++ files are library-dependent.
# That's not fully true, but keeping track of which are and which aren't quickly became futile, so if anything in
# librh changes, I remake all exe's which are based on c, cpp, h, or hpp files.
#
# Edit history:
# Sat Mar 28, 2015: Wrote it.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Thu Nov 25, 2021: Simplified and synchronized comments.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

my @names = `ls -1`; # Doesn't need d! Due to piping from ls's STDOUT to this program's STDIN?
my @library_dependent;
foreach (@names)
{
   s/\s+$//;
   if (m/\.(c|cpp)$/)
   {
      if ($ENV{DESKTOP_SESSION} eq 'mate')
      {
         s/\.(c|cpp)$//;
      }
      else
      {
         s/\.(c|cpp)$/.exe/;
      }
      push(@library_dependent, $_);
   }
}
$, = ' '; # insert single space between fields
print(@library_dependent, "\n");

