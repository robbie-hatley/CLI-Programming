#! /bin/perl -CSDA

# This is a 110-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# age.pl
# Lists files in current directory (and all subdirs if -r or --recurse is used) in decreasing order of age,
# and prints age in days for each file.
#
# Edit history:
# Mon Jul 05, 2021: Wrote it.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and
#                   "Sys::Binmode".
# Fri Aug 04, 2023: Reduced width from 120 to 110. Upgraded from "v5.32" to "v5.36". Got rid of
#                   "common::sense" (antiquated). Now using "strict", "warnings", "utf8". Got rid of all
#                   prototypes (now using signatures instead). Shortened name of sub "tree_stats" to "stats".
#                   Now using "d getcwd" instead of "cwd_utf8". Changed "--target=xxxx" to just "--xxxx".
#                   Put headers in help.
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

use Sys::Binmode;
use Cwd;
use Time::HiRes 'time';

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv    ;
sub curdire ;
sub stats   ;
sub error   ;
sub help    ;

# ======= VARIABLES: =========================================================================================

# Use debugging? (Ie, print extra diagnostics?)
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

# Settings:   Default:       Meaning of setting:       Range:    Meaning of default:
my $Recurse = 0          ; # Recurse subdirectories?   bool      don't recurse
my $Target  = 'F'        ; # Target                    F|D|B|A   regular files only
my $RegExp  = qr/^.+$/o  ; # Regular Expression.       regexp    all file names

# Counts of events in this program:
my $direcount = 0; # Count of directories processed.
my $filecount = 0; # Count of files processed.

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   my $pname = get_name_from_path($0);
   argv;
   say STDERR "\nNow entering program \"$pname\".";
   say STDERR "Recurse = $Recurse";
   say STDERR "Target  = $Target";
   say STDERR "RegExp  = $RegExp";
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $ms = 1000 * ($t0 - time);
   printf STDERR "\nNow exiting program \"%s\". Execution time was %.3fms.", $pname, $ms;
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

# Process @ARGV :
sub argv {
   # Get options and arguments:
   my @opts;
   my @args;
   for ( @ARGV ) {
      if (/^-\pL*$|^--/) {push @opts, $_}
      else               {push @args, $_}
   }

   # Process options:
   for ( @opts ) {
      /^-\pL*h|^--help$/     and help and exit 777 ;
      /^-\pL*r|^--recurse$/  and $Recurse =  1     ;
      /^-\pL*f|^--files$/    and $Target  = 'F'    ;
      /^-\pL*d|^--dirs$/     and $Target  = 'D'    ;
      /^-\pL*b|^--both$/     and $Target  = 'B'    ;
      /^-\pL*a|^--all$/      and $Target  = 'A'    ;
   }

   # Process arguments:
   my $NA = scalar(@args);
   if    ( 0 == $NA ) {                                                } # Use default settings.
   elsif ( 1 == $NA ) { $RegExp = qr/$args[0]/o                        } # Set $RegExp.
   else               { error($NA); help; exit 666                     } # Something evil happened.

   # Return success code 1 to caller:
   return 1;
} # end sub argv

# Process current directory:
sub curdire {
   # Increment directory counter:
   ++$direcount;

   # Get and announce current working directory:
   my $cwd = d getcwd;
   say STDOUT "\nDirectory #$direcount: $cwd\n";

   # Get list of file-info packets in $cwd matching $Target and $RegExp:
   my $curdirfiles = GetFiles($cwd, $Target, $RegExp);

   # Make array of refs to file-info hashes, sorted in order of increasing age:
   my @Files = sort {$b->{Mtime} <=> $a->{Mtime}} @{$curdirfiles};

   # Print header:
   say STDOUT '   Age  File  Size      # of   Name   ';
   say STDOUT '(days)  Type  (bytes)   Links  of file';

   # Iterate through $Files and print info for each file in order of d:
   foreach my $file (@Files)
   {
      ++$filecount;
      my $age = (time() - $file->{Mtime}) / 86400;
      printf STDOUT " %5u    %-1s   %-8.2E  %5u  %-s\n",
         $age, $file->{Type}, $file->{Size}, $file->{Nlink}, $file->{Name};
   }
   return 1;
} # end sub curdire

sub stats {
   say "Navigated $direcount directories.";
   say "Processed $filecount files.";
   return 1;
} # end sub stats

sub error ($NA) {
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: you typed $NA arguments, but this program takes at most 1 argument,
   which, if present, must be a Perl-Compliant Regular Expression specifying
   which directory entries to process. Help follows:
   END_OF_ERROR
} # end sub error

sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "age.pl", Robbie Hatley's Nifty list-files-by-age utility. This
   program will list all files in the current directory (and all subdirectories if
   a -r or --recurse option is used) in increasing order of age. Each listing line
   will give the following pieces of information about a file:
   1. Age of file in days.
   2. Type of file (single-letter code, one of NTYXOPSLMDHFU).
   3. Size of file in format #.##E+##
   4. Name of file.

   -------------------------------------------------------------------------------
   Meanings of Type Letters:

   B - Broken symbolic link
   D - Directory
   F - regular File
   H - regular file with multiple Hard links
   L - symbolic Link to regular file
   N - Nonexistent
   O - sOcket
   P - Pipe
   S - Symbolic link to directory
   T - opens to a Tty
   U - Unknown
   W - symbolic link to something Weird (not a regular file or directory)
   X - block special file
   Y - character special file

   -------------------------------------------------------------------------------
   Command Lines:

   age.pl [-h|--help]             (to print this help and exit)
   age.pl [options] [Argument]    (to list files by increasing age)

   -------------------------------------------------------------------------------
   Description of Options:

   Option:           Meaning:
   -h or --help      Print help and exit.
   -r or --recurse   Recurse subdirectories.
   -f or --files     List files only.
   -d or --dirs      List directories only.
   -b or --both      List files and directories.
   -a or --all       List everything.
   (Defaults are: no help, no recurse, list files only.)

   -------------------------------------------------------------------------------
   Description of Arguments:

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

   A number of arguments other than 0 or 1 will cause this program to print an
   error message and abort.

   Happy files-by-age listing!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
