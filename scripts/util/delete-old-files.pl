#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# delete-old-files.pl
# Deletes all regular files in the current directory (and all subdirectories if a -r or --recurse option is used) which
# were modified more than a given time (in days) ago (default is 365.2422 days).
#
# This program skips all directory entries with names "." or ".." or suffixes "*.db", "*.ini", and "*.jbf", all names
# which don't point to something that exists, and all files which are directories or link or aren't regular files.
# If any regexps are given, this program also skips all files with names that don't match at least one of those regexps.
#
# Edit history:
# Thu Apr 01, 2021: Wrote first draft.
# Fri Apr 02, 2021: Made maximum age user-specifiable, and made regexps require delimiters so that qr options can be
#                   used. Also cleaned-up some comments and formatting.
# Thu Jun 24, 2021: Changed default age to 365.2422 days and added clarifying comments to curfile($).
# Tue Nov 16, 2021: Now using common::sense, and now using extended regexp sequences instead of regexp delimiters.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "Sys::Binmode".
# Fri Dec 03, 2021: Now using just 1 regexp. (Use alternation instead of multiple regexps.)
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Time::HiRes 'time';
use Cwd;
use POSIX 'floor', 'ceil';
use RH::Util;
use RH::Dir;

# Turn on debugging?
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv    ()  ; # Process @ARGV.
sub curdire ()  ; # Process current directory.
sub curfile ($) ; # Process current file.
sub stats   ()  ; # Print statistics.
sub help    ()  ; # Print help.

# ======= VARIABLES: ===================================================================================================

# Use debugging? (Ie, print extra diagnostics?)
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

# Settings:                  Meaning:                     Range:    Default:
my $Recurse = 0          ; # Recurse subdirectories?      bool      0 (don't recurse)
my $Emulate = 0          ; # Just emulate?                bool      0 (don't emulate)
my $Target  = 'F'        ; # Files, dirs, both, all?      F|D|B|A   'F' (files only)
my $RegExp  = qr/^.+$/o  ; # Regular Expression.          regexp    qr/^.+$/o (matches all strings)
my $Yes     = 0          ; # Proceed without prompting?   bool      prompt
my $Limit   = 365.2422   ; # Maximum age in days.         float     365.2422 days

# Counters:
my $direcount = 0; # Count of directories processed.
my $filecount = 0; # Count of files processed.
my $skipcount = 0; # Count of files skipped.
my $attecount = 0; # Count of file deletion attempts.
my $delecount = 0; # Count of file deletion successes.
my $failcount = 0; # Count of file deletion failures.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   argv;
   say "\nNow entering program \"" . get_name_from_path($0) . "\".";
   say "Recurse = $Recurse";
   say "Target  = $Target";
   say "RegExp  = $RegExp";
   say "Emulate = $Emulate";
   say "Yes     = $Yes";
   say "Limit   = $Limit";

   unless ($db || $Yes || $Emulate)
   {
      print STDOUT "\nWARNING: THIS PROGRAM WILL DELETE ALL TARGETED FILES\n",
                   "IN THE CURRENT DIRECTORY\n";
      print STDOUT "AND IN ALL OF ITS SUBDIRECTORIES\n" if $Recurse;
      print STDOUT "WHICH HAVE NOT BEEN MODIFIED IN OVER ", $Limit, " DAYS.\n",
                   "\nARE YOU SURE THAT THIS IS WHAT YOU REALLY WANT TO DO???\n",
                   "\nPress \"&\" (shift-7) to continue or any other key to abort.\n";
      my $char = get_character;
      exit 0 unless '&' eq $char;
   }

   $Recurse and RecurseDirs {curdire} or curdire;

   # Print stats:
   stats;

   # We be done, so scram:
   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

# Process @ARGV :
sub argv ()
{
   for ( my $i = 0 ; $i < @ARGV ; ++$i )
   {
      $_ = $ARGV[$i];
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
            if ('-h' eq $_ || '--help'      eq $_ ) {help; exit 777;}
         elsif ('-r' eq $_ || '--recurse'   eq $_ ) {$Recurse =   1;}
         elsif ('-e' eq $_ || '--emulate'   eq $_ ) {$Emulate =   1;}
         elsif ('-y' eq $_ || '--yes'       eq $_ ) {$Yes     =   1;}
         elsif (/^--age=(\d+\.?\d*)$/             ) {$Limit   =  $1;}
         splice @ARGV, $i, 1; # Remove option from @ARGV.
         --$i; # Move index 1-left, so that the "++$i" above moves index back to current spot, with new item.
      }
   }
   my $NA = scalar(@ARGV);
   given ($NA)
   {
      when (0) {                       ;} # Do nothing.
      when (1) {$RegExp = qr/$ARGV[0]/o;} # Set $RegExp.
      default  {error($NA)             ;} # Print error and help messages then exit 666.
   }
   return 1;
} # end sub argv ()

