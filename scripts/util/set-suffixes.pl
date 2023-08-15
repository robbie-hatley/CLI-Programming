#! /bin/perl -CSDA

# This is a 110-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# set-suffixes.pl
# Sets correct file-name suffixes on files, based on File::Type and on scrutiny of file contents.
#
# Edit history:
# Mon May 04, 2015: Wrote first draft.
# Wed May 13, 2015: Updated and changed Help to "Here Document" format.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sun Feb 07, 2015: Made minor improvements.
# Sat Apr 16, 2016: Now using -CSDA.
# Tue Dec 19, 2017: Adjusted formatting, comments, err_msg, help_msg.
# Sun Jan 03, 2021: Edited.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and
#                   "Sys::Binmode".
# Sat Aug 12, 2023: Reduced width from 120 to 110. Upgraded from "v5.32" to "v5.38". Got rid of
#                   "common::sense" (antiquated). Got rid of all prototypes. Now using signatures.
# Sun Aug 13, 2023: Added section headers to help. Renamed from "set-extensions.pl" to "set-suffixes.pl".
##############################################################################################################

use v5.38;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

use Sys::Binmode;
use Cwd;
use File::Type;
use Time::HiRes 'time';

use RH::Util;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv    ;
sub curdire ;
sub curfile ;
sub stats   ;
sub error   ;
sub help    ;

# ======= PAGE-GLOBAL LEXICAL VARIABLES: =====================================================================

# Settings:                   Meaning of setting:         Range:    Meaning of default:
my $db        = 0         ; # Debug?                      bool      Don't debug.
my $Verbose   = 0         ; # Be verbose?                 bool      Be quiet.
my $Recurse   = 0         ; # Recurse subdirectories?     bool      Don't recurse subdirectories.
my $RegExp    = qr/^.+$/o ; # Process which file names?   regexp    Process files of all names.

# Event counters:
my $direcount = 0; # Count of directories processed.
my $filecount = 0; # Count of files processed.
my $typecount = 0; # Count of files of known type.
my $unkncount = 0; # Count of files of unknown type.
my $samecount = 0; # Count of files with new name same as old.
my $diffcount = 0; # Count of files with new name different from old.
my $renacount = 0; # Count of files successfully renamed.
my $failcount = 0; # Count of failed file-rename attempts.

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   argv;
   my $pname = get_name_from_path($0);
   if ( $Verbose >= 1 ) {
      say STDERR '';
      say STDERR "Now entering program \"$pname\".";
      say STDERR "\$db      = \"$db\".";
      say STDERR "\$Verbose = \"$Verbose\".";
      say STDERR "\$Recurse = \"$Recurse\".";
      say STDERR "\$RegExp  = \"$RegExp\".";
   }
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $ms = 1000 * (time - $t0);
   if ( $Verbose >= 1 ) {
      printf STDERR "\nNow exiting program \"%s\". Execution time was %.3fms.", $pname, $ms;
   }
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS =============================================================================

sub argv {
   # Get options and arguments:
   my @opts = (); my @args = (); my $end_of_options = 0;
   for ( @ARGV ) {
      /^--$/ and $end_of_options = 1 and next;
      !$end_of_options && /^-\pL*$|^--.+$/ and push @opts, $_ or push @args, $_;
   }

   # Process options:
   for ( @opts ) {
      /^-\pL*h|^--help$/     and help and exit 777 ;
      /^-\pL*n|^--nodebug$/  and $db      =  0     ;
      /^-\pL*e|^--debug$/    and $db      =  1     ;
      /^-\pL*q|^--quiet$/    and $Verbose =  0     ;
      /^-\pL*v|^--Verbose$/  and $Verbose =  1     ;
      /^-\pL*l|^--local$/    and $Recurse =  0     ;
      /^-\pL*r|^--recurse$/  and $Recurse =  1     ;
   }
   $db and say STDERR "opts = (@opts)\nargs = (@args)";

   # Count args:
   my $NA = scalar @args;

   # Take various actions depending on $NA:
   $NA  < 1 and 1;                                   # If $NA  < 1, do nothing
   $NA == 1 and $RegExp = $ARGV[0];                  # If $NA == 1, set $RegExp.
   $NA  > 1 and error($NA) and help and exit 666;    # If $NA  > 1, print error and help and exit 666.

   # Return success code 1 to caller:
   return 1;
} # end sub argv ()

