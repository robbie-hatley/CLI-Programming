#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# myprog.pl
# "MyProg" is a program which [insert description here].
# Written by Robbie Hatley.
# Edit history:
# Sat Jun 05, 2021: Wrote it.
########################################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;

use Sys::Binmode;
use Time::HiRes 'time';
use File::Type;

use RH::Dir;
use RH::Util;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv    ; # Process @ARGV.
sub curdire ; # Process current directory.
sub curfile ; # Process current file.
sub stats   ; # Print statistics.
sub error   ; # Handle errors.
sub help    ; # Print help and exit.

# ======= VARIABLES: ===================================================================================================

# Settings:                    Meaning:                     Range:    Default:
my $db        = 0          ; # Debug (print diagnostics)?   bool      0 (Don't print diagnostics.)
my $Recurse   = 1          ; # Recurse subdirectories?      bool      1 (Recurse.)
my $RegExp    = qr/^.+$/o  ; # Regular Expression.          regexp    qr/^.+$/o (matches all strings)

# Counters:
my $direcount = 0          ; # Count of directories processed by curdire().
my $filecount = 0          ; # Count of dir entries processed by curfile().

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   argv;
   say '';
   say "Now entering program \"" . get_name_from_path($0) . "\".";
   say "RegExp  = $RegExp";
   say "Recurse = $Recurse";
   say '';
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

# Process @ARGV :
sub argv
{
   for ( my $i = 0 ; $i < @ARGV ; ++$i )
   {
      $_ = $ARGV[$i];
      if (/^-[\pL]{1,}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
            if ( $_ eq '-h' || $_ eq '--help'         ) {help; exit 777;}
         elsif ( $_ eq '-l' || $_ eq '--local'        ) {$Recurse =  0 ;}
         elsif ( $_ eq '-r' || $_ eq '--recurse'      ) {$Recurse =  1 ;} # DEFAULT

         # Remove option from @ARGV:
         splice @ARGV, $i, 1;

         # Move the index 1-left, so that the "++$i" above
         # moves the index back to the current @ARGV element,
         # but with the new content which slid-in from the right
         # due to deletion of previous element contents:
         --$i;
      }
   }
   my $NA = scalar(@ARGV);
   if    ( 0 == $NA ) {                                  } # Do nothing.
   elsif ( 1 == $NA ) {$RegExp = qr/$ARGV[0]/o           } # Set $RegExp.
   else               {error($NA); say ''; help; exit 666} # Print error and help messages and exit 666.
   return 1;
} # end sub argv

# Process current directory:
sub curdire
{
   # Increment directory counter:
   ++$direcount;

   # Get and announce current working directory:
   my $cwd = cwd_utf8;
   say "\nDirectory # $direcount: $cwd\n";

   # Get list of fully-qualified paths of all regular files in current directory matching $RegExp:
   my @curdirpaths = glob_regexp_utf8 ($cwd, 'F', $RegExp);

   # Set-up a file-typing functor and file-type variable:
   my $typer = File::Type->new();
   my $type  = '';

   # Iterate through $curdirpaths and print the MIME type of each file:
   foreach my $path (@curdirpaths)
   {
      $type = $typer->checktype_filename($path);
      printf("%-95s = %-30s\n", $path, $type);
   }
   return 1;
} # end sub curdire

# Print statistics for this program run:
sub stats
{
   say '';
   say 'Statistics for this directory tree:';
   say "Navigated $direcount directories.";
   say "Found $filecount paths matching given regexp.";
   return 1;
} # end sub stats

# Handle errors:
sub error ($err_msg)
{
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: you typed $err_msg arguments, but this program takes at most 1 argument,
   which, if present, must be a Perl-Compliant Regular Expression specifying
   which directory entries to process.
   END_OF_ERROR
   return 1;
} # end sub error

# Print help:
sub help
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "file-types.pl", Robbie Hatley's nifty file MIME types printer.
   This program prints the MIME type of every file in the current directory
   (and all subdirectories if a -r or --recurse option is used).

   Command lines:
   file-types.pl -h | --help               (to print help and exit)
   file-types.pl [options] [arguments]     (to print MIME types of files)

   Description of options:
   Option:                 Meaning:
   "-h" or "--help"        Print this help.
   "-q" or "--quiet"       Don't be verbose.
   "-v" or "--verbose"     Do    be Verbose.     (DEFAULT)
   "-l" or "--local"       Don't recurse.
   "-r" or "--recurse"     Do    recurse.        (DEFAULT)

   Description of arguments:
   In addition to options, this program can take one optional argument which, if
   present, must be a Perl-Compliant Regular Expression specifying which items to
   process. To specify multiple patterns, use the | alternation operator.
   To apply pattern modifier letters, use an Extended RegExp Sequence.
   For example, if you want to search for items with names containing "cat",
   "dog", or "horse", title-cased or not, you could use this regexp:
   '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead. 

   Happy type printing!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