# Process current directory:
sub curdire ()
{
   # Increment directory counter:
   ++$direcount;

   # Get and announce current working directory:
   my $cwd = cwd_utf8;
   say "\nDirectory # $direcount: $cwd\n";

   # Get list of file-info packets in $cwd matching $Target and $RegExp:
   my $curdirfiles = GetFiles($cwd, $Target, $RegExp);

   # Iterate through $curdirfiles and send each file to curfile():
   foreach my $file (@{$curdirfiles})
   {
      curfile($file);
   }
   return 1;
} # end sub curdire ()

# Process current file:
sub curfile ($)
{
   # Increment file counter:
   ++$filecount;

   # Get file, path, name, suffix, and age:
   my $file   = shift;
   my $path   = $file->{Path};
   my $name   = $file->{Name};
   my $suffix = get_suffix($name);
   my $age    = time() - $file->{Mtime};

   # Skip this file if its suffix is '.ini', '.db', or '.jbf':
   if ($suffix eq '.ini' || $suffix eq '.db' || $suffix eq '.jbf') 
   {
      ++$skipcount; 
      return 1;
   }

   # Skip this file if its age is less than the given age in days
   # (defaults to 365.2422 days = 1 year):
   if ($age <= int(floor($Limit * 24 * 3600 + 0.5)))
   {
      ++$skipcount;
      return 1;
   }

   # If we get to here, this file is scheduled for deletion, so increment the "deletion attempts" counter:
   ++$attecount;

   # If just emulating, print the name of the file we would have deleted and return 1:
   if ($Emulate)
   {
      say "Would have deleted \"$name\".";
      return 1;
   }

   # Otherwise, attempt to unlink_utf8 $name:
   else
   {
      unlink_utf8($name)
      and ++$delecount
      and print STDOUT "Deleted \"$name\".\n"
      and return 1
      or ++$failcount
      and print STDERR "Failed to delete \"$name\".\n$!\n"
      and return 0;
   }
} # end sub curfile ($)

sub stats ()
{
   print STDOUT "\nStatistics for program \"delete-old-files.pl\":\n";
   if ($Emulate)
   {
      print STDOUT
      "Note: This program was run in simulation mode,\n",
      "so no deletions were actually performed.\n",
      "Navigated $direcount directories.\n",
      "Skipped $skipcount young and/or non-targeted files.\n",
      "Simulated $attecount old-file deletion attempts.\n",
   }
   else
   {
      print STDOUT
      "Navigated $direcount directories.\n",
      "Skipped $skipcount young and/or non-targeted files.\n",
      "Attempted to delete $attecount old files.\n",
      "Successfully deleted $delecount old files.\n",
      "Failed $failcount file deletion attempts.\n";
   }
   return 1;
} # end sub stats ()

sub error ($)
{
   my $NA = shift;
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: you typed $NA arguments, but this program takes at most 1 argument,
   which, if present, must be a Perl-Compliant Regular Expression specifying
   which directory entries to process. Help follows:

   END_OF_ERROR
   help;
   exit 666;
} # end sub error ($)

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "delete-old-files.pl", Robbie Hatley's old-file-deletion program.
   Deletes all files in the current directory (and all subdirectories, if a -r or
   --recurse option is used) which were modified more than a given time (in days)
   ago (default is 365.2422 days).

   This program skips all directory entries with names "." or ".." or suffixes
   "*.db", "*.ini", and "*.jbf", all names which don't point to something that
   exists, and all files which are directories or links or aren't regular files.

   If one or more regexps are given as arguments, this program also skips all
   files which don't match at least one of those regexps.

   This program should not be run frivolously, because it can permanently delete
   a large number of files all at once. Hence it prompts the user "ARE YOU SURE
   THAT THAT IS WHAT YOU ACTUALLY WANT TO DO???" unless debugging, emulating, or
   acting in no-prompt mode.

   Command line:
   delete-old-files.pl [options] [arguments]

   Description of options:
   Option:                  Meaning:
   "-h" or "--help"         Print help and exit.
   "-r" or "--recurse"      Recurse subdirectories.
   "-y" or "--yes"          Delete all old files without prompting.
   "-e" or "--emulate"      Merely simulate renames.
   "--age=###"              Set max age (where "###" is any positive real number)
   (Defaults are: no help, no recurse, no yes, no emulate, age = "365.2422 days".)
   All other options are ignored.

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

   Example program invocation:
   To delete all files with "cat", "dog", or "horse" (title-cased or not) in
   their names, in any subdirectory, which are older than 275 days, type this:
   delete-old-files.pl -y -r --age=275 '(?i:c)at|(?i:d)og|(?i:h)orse'

   Happy old-file deleting!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