sub curdire {
   ++$direcount;
   my $curdir = cwd_utf8;
   say STDOUT '';
   say STDOUT "Directory # $direcount: $curdir";
   my @paths = glob_regexp_utf8($curdir, 'F', $RegExp);
   for my $path (@paths) {
      next unless is_data_file($path);
      curfile $path;
   }
   return 1;
} # end sub curdire ()

sub curfile ($path) {
   ++$filecount;
   my $name = get_name_from_path($path);
   my $new_suff = get_correct_suffix($path);
   # If new suffix is '.unk', increment $unkncount, otherwise increment $typecount:
   $new_suff eq '.unk' and ++$unkncount or ++$typecount;

   if ($db) {
      say STDERR '';
      say STDERR "In \"set-suffixes.pl\", in curfile, after getting new suffix.";
      say STDERR "\$filecount = \"$filecount\".";
      say STDERR "\$path  = \"$path\".";
      say STDERR "\$new_suff  = \"$new_suff\".";
   }

   # Make new name and path:
   my $new_name = get_prefix($name) . $new_suff;
   my $cwd = d getcwd;
   my $new_path = path($cwd, $new_name);
   # Increment "same" counter if new name is same as old name, else increment "diff" counter:
   $new_name eq $name and ++$samecount or  ++$diffcount;

   if ($db) {
      say STDERR '';
      say STDERR "In \"set-suffixes.pl\", in curfile, after making new name and path.";
      say STDERR "old name = \"$name\".";
      say STDERR "new name = \"$new_name\".";
      say STDERR "new path = \"$new_path\".";
      say STDERR "old and new names are DIFFERENT" if $new_name ne $name;
      say STDERR "old and new names are SAME"      if $new_name eq $name;
   }

   # If new name is same as old name, exit subroutine here and move on to next file:
   if ( $new_name eq $name ) {
      say STDOUT "Kept name: \"$name\"";
      return 1;
   }

   # Otherwise, attempt rename:
   else {
      rename_file($path, $new_path)
      and ++$renacount
      and say STDOUT "Renamed:   \"$name\" => \"$new_name\""
      and return 1
      or  ++$failcount
      and say STDOUT "Failed:    \"$name\" => \"$new_name\""
      and return 0;
   }
   say STDOUT "Over the cobbles he clattered and clashed in the dark inn yard.";
   say STDOUT "He tapped with his whip on the shutters, but all was locked and barred.";
   return 666;
} # end sub curfile ($path)

sub stats {
   if ( $Verbose >= 1 ){
      say STDERR '';
      say STDERR "Stats for \"set-suffixes.pl\":";
      say STDERR "Navigated $direcount directories.";
      say STDERR "Encountered $filecount files.";
      say STDERR "Found $typecount files of known type.";
      say STDERR "Found $unkncount files of unknown type.";
      say STDERR "Found $samecount files with correct suffix.";
      say STDERR "Found $diffcount files with  wrong  suffix.";
      say STDERR "Successfully renamed $renacount files.";
      say STDERR "Tried but failed to rename $failcount files.";
   }
   return 1;
} # end sub stats

# Handle errors:
sub error ($NA) {
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: you typed $NA arguments, but this program takes at most
   one argument, which, if present, must be a regular expression describing
   which items to process. Help follows:
   END_OF_ERROR
   return 1;
} # end sub error ($NA)

sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "set-suffixes.pl" (suggested BASH alias "sxt"), Robbie Hatley's
   nifty file name extension setter. sxt determines the types of the files in the
   current directory (and all subdirectories if a -r or --recurse option is used)
   and sets their file name extensions accordingly. For example, if sxt finds a
   file named "cat.txt" which is actually a jpg image file, sxt will rename the
   file to "cat.jpg".

   -------------------------------------------------------------------------------
   Command lines:

   set-extensions.pl [-h|--help]            (to print this help and exit)
   set-extensions.pl [options] [argument]   (to set file-name extensions)

   -------------------------------------------------------------------------------
   Description of options:

   Option:                  Meaning:
   "-h" or "--help"         Print this help and exit.
   "-r" or "--recurse"      Recurse subdirectories (but not SYMLINKDs).

   -------------------------------------------------------------------------------
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

   Happy extension setting!
   Cheers, Robbie Hatley, programmer.
   END_OF_HELP
   return 1;
} # end sub help
__END__
