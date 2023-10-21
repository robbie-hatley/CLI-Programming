#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# does-file-exist.pl
# Tells whether a file exists at the path given by $ARGV[0].
#
# Edit history:
# Tue Jun 09, 2015: Wrote it.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Encode 'encode_utf8';

sub err_msg;
sub help_msg;

# main
{
   # If number of arguments is not 1, give help and bail:
   if ( 1 != @ARGV )
   {
      err_msg;
      help_msg;
      exit 666;
   }

   # If user requests help, give help and bail:
   if ( '-h' eq $ARGV[0] || '--help' eq $ARGV[0] )
   {
      help_msg;
      exit 777;
   }

   if ( -e encode_utf8($ARGV[0]) )
   {
      say 'File exists.';
   }

   else
   {
      say 'No such file.';
   }

   exit 0;
} # end MAIN

sub err_msg
{
   print ((<<'   END_OF_ERROR') =~ s/^   //gmr);
   Error: you types ${\scalar(@ARGV)} arguments,
   but does-file-exist.pl takes exactly 1 argument,
   which must be a file name to test for existance.

   END_OF_ERROR
   return 1;
}

sub help_msg
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "does-file-exist.pl", Robbie Hatley's nifty program for
   determining whether a file exists at a given path. This program takes
   exactly 1 argument, which will be interpreted as a proposed path
   to be tested for file existance.

   Exception: if the argument is -h or --help then this help will be given
   instead.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help_msg
