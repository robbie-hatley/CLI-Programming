#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# file-names-to-upper.pl
# Converts names of all files in current directory to all-upper-case.
#
# Edit history:
# Tue Jun 30, 2015: Wrote it.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Wed Feb 17, 2021: Refactored to use the new GetFiles(), which now requires a fully-qualified directory as its first
#                   argument, target as second, and regexp (instead of wildcard) as third.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use RH::Util;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub process_argv              ();
sub process_current_directory ();
sub process_current_file      ($);
sub stats                     ();
sub error                     ($);
sub help                      ();

# ======= VARIABLES: ===================================================================================================

# Settings:
my $Recurse   = 0         ; # Recurse subdirectories?  (bool)
my $Target    = 'A'       ; # Target                   (F|D|B|A)
my $Regexp    = qr/^.+$/o ; # Regular expression.      (regexp)

# Counters:
my $direcount = 0         ; # Count of directories processed by process_current_directory().
my $filecount = 0         ; # Count of    files    processed by process_current_file().
my $skipcount = 0         ; # Count of files skipped.
my $renacount = 0         ; # Count of files renamed.
my $failcount = 0         ; # Count of failed attempts to rename files.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   say "\nNow entering program \"file-names-to-lower.pl\".\n";
   process_argv;
   $Recurse and RecurseDirs {process_current_directory} or process_current_directory;
   stats;
   say "\nNow exiting program \"file-names-to-lower.pl\".\n";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

sub process_argv ()
{
   my $help   = 0;  # Just print help and exit?
   my @CLArgs = (); # Command-Line Arguments (not including options).
   foreach (@ARGV)
   {
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
         /^-h$/ || /^--help$/         and $help    =  1 ;
         /^-r$/ || /^--recurse$/      and $Recurse =  1 ;
         /^-f$/ || /^--target=files$/ and $Target  = 'F';
         /^-d$/ || /^--target=dirs$/  and $Target  = 'D';
         /^-b$/ || /^--target=both$/  and $Target  = 'B';
         /^-a$/ || /^--target=all$/   and $Target  = 'A';
      }
      else {push @CLArgs, $_;}
   }
   if ($help) {help; exit 777;}             # If user wants help, print help and exit 777.
   my $NA = scalar(@CLArgs);                # Get number of arguments.
   given ($NA)                              # Given the number of arguments,
   {
      when (0) {                         ;} # if $NA == 0, do nothing;
      when (1) {$Regexp = qr/$CLArgs[0]/o;} # if $NA == 1, set $Regexp;
      default  {error($NA)               ;} # otherwise, print error and help messages and exit 666.
   }
   return 1;
} # end sub process_argv ()

sub process_current_directory ()
{
   ++$direcount;

   # Get and announce current working directory:
   my $curdir = cwd_utf8;
   say "\nDir # $direcount: $curdir\n";

   # Get list of targeted files in current directory:
   my $curdirfiles = GetFiles($curdir, $Target, $Regexp);

   # Iterate through these files, title-casing them:
   foreach my $file (@{$curdirfiles}) 
   {
      process_current_file($file);
   }
   return 1;
} # end sub process_current_directory ()

sub process_current_file ($) 
{
   ++$filecount;                       # increment file counter
   my $file = shift;                   # reference to file-info record
   my $oldname = $file->{Name};        # "Name" field of record
   my $oldpref = get_prefix($oldname); # get old prefix
   my $oldsuff = get_suffix($oldname); # get old suffix
   my $newpref = uc $oldpref;          # convert prefix to upper-case
   my $newsuff = uc $oldsuff;          # convert suffix to upper-case  
   my $newname = $newpref . $newsuff;  # create new name
   my $success = 0;                    # Did we succeed?

   if ($newname ne $oldname)           # try rename if new name different from old
   {
      $success = rename_file($oldname, $newname);
      if ($success)
      {
         say("$oldname -> $newname");
         ++$renacount;
      }
      else
      {
         warn("Failed to rename $oldname to $newname\n");
         ++$failcount;
      }
   }
   else
   {
      $success = 0;
      ++$skipcount;
   }
   return $success;
} # end sub process_current_file ($) 

sub stats ()
{
   print("\nStatistics for program \"file-names-to-upper.pl\":\n");
   say "Navigated $direcount directories.";
   say "Examined  $filecount files.";
   say "Skipped   $skipcount files.";
   say "Renamed   $renacount files.";
   say "Failed    $failcount file rename attempts.";
   return 1;
} # end sub stats ()

sub error ($)
{
   my $NA = shift;
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: You typed $NA arguments, but this program takes at most
   1 argument which, if present, must be a regular expression
   specifying which files and/or directories to process.
   Help follows:
   
   END_OF_ERROR
   help;
   exit 666;
} # end sub error ($)

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "file-names-to-upper.pl". This program converts the names of all
   files in the current directory (and all subdirectories if a -r or --recurse
   option is used) to all-upper-case.

   Command line:
   file-names-to-upper.pl [-h|--help] [-r|--recurse] [Arg1]

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   "-r" or "--recurse"          Recurse subdirectories.
   "-f" or "--target=files"     Target files only. (DEFAULT)
   "-d" or "--target=dirs"      Target directories only.
   "-b" or "--target=both"      Target both files and directories.
   "-a" or "--target=all"       Target files, directories, and symlinks.

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

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
