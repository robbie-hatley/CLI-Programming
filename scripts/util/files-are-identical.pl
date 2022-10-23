#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# files-are-identical.pl
# Tells you whether two specified files are identical or different.
# Input is via command-line arguments. Output is to STDOUT.
#
# Edit history:
# Sat Jun 27, 2015: Wrote it.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use RH::Util;
use RH::Dir;

sub help_msg;

# main
{
   # If user wants help, just print help and bail:
   if (@ARGV && ($ARGV[0] eq '-h' || $ARGV[0] eq '--help'))
   {
      help_msg;
      exit 777;
   }

   # If number of arguments is out of range, bail:
   if ( @ARGV != 2 ) 
   {
      die
      "\nError: files-are-identical.pl takes 2 arguments, which must be paths to\n".
      "two files to be compared. Use -h or --help option to get help.\n".
      "$!\n\n";
   }

   if ( FilesAreIdentical($ARGV[0],$ARGV[1]) )
   {
      print "\nFiles are identical.\n\n";
   }

   else
   {
      say "\nFiles are different.\n\n";
   }

   exit 0;
} # end main

sub help_msg 
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "files-are-identical.pl". This program simply compares two files
   and says whether or not they have identical content. (Name, size, date, and 
   attributes need not be the same for two files to be considered "identical"; 
   this program only compares contents.)

   Command line to get help:
   files-are-identical.pl [-h|--help]

   Command line to compare two files:
   files-are-identical.pl 'file1' 'file2'

   'file1' and 'file2' must be valid paths to two files to be compared.
   Enclosing both paths with 'single quotes' is highly recommended, 
   because otherwise, if either path contains spaces or certain other characters, 
   the shell may not properly pass the paths to the program.

   files-are-identical.pl   hi there 1.txt   hi there 2.txt   # FAILS
   files-are-identical.pl  'hi there 1.txt' 'hi there 2.txt'  # WORKS

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
}
