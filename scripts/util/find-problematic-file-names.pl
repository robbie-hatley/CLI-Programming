#!/usr/bin/env -S perl -CSDA

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# "find-problematic-file-names.pl"
# Finds directory entries with names containing problematic characters.
#
# Written by Robbie Hatley on Wednesday, March 27th, 2024.
#
# Edit history:
# Wed Mar 27, 2024: Wrote it.
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

use Time::HiRes 'time';
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv    :prototype()  ; # Process @ARGV.
sub curdire :prototype()  ; # Process current directory.
sub curfile :prototype($) ; # Process current file.
sub stats   :prototype()  ; # Print statistics.
sub error   :prototype($) ; # Handle errors.
sub help    :prototype()  ; # Print help and exit.

# ======= VARIABLES: =========================================================================================

# Turn on debugging?
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

#Program Settings:             Meaning:                 Range:     Default:
my $Recurse   = 0          ; # Recurse subdirectories?  (bool)     0
my $Verbose   = 0          ; # Be verbose?              (bool)     0
my $Target    = 'A'        ; # Target                   (F|D|B|A)  'A'
my $Regexp    = qr/^.+$/   ; # Regular expression.      (regexp)   qr/^.+$/

# Counters:
my $direcount = 0; # Count of directories processed by curdire().
my $filecount = 0; # Count of    files    processed by curfile().
my $probcount = 0; # Count of problematic file names found.

# Regexps:
my $problematic = qr@[\[\](){}<>`'"^\$!#&*:;=?^~\\|/\pC]@;
say "\$problematic = \"$problematic\"";

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   argv;
   print
   (
      STDERR
      "\n"
    . "Now entering program \"" . get_name_from_path($0) . "\".\n"
    . "Recurse = $Recurse\n"
    . "Target  = $Target\n"
    . "Regexp  = $Regexp\n"
    . "\n"
   );
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $t1 = time; my $te = $t1 - $t0;
   print
   (
      STDERR
      "\n"
    . "Now exiting program \"" . get_name_from_path($0) . "\";\n"
    . "execution time was $te seconds.\n"
    . "\n"
   );
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

sub argv :prototype() {
   for ( my $i = 0 ; $i < @ARGV ; ++$i ) {
      $_ = $ARGV[$i];
      if (/^-[\pL]{1,}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/) {
            if ( $_ eq '-h' || $_ eq '--help'         ) {help; exit 777;}
         elsif ( $_ eq '-l' || $_ eq '--local'        ) {$Recurse =  0 ;} # Default
         elsif ( $_ eq '-r' || $_ eq '--recurse'      ) {$Recurse =  1 ;}
         elsif ( $_ eq '-q' || $_ eq '--quiet'        ) {$Verbose =  0 ;} # Default
         elsif ( $_ eq '-v' || $_ eq '--verbose'      ) {$Verbose =  1 ;}
         elsif ( $_ eq '-f' || $_ eq '--target=files' ) {$Target  = 'F';}
         elsif ( $_ eq '-d' || $_ eq '--target=dirs'  ) {$Target  = 'D';}
         elsif ( $_ eq '-b' || $_ eq '--target=both'  ) {$Target  = 'B';}
         elsif ( $_ eq '-a' || $_ eq '--target=all'   ) {$Target  = 'A';} # Default

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
   if    ( 0 == $NA ) {                                   ;} # If no argument, do nothing.
   elsif ( 1 == $NA ) {$Regexp = shift(@ARGV)             ;} # If 1  argument, set $Regexp to argument.
   else               {error($NA) and help() and exit 666 ;} # More than 1 argument is an error.
   return 1;
} # end sub argv

sub curdire :prototype() {
   ++$direcount;
   my $curdir = cwd_utf8;
   if ($Verbose)
   {
      print
      (
         STDOUT
         "\n"
       . "Dir # $direcount: $curdir\n"
       . "\n"
      );
   }
   my $curdirfiles = GetFiles($curdir, $Target, $Regexp);
   foreach my $file ( @{$curdirfiles} ) {
      curfile($file);
   }
   return 1;
} # end sub curdire

sub curfile :prototype($) ($file) {
   ++$filecount;
   if ($file->{Name} =~ m@$problematic@) {
      ++$probcount;
      print(STDOUT "$file->{Path}\n");
   }
   return 1;
} # end sub curfile

sub stats :prototype() {
   print
   (
      STDERR
      "\n"
    . "Navigated $direcount directories.\n"
    . "Processed $filecount files.\n"
    . "Found $probcount problematic file names.\n"
    . "\n"
   );
   return 1;
} # end sub stats

sub error :prototype($) ($NA) {
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: you typed $NA arguments, but \"find-problematic-file-names.pl\"
   takes at most 1 argument, which, if present, must be a regular expression
   specifying which directory entries to process. (Did you forget to put
   your regexp in 'single quotes'?)
   END_OF_ERROR
   return 1;
} # end sub error

sub help :prototype() {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   Welcome to "find-problematic-file-names.pl", Robbie Hatley's nifty finder of
   files with names containing characters which are problematic in Linux and/or
   Windows.

   Command line:
   find-spacey-names.pl [options] [argument]

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   "-l" or "--local"            Don't recurse subdirectories.      (Default.)
   "-r" or "--recurse"          Do    recurse subdirectories.
   "-v" or "--verbose"          Don't print directories & stats.   (Default.)
   "-v" or "--verbose"          Do    print directories & stats.
   "-f" or "--target=files"     Target files only.
   "-d" or "--target=dirs"      Target directories only.
   "-b" or "--target=both"      Target both files and directories.
   "-a" or "--target=all"       Target ALL directory entries.      (Default.)

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

   If the number of arguments is not 0 or 1, this program will print an
   error message and abort.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
